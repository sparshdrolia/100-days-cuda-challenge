#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(const int *a, const int *b, int *c, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < n){
         c[idx] = a[idx] + b[idx];
    }
       
}

int main(){
    int n = 10;
    size_t size = n * sizeof(int);

    // Allocate host (CPU) arrays
    int h_a[10], h_b[10], h_c[10];

    // Initialize the input arrays
    for (int i = 0; i < n; i++) {
        h_a[i] = i;
        h_b[i] = i * 2;
    }

    

    int *d_a, *d_b, *d_c;

    // Allocate device memory
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);


    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;

    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, n);

    cudaDeviceSynchronize();

    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

    for (int i = 0; i < n; i++) {
        printf("%d + %d = %d\n", h_a[i], h_b[i], h_c[i]);
    }

    return 0;
}