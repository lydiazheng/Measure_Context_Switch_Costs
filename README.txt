Weiling Zheng
301294091  weilingz@sfu.ca

How to run the function:
I separate the whole project into 5 parts

--Part1: 1. the comment is in the source code

--Part2: 1. type 'make'
		 2. type './bare_fnc'
		 The output is: 
		 Based on 1000 times of the measurement,
		 The average time of a bare function call measured: 42

--Part3: 1. type 'make'
		 2. type './system_call'
		 The output is:
		 Based on 1000 times of the measurement,
		 The average time of a getpid() system call measured: 93

--Part4: 1. type 'make'
		 2. type './proc_switch'
		 The output is:
		 Based on 1000 times of the measurement,
		 The average time of a process switching measured: 6838

--Part5: 1. type 'make'
		 2. type './thr_switch'
		 The output is:
		 Based on 1000 times of the measurement,
		 The average time of a thread switching measured: 1068


