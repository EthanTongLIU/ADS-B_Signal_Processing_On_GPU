#include <iostream>
#include <cuda_runtime.h>
#include <stdio.h>

// 打印数组
void display_array(float *array, int N)
{
    std::cout << "[ ";
    for (int i = 0; i < N; ++i)
    {
        std::cout << array[i] << " ";
    }
    std::cout << "]" << std::endl;
}

// 初始化数据
void initial_data(float *ip, int size)
{
    time_t t;
    srand((unsigned) time(&t));

    for(int i = 0; i < size; ++i)
    {
        ip[i] = (float)(rand()&0xFF)/10.0f;
    }
}

// GPU 点积运算
__global__ void dot_on_gpu(float *dev_a, float *dev_b, float *dev_c, float *global_odata, unsigned int N)
{
    // 向量加法
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    dev_c[idx] = dev_a[idx] + dev_b[idx];
    __syncthreads();

    // 归约运算
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    float *idata = dev_c + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // 局部归约
    for (int stride = 1; stride < blockDim.x; stride *= 2)
    {
        if ((tid % (2 * stride)) == 0)
        {
            idata[tid] += idata[tid + stride];
        }
        __syncthreads();
    }

    // 将每个 block 归约后的数据赋给小全局内存
    if (tid == 0) global_odata[blockIdx.x] = idata[0];
}

// GPU 数组加法
__global__ void sum_arrays_on_gpu(float *dev_a, float *dev_b, float *dev_c)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    dev_c[i] = dev_a[i] + dev_b[i];
}

// 在 CPU 上递归归约
float recursive_reduce(float *array, int N)
{
    float sum = 0;
    for (int i = 0; i < N; ++i)
    {
        sum += array[i];
    }
    return sum;
}

// 在 GPU 上进行相邻归约（有线程束分化）
__global__ void reduce_neighbored(float *global_idata, float *global_odata, unsigned int N)
{
    // 设置线程
    unsigned int tid = threadIdx.x;
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // 找到指向每个 block 的指针
    float *idata = global_idata + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // 局部归约
    for (int stride = 1; stride < blockDim.x; stride *= 2)
    {
        if ((tid % (2 * stride)) == 0)
        {
            idata[tid] += idata[tid + stride];
        }
        __syncthreads();
    }

    // 将每个 block 归约后的数据赋给小全局内存
    if (tid == 0) global_odata[blockIdx.x] = idata[0];
}

int main()
{
    std::cout << "Strating...\n";

    // 设置设备
    int dev = 0;
    cudaSetDevice(dev);

    // 设置数组大小
    int N = 1<<24;

    // 指定 GPU 维度
    dim3 block(512, 1);
    dim3 grid((N+block.x-1)/block.x, 1);

    // 分配 host 内存
    size_t data_size = N*sizeof(float);

    float *host_a, *host_b, *h_odata;
    host_a = (float*)malloc(data_size);
    host_b = (float*)malloc(data_size);
    h_odata = (float *)malloc(grid.x * sizeof(float));

    // 给 host 内存赋值
    initial_data(host_a, N);
    initial_data(host_b, N);

    memset(h_odata, 0, grid.x);

    // 分配 device global 内存
    float *dev_a, *dev_b, *dev_c, *global_odata;
    cudaMalloc((float**)&dev_a, data_size);
    cudaMalloc((float**)&dev_b, data_size);
    cudaMalloc((float**)&dev_c, data_size);
    cudaMalloc((float**)&global_odata, grid.x * sizeof(float));

    // 从 host 向 device 复制数据
    cudaMemcpy(dev_a, host_a, data_size, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, host_b, data_size, cudaMemcpyHostToDevice);

    // 在 host 端调用核函数
    // sum_arrays_on_gpu<<<grid, block>>>(dev_a, dev_b, dev_c);
    dot_on_gpu<<<grid, block>>>(dev_a, dev_b, dev_c, global_odata, N);

    // 从 device 向 host 复制数据
    // cudaMemcpy(gpu_ref, dev_c, data_size, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_odata, global_odata, grid.x * sizeof(float), cudaMemcpyDeviceToHost);

    // 显示运算结果
    // display_array(gpu_ref, N);

    // 在 CPU 上进行最后的归约
    float gpu_result = recursive_reduce(h_odata, grid.x);
    std::cout << "GPU dot result: " << gpu_result << std::endl;

    // 在 CPU 上执行全部归约
    float cpu_result = 0;
    for (int i = 0; i < N; ++i)
    {
        cpu_result += host_a[i] * host_b[i];
    }
    std::cout << "CPU dot result: " << cpu_result << std::endl;

    // 释放 device 内存
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    cudaFree(global_odata);

    // 释放 host 内存
    free(host_a);
    free(host_b);
    free(h_odata);

    std::cout << "End...\n";

    return 0;
}