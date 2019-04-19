#include <iostream>
#include <iomanip>
#include <new>
#include <stdio.h>
#include <cuda_runtime.h>
#include <sys/time.h>
#include <limits.h>

#define imin(a,b) (a<b?a:b)

const int N = 1<<15;
const int threadsPerBlock = 256;
const int blocksPerGrid = imin(32, (N + threadsPerBlock - 1) / threadsPerBlock);

// 计时器函数
double cpuSeconds()
{
    struct timeval tp;
    gettimeofday(&tp, NULL);
    return ((double)tp.tv_sec + (double)tp.tv_usec*1.e-6);
}

// 使用交错配对进行点积运算
__global__ void dotOnGPU1(float *devA, float *devB, float *devC)
{
    __shared__ float cache[threadsPerBlock]; // 保存每个 thread 计算的加和值
    int tid = threadIdx.x + blockIdx.x * blockDim.x; // 数组索引
    int cacheIndex = threadIdx.x; // 每个 block 中的 thread 索引

    float temp = 0;
    while(tid < N) {
        temp += devA[tid] * devB[tid];
        tid += blockDim.x * gridDim.x;
    }

    cache[cacheIndex] = temp;

    __syncthreads();

    int i = blockDim.x / 2;
    while(i != 0)
    {
        if(cacheIndex < i)
        {
            cache[cacheIndex] += cache[cacheIndex + i];
        }
        __syncthreads();
        i /= 2;
    }

    if(cacheIndex == 0)
    {
        devC[blockIdx.x] = cache[0];
    }
}

int main(int argc, char const *argv[])
{
    float *hostA, *hostB, *partialC;
    float hostC;
    float *devA, *devB, *devPartialC;

    hostA = new float[N];
    hostB = new float[N];
    partialC = new float[blocksPerGrid];

    size_t dataSize = N*sizeof(float);

    cudaMalloc((void**)&devA, dataSize);
    cudaMalloc((void**)&devB, dataSize);
    cudaMalloc((void**)&devPartialC, blocksPerGrid*sizeof(float));

    for (int i = 0; i < N; ++i)
    {
        hostA[i] = i;
        hostB[i] = i * 2;
    }

    cudaMemcpy(devA, hostA, dataSize, cudaMemcpyHostToDevice);
    cudaMemcpy(devB, hostB, dataSize, cudaMemcpyHostToDevice);

    cudaDeviceSynchronize();
    double tStart = cpuSeconds();
    dotOnGPU1<<<blocksPerGrid, threadsPerBlock>>>(devA, devB, devPartialC);
    cudaDeviceSynchronize();
    double tElaps = cpuSeconds() - tStart;
    std::cout.precision(20);
    std::cout << "Time: " << std::setw(25) << tElaps*1000.0f << "ms.  ";

    cudaMemcpy(partialC, devPartialC, blocksPerGrid*sizeof(float), cudaMemcpyDeviceToHost);

    hostC = 0;
    for (int i = 0; i < blocksPerGrid; ++i)
    {
        hostC += partialC[i];
    }

    std::cout << "GPU Result: " << std::setw(25) << hostC << std::endl;

    cudaFree(devA);
    cudaFree(devB);
    cudaFree(devPartialC);

    tStart = cpuSeconds();
    float sum = 0;
    for (int i = 0; i < N; ++i)
    {
        sum += hostA[i] * hostB[i];
    }
    tElaps = cpuSeconds() - tStart;
    std::cout << "Time: " << std::setw(25) << tElaps*1000.0f << "ms.  ";
    std::cout << "CPU Result: " << std::setw(25) << sum << std::endl;

    free(hostA);
    free(hostB);
    free(partialC);

    return 0;
}