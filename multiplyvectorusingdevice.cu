#include <stdio.h>
#include <iostream>
#include <cuda_runtime.h>

__device__ int multiply(int* a, int* b){
    return (*a) * (*b);

}

__global__ void dotproductvector(int*a , int*b , int*c , int N){
    int i = blockIdx.x *blockDim.x + threadIdx.x;
    

    if (i<N){
        c[i] = multiply(a+i,b+i);
    }
}

int main(){
    int N = 10;
    int size = N * sizeof(int);
    int * a = new int[N];
    int *b = new int[N];
    int *c = new int[N];

    for(int i = 0;i<N;i++){
        a[i] = i+1;
    }

    for(int i = 0; i < N; i++){
    b[i] = 20 - i; 
}



    int *a_in, *b_in, *c_in;
    cudaMalloc((void**)&a_in,size);
    cudaMalloc((void**)&b_in,size);
    cudaMalloc((void**)&c_in,size);

    cudaMemcpy(a_in,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(b_in,b,size,cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blockGrid = (N + threadsPerBlock-1 )/ threadsPerBlock;

    dotproductvector<<<threadsPerBlock, blockGrid>>>(a_in,b_in,c_in,N);

    cudaMemcpy(c,c_in,size,cudaMemcpyDeviceToHost);

    std::cout << "multiplied array: ";
    for (int i = 0; i < N; i++) {
        std::cout << a[i]<<" * "<<b[i]<<" = "<<c[i] << " \n";
        }
    std::cout << std::endl;


    return 0;

}