package main

import (
	"fmt"
	"os"
	"strconv"

	"github.com/ibraimgm/dont-fear-the-make/cli"
)

func main() {
	str, ok := cli.GetArg()
	if !ok {
		fmt.Println("You need to specify the integer value to increment")
		os.Exit(1)
	}

	i, err := strconv.ParseInt(str, 10, 64)
	if err != nil {
		fmt.Println("Error parsing argument: ", err)
		os.Exit(1)
	}

	fmt.Println(i + 1)
}
