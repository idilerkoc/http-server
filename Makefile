CXX ?= c++
CXXFLAGS := -std=c++17 -Wall -Wextra -pedantic -Iheaders -MMD -MP
LDFLAGS := -pthread

MODE ?= release

ifeq ($(MODE), release)
    CXXFLAGS += -O2
else ifeq ($(MODE), debug)
    SAN := -fsanitize=address,undefined -fno-omit-frame-pointer
    CXXFLAGS += -g -O1 $(SAN)
    LDFLAGS += $(SAN)
else
    $(error Unknown MODE '$(MODE)'. Use release or debug)
endif

BUILD := build/$(MODE)
SRCS := $(wildcard src/*.cpp)
OBJS := $(SRCS:src/%.cpp=$(BUILD)/%.o)
TARGET := $(BUILD)/server

.PHONY: all debug clean

all: $(TARGET)

debug:
	$(MAKE) MODE=debug

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS) -o $@

$(BUILD)/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf build

-include $(OBJS:.o=.d)
