_DEPS = bits.h cache.h cpu.h lru.h trace.h
_OBJ = bits.o cache.o cpu.o lru.o
_MOBJ = cache_sim.o
_TOBJ = test.o soln-bits.o

APPBIN = cache_app
TESTBIN = cache_test
INDEXBIN = index

IDIR = include
CC = g++
CXXSTD = -std=c++17
CFLAGS = -I$(IDIR) -Wall -Wextra -g -pthread $(CXXSTD)
ODIR = obj
SDIR = src
LDIR = lib
TDIR = test
LIBS = -lm
XXLIBS = $(LIBS) -lstdc++ -lgtest -lgtest_main -lpthread
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))
MOBJ = $(patsubst %,$(ODIR)/%,$(_MOBJ))
TOBJ = $(patsubst %,$(ODIR)/%,$(_TOBJ))

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	@mkdir -p $(ODIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: $(SDIR)/%.cpp
	@mkdir -p $(ODIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: $(TDIR)/%.cpp $(DEPS)
	@mkdir -p $(ODIR)
	$(CC) -c -o $@ $< $(CFLAGS)

all: $(INDEXBIN)

cache: $(APPBIN) $(TESTBIN) submission

$(INDEXBIN): $(ODIR)/index.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(APPBIN): $(OBJ) $(MOBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(TESTBIN): $(TOBJ) $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(XXLIBS)

submission:
	zip -r submission src lib include



.PHONY: all cache run clean

run: $(INDEXBIN)
	./$(INDEXBIN)

clean:
	find $(ODIR) ! -name 'soln-bits.o' ! -name '.gitkeep' -type f -exec rm -f {} \;
	rm -f  *~ core $(IDIR)/*~
	rm -f $(APPBIN) $(TESTBIN) $(INDEXBIN)
	rm -f $(SDIR)/$(INDEXBIN)
	rm -f submission.zip

