GO=go
GOBUILD=$(GO) build
GOENV=$(GO) env
FLAGS=-trimpath
LDFLAGS=-ldflags "-w -s"

# os/env information
ARCH=$(shell $(GOENV) | grep GOARCH | sed -E 's/GOARCH="(.*)"/\1/')
OS=$(shell $(GOENV) | grep GOOS | sed -E 's/GOOS="(.*)"/\1/')

# source files
SOURCES=go.mod $(shell find . -path ./cmd -prune -o -name "*.go" -print)
HELLO_SOURCES=$(shell find ./cmd/hello -name "*.go")
ADDONE_SOURCES=$(shell find ./cmd/addOne -name "*.go")

# platforms and targets
TARGETS=hello addOne
PLATFORMS=linux-amd64 darwin-amd64 linux-arm7
PLATFORM_TARGETS=$(foreach p,$(PLATFORMS),$(addsuffix .$(p),$(TARGETS)))


all: build

build: hello addOne

hello: hello.$(OS)-$(ARCH)
	cp $< $@

hello.linux-amd64: $(HELLO_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

hello.darwin-amd64: $(HELLO_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=darwin $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

hello.linux-arm7: $(HELLO_SOURCES) $(SOURCES)
	env GOARM=7 GOARCH=arm GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

addOne: addOne.$(OS)-$(ARCH)
	cp $< $@

addOne.linux-amd64: $(ADDONE_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

addOne.darwin-amd64: $(ADDONE_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=darwin $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

addOne.linux-arm7: $(ADDONE_SOURCES) $(SOURCES)
	env GOARM=7 GOARCH=arm GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

clean:
	rm -rf $(PLATFORM_TARGETS)

.PHONY: all build clean
