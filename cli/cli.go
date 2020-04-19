package cli

import (
	"os"
	"strings"
)

// GetArg returns the first comman-line argument
func GetArg() (string, bool) {
	var s string

	if len(os.Args) > 1 {
		s = os.Args[1]
	}

	s = strings.TrimSpace(s)

	return s, s != ""
}
