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
PLATFORM_TARGETS=$(foreach p,$(PLATFORMS),$(addprefix build/$(p)/,$(TARGETS)))
DIST_TARGETS=$(addsuffix .tar.gz,$(addprefix dist/,$(PLATFORMS)))


all: build

dist: $(DIST_TARGETS)

build: hello addOne

hello: build/$(OS)-$(ARCH)/hello
	cp $< $@

build/linux-amd64/hello: $(HELLO_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

build/darwin-amd64/hello: $(HELLO_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=darwin $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

build/linux-arm7/hello: $(HELLO_SOURCES) $(SOURCES)
	env GOARM=7 GOARCH=arm GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/hello

addOne: build/$(OS)-$(ARCH)/addOne
	cp $< $@

build/linux-amd64/addOne: $(ADDONE_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

build/darwin-amd64/addOne: $(ADDONE_SOURCES) $(SOURCES)
	env GOARCH=amd64 GOOS=darwin $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

build/linux-arm7/addOne: $(ADDONE_SOURCES) $(SOURCES)
	env GOARM=7 GOARCH=arm GOOS=linux $(GOBUILD) $(FLAGS) $(LDFLAGS) -o $@ ./cmd/addOne

dist/linux-amd64.tar.gz: $(addprefix build/linux-amd64/,$(TARGETS))
	mkdir -p dist
	tar -czf $@ -C build/linux-amd64 .

dist/darwin-amd64.tar.gz: $(addprefix build/darwin-amd64/,$(TARGETS))
	mkdir -p dist
	tar -czf $@ -C build/darwin-amd64 .

dist/linux-arm7.tar.gz: $(addprefix build/linux-arm7/,$(TARGETS))
	mkdir -p dist
	tar -czf $@ -C build/linux-arm7 .

clean:
	rm -rf $(PLATFORM_TARGETS)
	rm -rf dist

.PHONY: all dist build clean
