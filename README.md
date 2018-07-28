# mvp test golang app overview #

Deploy and test a sample golang app using the default nginx round robin load balancing scheme across 2 nodes

## Pre-requisites ###
Docker and Git

## Example docker-init.sh command usage ###

### Available options ###

```bash
➜  testgolang ./docker-init.sh
Usage: ./docker-init.sh {deploy|rollback|restart|staus|smoketest|functionaltest}
```

### deploy ###

```bash
➜  testgolang ./docker-init.sh deploy
Building backend1
Step 1/9 : FROM golang:alpine
 ---> 34d3217973fd
Step 2/9 : RUN mkdir /app
 ---> Using cache
 ---> 5204ac8e1ec1
Step 3/9 : ADD . /app/
 ---> Using cache
 ---> bbe64deaada4
Step 4/9 : WORKDIR /app
 ---> Using cache
 ---> 1a94e79b13f3
Step 5/9 : RUN go build -o main .
 ---> Using cache
 ---> e6bc030f64db
Step 6/9 : RUN adduser -S -D -H -h /app appuser
 ---> Using cache
 ---> ecbaada7f0ce
Step 7/9 : USER appuser
 ---> Using cache
 ---> 3fc1de52c779
Step 8/9 : CMD ["./main"]
 ---> Using cache
 ---> 997dc8d40ce3
Step 9/9 : EXPOSE 8484
 ---> Using cache
 ---> fc2e7350569d

Successfully built fc2e7350569d
Successfully tagged app_backend1:latest
Building backend2
Step 1/9 : FROM golang:alpine
 ---> 34d3217973fd
Step 2/9 : RUN mkdir /app
 ---> Using cache
 ---> 5204ac8e1ec1
Step 3/9 : ADD . /app/
 ---> Using cache
 ---> bbe64deaada4
Step 4/9 : WORKDIR /app
 ---> Using cache
 ---> 1a94e79b13f3
Step 5/9 : RUN go build -o main .
 ---> Using cache
 ---> e6bc030f64db
Step 6/9 : RUN adduser -S -D -H -h /app appuser
 ---> Using cache
 ---> ecbaada7f0ce
Step 7/9 : USER appuser
 ---> Using cache
 ---> 3fc1de52c779
Step 8/9 : CMD ["./main"]
 ---> Using cache
 ---> 997dc8d40ce3
Step 9/9 : EXPOSE 8484
 ---> Using cache
 ---> fc2e7350569d

Successfully built fc2e7350569d
Successfully tagged app_backend2:latest
Building nginx
Step 1/4 : FROM nginx:1.13-alpine
 ---> ebe2c7c61055
Step 2/4 : COPY nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> dab59347f417
Step 3/4 : EXPOSE 80
 ---> Using cache
 ---> f1342efb96c1
Step 4/4 : CMD ["nginx", "-g", "daemon off;"]
 ---> Using cache
 ---> f25d27750d09

Successfully built f25d27750d09
Successfully tagged app_nginx:latest
backend2 is up-to-date
backend1 is up-to-date
app_nginx_1 is up-to-date

```

### stutus ###

```bash
➜  testgolang ./docker-init.sh status
app_nginx_1
PID    USER   TIME                    COMMAND                  
---------------------------------------------------------------
5132   root   0:00   nginx: master process nginx -g daemon off;
5248   rpc    0:00   nginx: worker process                     

backend1
PID    USER   TIME   COMMAND
----------------------------
4809   rpc    0:00   ./main 

backend2
PID    USER   TIME   COMMAND
----------------------------
4815   rpc    0:00   ./main 

   Name             Command          State         Ports       
---------------------------------------------------------------
app_nginx_1   nginx -g daemon off;   Up      0.0.0.0:80->80/tcp
backend1      ./main                 Up      8484/tcp          
backend2      ./main                 Up      8484/tcp          

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
0277eb495f4b        app_nginx           "nginx -g 'daemon of…"   22 minutes ago      Up 22 minutes       0.0.0.0:80->80/tcp   app_nginx_1
679bf5c587e5        app_backend2        "./main"                 22 minutes ago      Up 22 minutes       8484/tcp             backend2
f3a8fc02680c        app_backend1        "./main"                 22 minutes ago      Up 22 minutes       8484/tcp             backend1
```

