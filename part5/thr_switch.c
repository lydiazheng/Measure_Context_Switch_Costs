#define _GNU_SOURCE

#include <stdio.h>
#include <stdint.h>
#include <pthread.h>
#include <time.h>
#include <stdlib.h>
#define MAXSize 1000

//global variables
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond1 = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond2 = PTHREAD_COND_INITIALIZER;
int num = 0;//a shared integer
unsigned long long result[1000]; //the array for each time
unsigned long long i; // the count of the loop
int count;//count for the result array

void *thread1();
void *thread2();

unsigned long long timespecDiff(struct timespec *timeA_p, struct timespec *timeB_p)// timeA_p is the start time, timeB_p is the stop time
{
  return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
           ((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec); //get the difference between the start time and the sto time
           														//change second to nanosecond, 1 second = 1*10^9 nanoseconds
}

int main(){
    pthread_t t1, t2;

	//unsigned long long result; //64 bit integer
    //unsigned long long sum = 0;// the sum of each time measurement
    unsigned long long sum = 0;// the sum of each time measurement

    cpu_set_t set;
    CPU_ZERO(&set);        // clear cpu mask
    CPU_SET(2, &set);      // set cpu 2
    sched_setaffinity(0, sizeof(cpu_set_t), &set);  // 0 is the calling process

    //create 2 threads
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    //wait 2 threads to finish
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    for(i = 0; i < MAXSize; i++){
        sum += result[i];
        printf("result   %llu\n", result[i]);
    }

    struct timespec time_start;
    struct timespec time_stop;
    unsigned long long time_fnc; //time for the for time
    //delete the clock_gettime() time
    clock_gettime(CLOCK_MONOTONIC, &time_start);
    clock_gettime(CLOCK_MONOTONIC, &time_stop);
    time_fnc = timespecDiff(&time_stop, &time_start);
    printf("sum  %llu\n", sum);

    struct timespec if_start;
    struct timespec if_stop;
    unsigned long long if_fnc; //time for the for time
    //delete the if loop time
    clock_gettime(CLOCK_MONOTONIC, &if_start);
    clock_gettime(CLOCK_MONOTONIC, &if_stop);
    if_fnc = timespecDiff(&if_stop, &if_start);

    sum -= time_fnc*MAXSize;
    sum -= if_fnc*MAXSize;
    printf("sum 2 %llu\n", sum);
    printf("if_fnc  %llu\n", if_fnc);
    printf("time_fnc  %llu\n", time_fnc);
    printf("Based on 1000 times of the measurement,\n");
    printf("The average time of a thread switching measured: %llu\n",sum/MAXSize);//output
	return 0;
}

void *thread1(){
    struct timespec start;//imespec struct argument specfied in <time.h>
    struct timespec stop;//imespec struct argument specfied in <time.h>

    for(i = 0; i < MAXSize; i++){
        pthread_mutex_lock(&mutex); //lock mutex
        if(num == 0){
            pthread_cond_wait(&cond1, &mutex);
            clock_gettime(CLOCK_MONOTONIC, &stop);
            result[count] = timespecDiff(&stop, &start);// get the difference between start and stop
            count++;
            //pthread_cond_wait(&cond1, &mutex);
        }
        num = 0;
        clock_gettime(CLOCK_MONOTONIC, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
        
        // wake up thread2
        pthread_cond_signal(&cond2);
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

void *thread2(){
    struct timespec start;//imespec struct argument specfied in <time.h>
    struct timespec stop;//imespec struct argument specfied in <time.h>

    for(i = 0; i < MAXSize; i++){
        pthread_mutex_lock(&mutex); //lock mutex
        if(num == 1){
            pthread_cond_wait(&cond2, &mutex);
            clock_gettime(CLOCK_MONOTONIC, &stop);
            result[count] = timespecDiff(&stop, &start);// get the difference between start and stop
            count++;
            //pthread_cond_wait(&cond2, &mutex);
        }
        num = 1;
        clock_gettime(CLOCK_MONOTONIC, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID

        //wake up thread1
        pthread_cond_signal(&cond1);
        pthread_mutex_unlock(&mutex);
    }
    
    return NULL;
}