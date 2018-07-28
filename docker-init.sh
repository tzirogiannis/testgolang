#!/bin/bash

PROJECT_NAME=app
BIN="/usr/local/bin/docker-compose"
YAMLFILE=docker-compose.yml
OPTS="-f $YAMLFILE -p $PROJECT_NAME"
UPOPTS="-d --build"
GOURL='http://localhost'
#UPOPTS="-d --no-recreate --no-build --no-deps"

deploy() {
  eval $BIN $OPTS up $UPOPTS
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "Failure in deploying app"; fi
}

rollback() {
  eval $BIN $OPTS down
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "Failure in rolling back app"; fi
}

status() {
  eval $BIN $OPTS top
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "Failure in getting status - check docker is running"; exit; fi
  echo
  eval $BIN $OPTS ps
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "Failure in getting status - check docker is running"; exit; fi
  echo
  eval docker ps
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "Failure in getting status - check docker is running"; exit; fi
}

smoketest() {
  RETVAL=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $GOURL)
  if [[ "$RETVAL" -ne 200 ]] ; then
    echo "Smoke Test Failed - golang app is dead"
  else
    echo "Smoke Test Passed - golang app is alive"
  fi
}

functionaltest() {
  LB1=$(curl -s $GOURL | grep "Hi there, I'm served from" | cut -f6 -d " ")
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "FAILED: Failure in getting load balancer 1 container"; exit; fi

  LB2=$(curl -s $GOURL | grep "Hi there, I'm served from" | cut -f6 -d " ")
  RETVAL=$?
  if [ ${RETVAL} -ne 0 ]; then echo "FAILED: Failure in getting load balancer 2 container"; exit; fi

  if [[ "$LB1" != "$LB2" ]] ; then
    echo "PASSED: Load Balancer 1 Container: $LB1 Load Balancer 2 Container: $LB2"
  else
    echo "FAILED: Load Balancer not in round robin"
  fi
}

case "$1" in
    deploy)
        deploy
        ;;

    rollback)
        rollback
        ;;

    restart)
        rollback
        deploy
        ;;

    status)
        status
        ;;
        
    smoketest)
        smoketest
        ;;

    functionaltest)
        functionaltest
        ;;

    *)
        echo $"Usage: $0 {deploy|rollback|restart|staus|smoketest|functionaltest}"
        exit 2
        ;;
esac

exit 0