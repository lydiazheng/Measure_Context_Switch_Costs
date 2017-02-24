proc_switch: proc_switch.o
	gcc -o proc_switch proc_switch.o

proc_switch.o: proc_switch.s 
	gcc -c proc_switch.s

proc_switch.s: proc_switch.c 
	gcc -S proc_switch.c

clean:
	rm -f proc_switch *.o proc_switch.s