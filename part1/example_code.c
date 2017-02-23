#include <stdio.h>
#include <stdint.h>
#include <time.h>

unsigned long long timespecDiff(struct timespec *timeA_p, struct timespec *timeB_p)// timeA_p is the start time, timeB_p is the stop time
{
  return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
           ((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec); //get the difference between the start time and the sto time
           														//change second to nanosecond, 1 second = 1*10^9 nanoseconds
}


int main()
{
struct timespec start;//imespec struct argument specfied in <time.h>
struct timespec stop;//imespec struct argument specfied in <time.h>
unsigned long long result; //64 bit integer

clock_gettime(CLOCK_REALTIME, &start);//retrieve the time of the specified clock CLOCK_REALTIME
									  //CLOCK_REALTIME is the system-wide realtime clock	
sleep(1);// pause for 1 second
clock_gettime(CLOCK_REALTIME, &stop);//get the stop time of CLOCK_REALTIME

result=timespecDiff(&stop,&start);// get the difference between start and stop

printf("CLOCK_REALTIME Measured: %llu\n",result);//output

clock_gettime(CLOCK_MONOTONIC, &start);//retrieve the time of the specified clock CLOCK_MONOTONIC
									   //CLOCK_MONOTONIC represents the absolute elapsed wall-clock time 
									   //since some arbirary, fixed point in the past(unspecifies starting point)
sleep(1);// pause for 1 second
clock_gettime(CLOCK_MONOTONIC, &stop);//get the stop time of CLOCK_MONOTONIC

result=timespecDiff(&stop,&start);// get the difference between start and stop

printf("CLOCK_MONOTONIC Measured: %llu\n",result);//output

clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);//retrieve the time of the specified clock CLOCK_PROCESS_CPUTIME_ID
												//CLOCK_PROCESS_CPUTIME_ID is high-resolution per-process timer from the CPU
												//without the queuing delay time
sleep(1);// pause for 1 second
clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &stop);//get the stop time of CLOCK_PROCESS_CPUTIME_ID

result=timespecDiff(&stop,&start);// get the difference between start and stop

printf("CLOCK_PROCESS_CPUTIME_ID Measured: %llu\n",result);//output

clock_gettime(CLOCK_THREAD_CPUTIME_ID, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
                                               //CLOCK_THREAD_CPUTIME_ID is the amount of time consumed by the thread
sleep(1);// pause for 1 second
clock_gettime(CLOCK_THREAD_CPUTIME_ID, &stop);//get the stop time of CLOCK_THREAD_CPUTIME_ID

result=timespecDiff(&stop,&start);// get the difference between start and stop

printf("CLOCK_THREAD_CPUTIME_ID Measured: %llu\n",result);//output


}