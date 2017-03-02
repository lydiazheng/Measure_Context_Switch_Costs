#define _GNU_SOURCE

#include <stdio.h>
#include <stdint.h>
#include <pthread.h>
#include <time.h>
#include <stdlib.h>
#define MAXSize 100

//global variables
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond1 = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond2 = PTHREAD_COND_INITIALIZER;
int num = 0;//a shared integer
unsigned long long result[100]; //the array for each time

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
    unsigned long long i; // the count of the loop
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

    printf("Based on 100 times of the measurement,\n");
    printf("The average time of a process switching measured: %llu\n",sum/100);//output
	return 0;
}

void *thread1(){
    struct timespec start;//imespec struct argument specfied in <time.h>
    struct timespec stop;//imespec struct argument specfied in <time.h>
    unsigned long long i; // the count of the loop

    for(i = 0; i < MAXSize; i++){
        pthread_mutex_lock(&mutex); //lock mutex
        //printf("1\n");
        if(num == 0){
            //printf("count1  %d\n", count1);
            //printf("a\n");
            pthread_cond_wait(&cond1, &mutex);
            clock_gettime(CLOCK_THREAD_CPUTIME_ID, &stop);
            result[i] = timespecDiff(&stop, &start);// get the difference between start and stop
            num = 1;
        }
        num = 0;
        clock_gettime(CLOCK_THREAD_CPUTIME_ID, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
        // wake up thread2
        pthread_cond_signal(&cond2);
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

void *thread2(){
    struct timespec start;//imespec struct argument specfied in <time.h>
    struct timespec stop;//imespec struct argument specfied in <time.h>
    unsigned long long i; // the count of the loop

    for(i = 0; i < MAXSize; i++){
        pthread_mutex_lock(&mutex); //lock mutex
        //printf("2\n");
        if(num == 1){
            //printf("count2   %d\n", count2);
            //printf("b\n");
            pthread_cond_wait(&cond2, &mutex);
            clock_gettime(CLOCK_THREAD_CPUTIME_ID, &stop);
            result[i] = timespecDiff(&stop, &start);// get the difference between start and stop
            num = 0;
        }
        num = 1;
        clock_gettime(CLOCK_THREAD_CPUTIME_ID, &start);//retrieve the time of the specified clock CLOCK_THREAD_CPUTIME_ID
        //wake up thread1
        pthread_cond_signal(&cond1);
        pthread_mutex_unlock(&mutex);
    }
    
    return NULL;
}