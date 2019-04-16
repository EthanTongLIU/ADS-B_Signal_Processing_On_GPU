#include <iostream>
#include <iomanip>
#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

// 计时器函数
double cpu_seconds()
{
    struct timeval tp;
    gettimeofday(&tp, NULL);
    return ((double)tp.tv_sec + (double)tp.tv_usec*1.e-6);
}

// 打印数组
void display_array(unsigned int *array, unsigned int N)
{
    std::cout << "[ ";
    for (int i = 0; i < N; i++)
    {
        std::cout << array[i] << " ";
    }
    std::cout << "]" << std::endl;
}

// 初始化数据
void initial_data(unsigned int *ip, unsigned int size)
{
    // time_t t;
    // srand((unsigned) time(&t));

    for(int i = 0; i < size; i++)
    {
        ip[i] = (unsigned int)( (rand() & 0xFF) / 30 );
    }
}

// GPU 数组加法
__global__ void sum_arrays_on_gpu(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c)
{
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    dev_c[i] = dev_a[i] + dev_b[i];
}

// GPU 数组乘法
__global__ void multi_arrays_on_gpu(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c)
{
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    dev_c[i] = dev_a[i] * dev_b[i];
}

// 在 CPU 上递归归约
int recursive_reduce(unsigned int *array, unsigned int N)
{
    unsigned int sum = 0;
    for (int i = 0; i < N; i++)
    {
        sum += array[i];
    }
    return sum;
}

// 在 GPU 上进行相邻归约（有线程束分化）
__global__ void reduce_neighbored(unsigned int *global_idata, unsigned int *global_odata, unsigned int N)
{
    // 设置线程
    unsigned int tid = threadIdx.x;
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = global_idata + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // block 内归约
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

// GPU 点积运算（有 wrap 分化的相邻归约）
__global__ void dot_on_gpu_1(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c, unsigned int *global_odata, unsigned int N)
{
    // 线程 id
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // 向量乘法
    dev_c[idx] = dev_a[idx] * dev_b[idx];
    __syncthreads();

    // 每个 block 中的 thread ID
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = dev_c + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // block 内归约
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

// GPU 点积运算（减少 wrap 分化的相邻归约）
__global__ void dot_on_gpu_2(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c, unsigned int *global_odata, unsigned int N)
{
    // 线程 id
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // 向量乘法
    dev_c[idx] = dev_a[idx] * dev_b[idx];
    __syncthreads();

    // 每个 block 中的 thread ID
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = dev_c + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // block 内归约
    for (int stride = 1; stride < blockDim.x; stride *= 2)
    {
        // 将连续的 tid 映射到需要配对的元素上
        unsigned int index = 2 * stride * tid;
        if (index < blockDim.x)
        {
            idata[index] += idata[index + stride];
        }
        __syncthreads();
    }

    // 将每个 block 归约后的数据赋给小全局内存
    if (tid == 0) global_odata[blockIdx.x] = idata[0];
}

// GPU 点积运算（交错配对的归约）
__global__ void dot_on_gpu_3(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c, unsigned int *global_odata, unsigned int N)
{
    // 线程 id
    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // 向量乘法
    dev_c[idx] = dev_a[idx] * dev_b[idx];
    __syncthreads();

    // 每个 block 中的 thread ID
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = dev_c + blockIdx.x * blockDim.x;

    // 边界检查
    if (idx >= N) return;

    // block 内归约
    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1)
    {
        if (tid < stride)
        {
            idata[tid] += idata[tid + stride];
        }
        __syncthreads();
    }

    // 将每个 block 归约后的数据赋给小全局内存
    if (tid == 0) global_odata[blockIdx.x] = idata[0];
}

// GPU 点积运算（展开循环 2 个数据块）
__global__ void dot_on_gpu_4(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c, unsigned int *global_odata, unsigned int N)
{
    // // 数组索引
    // unsigned int idx0 = blockIdx.x * blockDim.x + threadIdx.x;

    // // 向量乘法
    // dev_c[idx0] = dev_a[idx0] * dev_b[idx0];
    // __syncthreads();

    // 重新构建数组索引
    unsigned int idx = blockIdx.x + blockDim.x * 2 + threadIdx.x;

    // 每个 block 中的 thread ID
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = dev_c + blockIdx.x * blockDim.x * 2;

    // 展开 2 个数据块
    if (idx + blockDim.x < N)
    {
        dev_c[idx] += dev_c[idx + blockDim.x];
    }
    __syncthreads();

    // block 内归约
    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1)
    {
        if (tid < stride)
        {
            idata[tid] += idata[tid + stride];
        }
        __syncthreads();
    }

    // 将每个 block 归约后的数据赋给小全局内存
    if (tid == 0) global_odata[blockIdx.x] = idata[0];
}