### smoketest ###

```bash
➜  testgolang ./docker-init.sh smoketest
Smoke Test Passed - golang app is alive
```

### functionaltest ###

```bash
➜  testgolang ./docker-init.sh functionaltest
PASSED: Load Balancer 1 Container: f3a8fc02680c! Load Balancer 2 Container: 679bf5c587e5!
```

### rollback ###

```bash
➜  testgolang ./docker-init.sh rollback      
Stopping app_nginx_1 ... done
Stopping backend2    ... done
Stopping backend1    ... done
Removing app_nginx_1 ... done
Removing backend2    ... done
Removing backend1    ... done
Removing network app_goappnet
```

### restart ###

```bash
➜  testgolang ./docker-init.sh restart  
Stopping app_nginx_1 ... done
Stopping backend1    ... done
Stopping backend2    ... done
Removing app_nginx_1 ... done
Removing backend1    ... done
Removing backend2    ... done
Removing network app_goappnet
Creating network "app_goappnet" with driver "bridge"
Building backend1
Step 1/9 : FROM golang:alpine
 ---> 34d3217973fd
Step 2/9 : RUN mkdir /app
 ---> Using cache
 ---> 5204ac8e1ec1
Step 3/9 : ADD . /app/
 ---> Using cache
 ---> bbe64deaada4
Step 4/9 : WORKDIR /app
 ---> Using cache
 ---> 1a94e79b13f3
Step 5/9 : RUN go build -o main .
 ---> Using cache
 ---> e6bc030f64db
Step 6/9 : RUN adduser -S -D -H -h /app appuser
 ---> Using cache
 ---> ecbaada7f0ce
Step 7/9 : USER appuser
 ---> Using cache
 ---> 3fc1de52c779
Step 8/9 : CMD ["./main"]
 ---> Using cache
 ---> 997dc8d40ce3
Step 9/9 : EXPOSE 8484
 ---> Using cache
 ---> fc2e7350569d

Successfully built fc2e7350569d
Successfully tagged app_backend1:latest
Building backend2
Step 1/9 : FROM golang:alpine
 ---> 34d3217973fd
Step 2/9 : RUN mkdir /app
 ---> Using cache
 ---> 5204ac8e1ec1
Step 3/9 : ADD . /app/
 ---> Using cache
 ---> bbe64deaada4
Step 4/9 : WORKDIR /app
 ---> Using cache
 ---> 1a94e79b13f3
Step 5/9 : RUN go build -o main .
 ---> Using cache
 ---> e6bc030f64db
Step 6/9 : RUN adduser -S -D -H -h /app appuser
 ---> Using cache
 ---> ecbaada7f0ce
Step 7/9 : USER appuser
 ---> Using cache
 ---> 3fc1de52c779
Step 8/9 : CMD ["./main"]
 ---> Using cache
 ---> 997dc8d40ce3
Step 9/9 : EXPOSE 8484
 ---> Using cache
 ---> fc2e7350569d

Successfully built fc2e7350569d
Successfully tagged app_backend2:latest
Building nginx
Step 1/4 : FROM nginx:1.13-alpine
 ---> ebe2c7c61055
Step 2/4 : COPY nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> dab59347f417
Step 3/4 : EXPOSE 80
 ---> Using cache
 ---> f1342efb96c1
Step 4/4 : CMD ["nginx", "-g", "daemon off;"]
 ---> Using cache
 ---> f25d27750d09

Successfully built f25d27750d09
Successfully tagged app_nginx:latest
Creating backend2 ... done
Creating backend1 ... done
Creating app_nginx_1 ... done
```

### raw results from curl ###

```bash

➜  testgolang curl localhost          
Hi there, I'm served from 502a588a923a!
X-Forwarded-For: 172.18.0.1
➜  testgolang curl localhost
Hi there, I'm served from 42cfa9aa8d48!
X-Forwarded-For: 172.18.0.1
➜  testgolang curl localhost
Hi there, I'm served from 502a588a923a!
X-Forwarded-For: 172.18.0.1
➜  testgolang curl localhost
Hi there, I'm served from 42cfa9aa8d48!
X-Forwarded-For: 172.18.0.1
```