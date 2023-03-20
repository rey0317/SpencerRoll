package views

import (
    "context"
    // "encoding/json"
    "log"
    "net/http"

    "github.com/savsgio/atreugo/v11"
    "github.com/jackc/pgx/v4/pgxpool"
)

type User struct {
    Address string    `json:"address"`
    BoothId   int    `json:"boothid"`
}

type Booth struct {
    Name  string    `json:"name"`
    Secret   string    `json:"secret"`
	EventId int		`json:eventid`
	BoothId int		`json:boothid`
}

var emptyJSON = struct {
    Empty *string `json:"-"`
}{}

func LogHTTP(sc int, c *atreugo.RequestCtx) {
    log.Println("[ATR] |", sc, `|`, c.RemoteAddr().String(), `|`, string(c.Method()), string(c.RequestURI()))
}

var ctx = context.Background()
var eventuraDB *pgxpool.Pool

func New() {
    var err error
    const (
        psqlUser   = "a"
        psqlPasswd = "aa"
        psqlDB     = "eventura"
    )

    eventuraDB, err = pgxpool.Connect(ctx, "host=localhost user="+psqlUser+" password="+psqlPasswd+" dbname="+psqlDB)
    if err != nil {
        panic(err)
    }
}

func GetBooth(c *atreugo.RequestCtx) error {
    var boothArr [][]any
    var booth Booth

    rows, err := eventuraDB.Query(ctx, `SELECT * FROM booth`)
    if err != nil {
        panic(err)
    }
    defer rows.Close()

    for rows.Next() {
        rows.Scan(&booth.name, &booth.secret, &booth.active, &booth.eventid, &booth.boothid, &booth.geodata)
        boothArr = append(boothArr, []any{booth.Secret, booth.BoothId, booth.Name})
    }

    LogHTTP(http.StatusOK, c)
    return c.JSONResponse(map[string][][]any{"booths": boothArr}, http.StatusOK)
}

// func PostUser(c *atreugo.RequestCtx) error {
//     var user User

//     if err := json.Unmarshal(c.Request.Body(), &booth); err != nil {
//         LogHTTP(http.StatusUnprocessableEntity, c)
//         return c.JSONResponse([]byte(err.Error()), http.StatusUnprocessableEntity)
//     }

//     _, err := eventuraDB.Exec(ctx, `INSERT INTO users (address, booths) VALUES ($1, $2)`, booth.Address, booth.BoothId)
//     if err != nil {
//         LogHTTP(http.StatusInternalServerError, c)
//         return c.JSONResponse([]byte(err.Error()), http.StatusInternalServerError)
//     }

//     LogHTTP(http.StatusOK, c)
//     return c.JSONResponse(emptyJSON, http.StatusOK)
// }