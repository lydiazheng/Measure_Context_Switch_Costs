system_call: system_call.o
	gcc -o system_call system_call.o

system_call.o: system_call.s 
	gcc -c system_call.s

system_call.s: system_call.c 
	gcc -S system_call.c

clean:
	rm -f system_call *.o system_call.s