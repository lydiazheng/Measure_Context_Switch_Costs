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
	


}