package main

import (
	"os"
	"strings"
)

func main() {
	var name string

	if len(os.Args) > 1 {
		name = strings.TrimSpace(os.Args[1])
	}

	if name == "" {
		name = "stranger"
	}

	println("Hello,", name)
}
