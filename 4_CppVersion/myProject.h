// myProject.h -- structure templates and function prototypes
// structure templates
#ifndef MY_PROJECT_H
#define MY_PROJECT_H

// CUDA 错误检测函数
#define CHECK(call)
{
    const cudaError_t error = call;
    if (error != cudaSuccess)
    {
        printf("Error: %s:%d, ", __FILE__, __LINE__);
        printf("code:%d, reason: %s\n", error, cudaGetErrorString(error));
        exit(1);
    }
}

#define imin(a, b) (a<b?a:b)

// 函数原型
void initial_data(float *ip, int size);
__gloabl__ void sum_arrays_on_gpu(float *dev_a, float *dev_b, float *dev_c);

#endif // MY_PROJECT_H