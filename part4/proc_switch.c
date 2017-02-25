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
	char byte = 'z';// a single byte message
	pid_t pid;

	for(i = 0; i < MAXSize; i++){
		int fdP[2];// pipe parent uses to contact child
		int fdC[2];// pipe child uses to contact child

		pipe(fdP);// parent to child
		pipe(fdC);//child to parent
		if((pid = fork()) < 0){
			printf("***ERROR: pipe creat failed!\n");
			exit(1);
		}

		if(pid < 0){
			printf("***ERROR: forking child process failed.\n");
			exit(1);
		}
		if(pid == 0){//child process
			close(fdC[1]);//the child closes the output side of its pipe
			close(fdP[0]);//the child closes the parents input side
			read(fdC[0], &byte, sizeof(byte));//read the process
			write(fdP[1], &byte, sizeof(byte));
			exit(1);
		}
		else{ //parent process
			close(fdP[1]);//the parent closes the output side of its pipe
			close(fdC[0]);//the parent closes the child input side
			clock_gettime(CLOCK_MONOTONIC, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
			write(fdC[1], &byte, sizeof(byte));//the parent process write only
			wait(NULL);

			close(fdP[1]);//the parent closes the output side of its pipe
			close(fdC[0]);//the parent closes the child input side
			read(fdC[0], &byte, sizeof(byte));//read the pipe after child process stop
			clock_gettime(CLOCK_MONOTONIC, &stop);//get the stop time of CLOCK_MONOTONIC
		}
		result = timespecDiff(&stop, &start);// get the difference between start and stop
		printf("result   %llu\n", result);
		sum += result;
	}
	printf("Based on 100 times of the measurement,\n");
	printf("The average time of a process switching measured: %llu\n",sum/100);//output
	return 0;
	
}
