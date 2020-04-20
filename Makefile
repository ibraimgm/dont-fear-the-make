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

# platforms and targets
TARGETS=hello addOne
PLATFORMS=linux-amd64 darwin-amd64 linux-arm7
PLATFORM_TARGETS=$(foreach p,$(PLATFORMS),$(addprefix build/$(p)/,$(TARGETS)))
DIST_TARGETS=$(addsuffix .tar.gz,$(addprefix dist/,$(PLATFORMS)))


all: build

dist: $(DIST_TARGETS)

build: $(TARGETS)

# general build rule
define BUILD_RULE
$(TARGET)_SOURCES=$$(shell find ./cmd/$(TARGET) -name "*.go")

$(TARGET): build/$$(OS)-$$(ARCH)/$(TARGET)
	cp $$< $$@

build/linux-amd64/$(TARGET): $$($(TARGET)_SOURCES) $$(SOURCES)
	env GOARCH=amd64 GOOS=linux $$(GOBUILD) $$(FLAGS) $$(LDFLAGS) -o $$@ ./cmd/$(TARGET)

build/darwin-amd64/$(TARGET): $$($(TARGET)_SOURCES) $$(SOURCES)
	env GOARCH=amd64 GOOS=darwin $$(GOBUILD) $$(FLAGS) $$(LDFLAGS) -o $$@ ./cmd/$(TARGET)

build/linux-arm7/$(TARGET): $$($(TARGET)_SOURCES) $$(SOURCES)
	env GOARM=7 GOARCH=arm GOOS=linux $$(GOBUILD) $$(FLAGS) $$(LDFLAGS) -o $$@ ./cmd/$(TARGET)

endef

# rule for dist targets
define DIST_RULE
dist/$(PLATFORM).tar.gz: $$(addprefix build/$(PLATFORM)/,$$(TARGETS))
	mkdir -p dist
	tar -czf $$@ -C build/$(PLATFORM) .

endef

rules.mk: Makefile
	$(file > $@,)
	$(foreach TARGET,$(TARGETS),$(file >> $@,$(BUILD_RULE)))
	$(foreach PLATFORM,$(PLATFORMS),$(file >> $@,$(DIST_RULE)))

include rules.mk

clean:
	rm -rf $(TARGETS) $(PLATFORM_TARGETS)
	rm -rf dist build

.PHONY: all dist build clean
