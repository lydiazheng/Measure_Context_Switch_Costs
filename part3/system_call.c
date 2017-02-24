#include <stdio.h>
#include <stdint.h>
#include <time.h>


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
	unsigned long long sum = 0;
	unsigned long long i; // the count of the loop

	for(i = 0; i < 100; i++){
		clock_gettime(CLOCK_THREAD_CPUTIME_ID, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
		getpid();
		clock_gettime(CLOCK_THREAD_CPUTIME_ID, &stop);//get the stop time of CLOCK_THREAD_CPUTIME_ID
		
		result = timespecDiff(&stop,&start);// get the difference between start and stop
		sum += result;
		printf("result     %llu\n", result);
	}
	printf("Based on 1000 times of the measurement,\n");
	printf("The average time of a bare function call measured: %llu\n",sum/100);//output
}
