bare_fnc: bare_fnc.o
	gcc -o bare_fnc bare_fnc.o

bare_fnc.o: bare_fnc.s 
	gcc -c bare_fnc.s

bare_fnc.s: bare_fnc.c 
	gcc -S bare_fnc.c

clean:
	rm -f bare_fnc *.o bare_fnc.s
