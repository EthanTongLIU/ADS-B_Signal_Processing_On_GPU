#include <iostream>
#include <cuda_runtime.h>
#include <stdio.h>
#include "myProject.h"

const int N = 33 * 1024;
const int threadsPerBlock = 256;

// dot between 2 vectors
__global__ void dot(float *a, float *b, float *c)
{
    __shared__ float cache[threadsPerBlock]; // 名为 cache 的共享内存缓冲区，用于保存每个线程计算的加和值，数组大小声明为 threadsPerBlock
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int cacheIndex = threadIdx.x;
    float temp = 0;
    while(tid < N)
    {
        temp += a[tid] * b[tid];
        tid += blockDim.x * gridDim.x;
    }

    // 设置 cache 中相应位置上的值
    cache[cacheIndex] = temp;
}