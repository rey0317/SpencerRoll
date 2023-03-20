package main

import(
    "log"
	
    "eventurad/router"
    "eventurad/views"
)

func main() {
    views.New()
    go func() { log.Fatal(router.Redirect().ListenAndServe()) }()
    log.Fatal(router.New().ListenAndServe())
}