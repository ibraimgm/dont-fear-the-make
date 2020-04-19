package main

import (
	"github.com/ibraimgm/dont-fear-the-make/cli"
)

func main() {
	name, ok := cli.GetArg()
	if !ok {
		name = "stranger"
	}

	println("Hello,", name)
}
