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

.PHONY: all

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@
