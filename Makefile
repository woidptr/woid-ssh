BUILD_TYPE ?= debug  ## Set the build type (debug or release)

ESC   := $(shell printf '\033')
BOLD  := $(ESC)[1m
RED   := $(ESC)[31m
CYAN  := $(ESC)[36m
GREEN := $(ESC)[32m
RESET := $(ESC)[0m

CXX = clang++

INCLUDES = -I$(shell brew --prefix)/include

CXXFLAGS = $(INCLUDES)

CLEAN_BUILD_TYPE := $(strip $(BUILD_TYPE))

ifeq ($(CLEAN_BUILD_TYPE),debug)
    BUILD_DIR = build/debug
    CXXFLAGS += -g -O0
else ifeq ($(CLEAN_BUILD_TYPE),release)
    BUILD_DIR = build/release
    CXXFLAGS += -O3 -DNDEBUG
else
    $(error $(BOLD)$(RED)Fatal Error:$(RESET) Invalid BUILD_TYPE '$(CLEAN_BUILD_TYPE)'. Allowed values are $(CYAN)debug$(RESET) or $(CYAN)release$(RESET))
endif

PROJECT_NAME = woid_ssh
SRC_DIR = src

TARGET = $(BUILD_DIR)/$(PROJECT_NAME)

LDFLAGS = -L$(shell brew --prefix)/lib
LDLIBS = -lssh

SRCS = $(shell find $(SRC_DIR) -name '*.cpp')
OBJS = $(SRCS:%.cpp=$(BUILD_DIR)/%.o)

.PHONY: all help build clean

help:  ## Show this help message
	@echo "$(BOLD)Usage:$(RESET) make $(CYAN)[target]$(RESET) $(GREEN)[variable=value]$(RESET)"
	@echo ""
	@echo "$(BOLD)Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk -v c="$(CYAN)" -v r="$(RESET)" 'BEGIN {FS = ":.*?## "}; {printf "  %s%-20s%s %s\n", c, $$1, r, $$2}'
	@echo ""
	@echo "$(BOLD)Variables:$(RESET)"
	@grep -E '^[a-zA-Z_-]+ \??=.*?## .*$$' $(MAKEFILE_LIST) | sort | awk -v c="$(GREEN)" -v r="$(RESET)" -F " ## " '{split($$1, a, " "); printf "  %s%-20s%s %s\n", c, a[1], r, $$2}'
	@echo ""

build: $(TARGET)  ## Compile the project

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:  ## Remove the build directory and compiled files
	rm -rf $(BUILD_DIR)
