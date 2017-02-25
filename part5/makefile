thr_switch: thr_switch.o
	gcc -o thr_switch thr_switch.o

thr_switch.o: thr_switch.s 
	gcc -c thr_switch.s

thr_switch.s: thr_switch.c 
	gcc -S thr_switch.c

clean:
	rm -f thr_switch *.o thr_switch.s