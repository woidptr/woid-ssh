CXX = clang++

INCLUDES = -I$(shell brew --prefix)/include

CXXFLAGS = -O0 $(INCLUDES)

PROJECT_NAME = woid_ssh
BUILD_DIR = build
SRC_DIR = src

TARGET = $(BUILD_DIR)/$(PROJECT_NAME)

LDFLAGS = -L$(shell brew --prefix)/lib
LDLIBS = -lssh

SRCS = $(shell find $(SRC_DIR) -name '*.cpp')
OBJS = $(SRCS:%.cpp=$(BUILD_DIR)/%.o)

.PHONY: all help build clean

help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: $(TARGET)  ## Compile the project

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:  ## Remove the build directory and compiled files
	rm -rf $(BUILD_DIR)
