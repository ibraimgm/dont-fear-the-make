SOURCES = go.mod $(shell find . -path ./cmd -prune -o -name "*.go" -print)


all: build

build: hello addOne

hello: $(shell find ./cmd/hello -name "*.go") $(SOURCES)
	go build ./cmd/hello

addOne: $(shell find ./cmd/addOne -name "*.go") $(SOURCES)
	go build ./cmd/addOne

clean:
	rm -rf hello addOne

.PHONY: all build clean
