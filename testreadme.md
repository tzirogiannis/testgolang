# Technical Challenge #

This practical technical challenge will access a candidates ability to deploy and test a basic go app

### What is the goal of the test? ###

* Create a automation framework to automatically deploy a test infrastructure that has the below code into 2 or more servers or containers and a load balancer to forward requests to the app port in a round robin fashion.
* Create a publicly available git repository with instructions on how to test the above. 

### The application ###

* GoLang app:
```
package main
import (
        "fmt"
        "net/http"
        "os"
)
func handler(w http.ResponseWriter, r *http.Request) {
        h, _ := os.Hostname()
        fmt.Fprintf(w, "Hi there, I'm served from %s!\n", h)
		fmt.Fprintf(w,"X-Forwarded-For: " + r.Header.Get("X-FORWARDED-FOR") + "\n");
}
func main() {
        http.HandleFunc("/", handler)
        http.ListenAndServe(":8484", nil)
}
```

### Achievement Criterias ###

* Anyone should be able to execute the above test by following the instructions on the repository
* No manual intervention should be needed past launching the deployment
* Desireable things to consider: IAC, Docker, CI/CD, AWS, Terraform, TDD etc