// GPU 点积运算（展开循环 8 个数据块）
__global__ void dot_on_gpu_5(unsigned int *dev_a, unsigned int *dev_b, unsigned int *dev_c, unsigned int *global_odata, unsigned int N)
{
    // // 数组索引
    // unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // // 向量乘法
    // dev_c[idx] = dev_a[idx] * dev_b[idx];
    // __syncthreads();

    // 重新构建数组索引
    unsigned int idx = blockIdx.x + blockDim.x * 8 + threadIdx.x;

    // 每个 block 中的 thread ID
    unsigned int tid = threadIdx.x;

    // 找到指向每个 block 的指针
    unsigned int *idata = dev_c + blockIdx.x * blockDim.x * 8;

    // 展开 8 个数据块
    if (idx + 7 * blockDim.x < N)
    {
        int a1 = dev_c[idx];
        int a2 = dev_c[idx + blockDim.x];
        int a3 = dev_c[idx + 2 * blockDim.x];
        int a4 = dev_c[idx + 3 * blockDim.x];
        int b1 = dev_c[idx + 4 * blockDim.x];
        int b2 = dev_c[idx + 5 * blockDim.x];
        int b3 = dev_c[idx + 6 * blockDim.x];
        int b4 = dev_c[idx + 7 * blockDim.x];
        dev_c[idx] = a1 + a2 + a3 + a4 + b1 + b2 + b3 + b4;
    }
    __syncthreads();

    // block 内归约
    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1)
    {
        if (tid < stride)
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
    unsigned int N = 1<<24;

    // 指定 GPU 维度
    dim3 block(512, 1);
    dim3 grid((N+block.x-1)/block.x, 1);
    std::cout << "grid " << grid.x << " block " << block.x << std::endl;

    // 分配 host 内存
    size_t data_size = N*sizeof(int);

    unsigned int *host_a, *host_b, *gpu_ref, *h_odata;
    host_a = (unsigned int*)malloc(data_size);
    host_b = (unsigned int*)malloc(data_size);
    gpu_ref = (unsigned int*)malloc(data_size);
    h_odata = (unsigned int *)malloc(grid.x * sizeof(unsigned int));

    // 给 host 内存赋值
    initial_data(host_a, N);
    initial_data(host_b, N);
    memset(gpu_ref, 0, N);
    memset(h_odata, 0, grid.x);

    // 分配 device global 内存
    unsigned int *dev_a, *dev_b, *dev_c, *global_odata;
    cudaMalloc((unsigned int**)&dev_a, data_size);
    cudaMalloc((unsigned int**)&dev_b, data_size);
    cudaMalloc((unsigned int**)&dev_c, data_size);
    cudaMalloc((unsigned int**)&global_odata, grid.x * sizeof(unsigned int));

    // 从 host 向 device 复制数据
    cudaMemcpy(dev_a, host_a, data_size, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, host_b, data_size, cudaMemcpyHostToDevice);

    // 格式化输出性能参数
    std::cout << std::setw(30) << "Type"
        << std::setw(20) << "Result"
        << std::setw(20) << "Time(ms)"
        << std::setw(20) << "1 step acceleration"
        << std::setw(20) << "Total acceleration"
        << std::endl;

    // 在 CPU 上执行全部归约
    cudaDeviceSynchronize();
    double i_start = cpu_seconds();
    unsigned int cpu_result = 0;
    for (int i = 0; i < N; i++)
    {
        cpu_result += ( host_a[i] * host_b[i] );
    }
    double i_elaps = cpu_seconds() - i_start;
    std::cout << std::setw(30) << "CPU reduce recursived"
        << std::setw(20) << cpu_result
        << std::setw(20) << i_elaps * 1000
        << std::endl;

    // // dot 1
    // cudaDeviceSynchronize();
    // i_start = cpu_seconds();
    // dot_on_gpu_1<<<grid, block>>>(dev_a, dev_b, dev_c, global_odata, N);
    // cudaDeviceSynchronize();
    // double i_elaps_1 = cpu_seconds() - i_start;
    // cudaMemcpy(h_odata, global_odata, grid.x * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    // unsigned int gpu_result_1 = recursive_reduce(h_odata, grid.x); // 在 CPU 上进行最后的归约
    // std::cout << std::setw(30) << "GPU reduce neighbored"
    //     << std::setw(20) << gpu_result_1
    //     << std::setw(20) << i_elaps_1 * 1000
    //     << std::setw(20) << i_elaps / i_elaps_1
    //     << std::setw(20) << i_elaps / i_elaps_1
    //     << std::endl;

    // // dot 2
    // cudaDeviceSynchronize();
    // i_start = cpu_seconds();
    // dot_on_gpu_2<<<grid, block>>>(dev_a, dev_b, dev_c, global_odata, N);
    // cudaDeviceSynchronize();
    // double i_elaps_2 = cpu_seconds() - i_start;
    // cudaMemcpy(h_odata, global_odata, grid.x * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    // unsigned int gpu_result_2 = recursive_reduce(h_odata, grid.x); // 在 CPU 上进行最后的归约
    // std::cout << std::setw(30) << "GPU reduce neighbored less"
    //     << std::setw(20) << gpu_result_2
    //     << std::setw(20) << i_elaps_2 * 1000
    //     << std::setw(20) << i_elaps_1 / i_elaps_2
    //     << std::setw(20) << i_elaps / i_elaps_2
    //     << std::endl;

    // dot 3
    // cudaDeviceSynchronize();
    // i_start = cpu_seconds();
    // dot_on_gpu_3<<<grid, block>>>(dev_a, dev_b, dev_c, global_odata, N);
    // cudaDeviceSynchronize();
    // double i_elaps_3 = cpu_seconds() - i_start;
    // cudaMemcpy(h_odata, global_odata, grid.x * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    // unsigned int gpu_result_3 = recursive_reduce(h_odata, grid.x); // 在 CPU 上进行最后的归约
    // std::cout << std::setw(30) << "GPU reduce interleaved"
    //     << std::setw(20) << gpu_result_3
    //     << std::setw(20) << i_elaps_3 * 1000
    //     << std::setw(20) << i_elaps / i_elaps_3
    //     << std::setw(20) << i_elaps / i_elaps_3
    //     << std::endl;

    // dot 4
    multi_arrays_on_gpu<<<grid, block>>>(dev_a, dev_b, dev_c);
    cudaDeviceSynchronize();
    i_start = cpu_seconds();
    dot_on_gpu_4<<<grid.x/2, block>>>(dev_a, dev_b, dev_c, global_odata, N);
    cudaDeviceSynchronize();
    double i_elaps_4 = cpu_seconds() - i_start;
    cudaMemcpy(h_odata, global_odata, grid.x/2 * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    unsigned int gpu_result_4 = recursive_reduce(h_odata, grid.x/2); // 在 CPU 上进行最后的归约
    std::cout << std::setw(30) << "GPU unrolling 2 data blocks"
        << std::setw(20) << gpu_result_4
        << std::setw(20) << i_elaps_4 * 1000
        << std::setw(20) << i_elaps / i_elaps_4
        << std::setw(20) << i_elaps / i_elaps_4
        << std::endl;

    // dot 5
    multi_arrays_on_gpu<<<grid, block>>>(dev_a, dev_b, dev_c);
    cudaDeviceSynchronize();
    i_start = cpu_seconds();
    dot_on_gpu_5<<<grid.x/8, block>>>(dev_a, dev_b, dev_a, global_odata, N);
    cudaDeviceSynchronize();
    double i_elaps_5 = cpu_seconds() - i_start;
    cudaMemcpy(h_odata, global_odata, grid.x/8 * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    unsigned int gpu_result_5 = recursive_reduce(h_odata, grid.x/8); // 在 CPU 上进行最后的归约
    std::cout << std::setw(30) << "GPU unrolling 8 data blocks"
        << std::setw(20) << gpu_result_5
        << std::setw(20) << i_elaps_5 * 1000
        << std::setw(20) << i_elaps / i_elaps_5
        << std::setw(20) << i_elaps / i_elaps_5
        << std::endl;

    // 释放 device 内存
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    cudaFree(global_odata);

    // 释放 host 内存
    free(host_a);
    free(host_b);
    free(gpu_ref);
    free(h_odata);

    std::cout << "End...\n";

    return 0;
}