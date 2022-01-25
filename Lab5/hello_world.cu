#include <stdio.h>
__global__ void hello_GPU(int num) {
	int thr = threadIdx.x;
	printf("Hello from GPU%d[%d]!\n", num, thr);
}	

int main(void){
	printf("Hello from CPU!\n");
	hello_GPU<<<1,4>>>(1);
	hello_GPU<<<1,6>>>(2);
	cudaDeviceSynchronize();
	return 0;
}
