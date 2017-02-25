#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cachesim.h"

counter_t accesses = 0, hits = 0, misses = 0, writebacks = 0;
typedef struct {
    int valid;
    int dirty;
    int tag;
    int LRUTime;
} block;

typedef struct {
    block* lineBlock;
} line;

line* myCache;
int blockSize;
int cacheSize;
int numWays;
int globalTime;
//Assuming that the parameters are in byts
void cachesim_init(int blocksize, int cachesize, int ways) {
    //Determines the number of lines 
    int numLines = cachesize/(blocksize * ways);
    int i;
    //Initalizes all global variables 
    globalTime = 0;
    blockSize = blocksize;
    cacheSize = cachesize;
    numWays = ways;
    //Allocates space for cache 
    //For loops to inialize every block in the cache 
    myCache = (line*)malloc(numLines*sizeof(line));
    for (i = 0; i < numLines; i++) {
        myCache[i].lineBlock = (block*) malloc(ways*sizeof(block));
        int j;
        for (j = 0; j < ways; j++) {
            myCache[i].lineBlock[j].valid = 0;
            myCache[i].lineBlock[j].dirty = 0;
            myCache[i].lineBlock[j].tag = 0;
            myCache[i].lineBlock[j].LRUTime = 0;
        }

    }
}
//function created to compute log2 of input number 
int calcPower(int num) {
    //while loop divides number by 2 until the num is equal to 1
    int power = 0; 
    while (num != 1) {
        num /= 2; 
        power++; 
    }
    return power; 
}
void cachesim_access(addr_t physical_addr, int write) {
    accesses++; //increment accesses everytime function is called 
    //calculate the number of bits for the block
    int numBits = calcPower(blockSize); 
    //calculate the number of bits for the index 
    int numIndexBits = calcPower(cacheSize/(blockSize*numWays)); 
    //determine the tag value --> represented by the non-block and non-index bits 
    int tagValue = physical_addr >> (numBits + numIndexBits);
    //determine the index 
    int index = physical_addr >> numBits;
    int notTag = (tagValue) << numIndexBits;
    notTag = ~notTag; 
    index = index & notTag;
    //First for loop iterates through the cache to see if the addresss is already in the cache
    int i;
    for (i = 0; i < numWays; i++) {
        //if statement checks if the block is valid and if the tag value match 
        if (myCache[index].lineBlock[i].valid == 1 && myCache[index].lineBlock[i].tag == tagValue) {
            hits++; //if so, then there is a hit 
            //if statement checks if this address is being written to 
            if (write == 1) {
                //if so, then make the dirty bit 1 
                myCache[index].lineBlock[i].dirty = 1;
            }
            //set the LRUTime of cache to the global time 
            myCache[index].lineBlock[i].LRUTime = globalTime;
            globalTime++; //increment the global time 
            return;
        }
    }
    misses++; //if the address is not in the cache then it is miss 
    //if the address is a miss, then it has to be added to the cache 
    for (i = 0; i < numWays; i++) {
        //find an empty block in the cache by checking if it's valid bit is 0
        if (myCache[index].lineBlock[i].valid == 0) {
            //once an empty block is found, add the address to the cache
            myCache[index].lineBlock[i].valid = 1; //makes the block valid (for valid address)
            //if there is a write operation, then makes the dirty bit 1
            if (write == 1) { 
                myCache[index].lineBlock[i].dirty = 1; 
            } else {
                myCache[index].lineBlock[i].dirty = 0;
            }
            //sets the tag and LRUTime of the block
            myCache[index].lineBlock[i].tag = tagValue;
            myCache[index].lineBlock[i].LRUTime = globalTime;
            globalTime++; //increments the LRUTime 
            return;
        }
    }
    //If there is not an empty block found in the cache, then the oldest address has to be evicted 
    //The oldest block in the cache is the address with the minimum LRUTime 
    //Set the minimum LRUTime and index to be the first block in the cache 
    int minTime = myCache[index].lineBlock[0].LRUTime; 
    int minIndex = 0;
    //Iterate through the cache and update the minTime and minIndex whenever a block is found to have a
    //LRUTime lower than the current minTime and minIndex 
    for (i = 1; i < numWays; i++) {
        if (myCache[index].lineBlock[i].LRUTime < minTime) {
            minTime = myCache[index].lineBlock[i].LRUTime;
            minIndex = i;
        }
    }
    //If the evicted block is dirty, then increment the number of writebacks 
    if (myCache[index].lineBlock[minIndex].dirty == 1) {
        writebacks++; 
    }
    //Set the dirty bit appropriately based on whether the write operation is 1 
    myCache[index].lineBlock[minIndex].valid = 1;
    if (write == 1) {
        myCache[index].lineBlock[minIndex].dirty = 1;
    } else {
        myCache[index].lineBlock[minIndex].dirty = 0;
    }
    //Set the tag and LRUTime and increment the globalTime counter 
    myCache[index].lineBlock[minIndex].tag = tagValue;
    myCache[index].lineBlock[minIndex].LRUTime = globalTime;
    globalTime++;
    return;
}

void cachesim_print_stats() {
  printf("%llu, %llu, %llu, %llu\n", accesses, hits, misses, writebacks);
}
