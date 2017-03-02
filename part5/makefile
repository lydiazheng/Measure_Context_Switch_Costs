CC=gcc
CXX=g++
CCFLAGS= -g -std=c99 -Wall -Werror -lrt -pthread

all: thr_switch

%.o : %.c
	$(CC) -c $(CCFLAGS) $<

thr_switch:  thr_switch.o
	$(CC) -o thr_switch thr_switch.o $(CCFLAGS)

clean:
	rm -f core *.o thr_switch