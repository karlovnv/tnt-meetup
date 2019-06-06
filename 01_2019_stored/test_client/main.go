package main

import (
	"github.com/tarantool/go-tarantool"
	"log"
)

func main() {
	opts := tarantool.Opts{
		User: "guest",
	}

	conn, err := tarantool.Connect("localhost:3301", opts)
	if err != nil {
		panic(err)
	}

	res, err := conn.Call17("api.create_or_update", []interface{}{
		10,
		"Ivan",
		30,
	})
	if err != nil {
		panic(err)
	}

	log.Printf("%v", res)
}
