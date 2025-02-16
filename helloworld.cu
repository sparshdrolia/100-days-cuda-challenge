#include<stdio.h>

__global__ void helloworldonkernellesgoo(){
    printf("Hello from the pther side. Hi my name is thread %d\n",threadIdx.x);
}

int main(){
    helloworldonkernellesgoo<<<1,10>>>();
    cudaDeviceSynchronize();
    return 0;
}
