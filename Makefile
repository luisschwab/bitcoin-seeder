UNAME_S := $(shell uname -s)

CXXFLAGS = -O3 -g0 -march=native
LDFLAGS = $(CXXFLAGS)

# macOS only: add Homebrew paths for local development
ifeq ($(UNAME_S), Darwin)
    CXXFLAGS += -I/opt/homebrew/opt/boost/include -I/opt/homebrew/opt/openssl@3/include
    LDFLAGS  += -L/opt/homebrew/opt/openssl@3/lib
endif

dnsseed: dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o
	g++ -pthread $(LDFLAGS) -o dnsseed dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o -lcrypto

%.o: %.cpp *.h
	g++ -std=c++11 -pthread $(CXXFLAGS) -Wall -Wno-unused -Wno-sign-compare -Wno-reorder -Wno-comment -c -o $@ $<

clean:
	rm -f *.o dnsseed
