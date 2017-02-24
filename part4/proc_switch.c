#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#define MAXSize 100

unsigned long long timespecDiff(struct timespec *timeA_p, struct timespec *timeB_p)// timeA_p is the start time, timeB_p is the stop time
{
  return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
           ((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec); //get the difference between the start time and the sto time
           														//change second to nanosecond, 1 second = 1*10^9 nanoseconds
}

int main(){
	struct timespec start;//imespec struct argument specfied in <time.h>
	struct timespec stop;//imespec struct argument specfied in <time.h>
	unsigned long long result; //64 bit integer
	unsigned long long sum = 0;// the sum of each time measurement
	unsigned long long i; // the count of the loop
	char byte = 'a';// a single byte message
	pid_t pid;

	for(i = 0; i < MAXSize; i++){
		int fd[2];// connect all processes

		if(pipe(fd) < 0){
			printf("***ERROR: pipe creat failed!\n");
			exit(1);
		}

		pid = fork();
		if(pid < 0){
			printf("***ERROR: forking child process failed.\n");
			exit(1);
		}
		if(pid == 0){//child process
			close(fd[1]);//close the child process from parent write
			read(fd, &byte, sizeof(byte));//read the process
			exit(1);
		}
		else{ //parent process
			close(fd[0]);//close parent process from child read
			clock_gettime(CLOCK_MONOTONIC, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
			write(fd, &byte, sizeof(byte));//the parent process write only
			wait(NULL);
			clock_gettime(CLOCK_MONOTONIC, &stop);//get the stop time of CLOCK_MONOTONIC
			close(fd[1]);
		}
		result = timespecDiff(&stop, &start);// get the difference between start and stop
		printf("result   %llu\n", result);
		sum += result;
	}
	printf("Based on 1000 times of the measurement,\n");
	printf("The average time of a process switching measured: %llu\n",sum/100);//output

	
}