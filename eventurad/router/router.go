package router

import (
    "eventurad/views"
    "net/http"

    "github.com/savsgio/atreugo/v11"
)

type Route struct {
    HTTPMethod string
    URLPath    string
    URLHandler atreugo.View
}

var routes = []Route {
    {"GET", "/getbooth/", views.GetBooth},
    {"POST", "/postuser/", views.PostChatt},
}

func New() *atreugo.Atreugo {
    router := atreugo.New(atreugo.Config{
        Addr:               ":443",
        TLSEnable:          true,
        CertKey:            "/etc/ssl/private/selfsigned.key",
        CertFile:           "/etc/ssl/certs/selfsigned.cert",
        //Prefork:            true,
        Reuseport:          true,
    })
    router.RedirectTrailingSlash(true)

    for _, route := range routes {
        router.Path(route.HTTPMethod, route.URLPath, route.URLHandler)
    }

    return router
}

func Redirect() *atreugo.Atreugo {
    return atreugo.New(atreugo.Config{
        Addr:      ":80",
        Reuseport: true,
        NotFoundView: func(c *atreugo.RequestCtx) error {
            views.LogHTTP(http.StatusPermanentRedirect, c)
            return c.RedirectResponse("https://"+string(c.Host())+string(c.RequestURI()), http.StatusPermanentRedirect)
        },
    })
}