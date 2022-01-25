#include <stdio.h>

__global__ void dotprod_GPU(int *vect_a, int *vect_b, int *vect_c){
	int thr = threadIdx.x;
	int size = 4;
	__shared__ int temp[4];
	temp[thr] = vect_a[thr] * vect_b[thr];
	__syncthreads();

	if (thr == 0){
		int total = 0;
		for (int i = 0; i < size; i++)
			total += temp[i];
		*vect_c = total;
	}
}

int main(void){
	int size = 4;
	int a[size] = {22,13,16,5}; 
	int b[size] = {5,22,17,37}; 
	int c;

	int *vect_a, *vect_b, *vect_c;
	cudaMalloc((void**)&vect_a, sizeof(int)*size);
	cudaMalloc((void**)&vect_b, sizeof(int)*size);
	cudaMalloc((void**)&vect_c, sizeof(int));

	cudaMemcpy(vect_a, &a, sizeof(int)*size, cudaMemcpyHostToDevice); 
	cudaMemcpy(vect_b, &b, sizeof(int)*size, cudaMemcpyHostToDevice);
	
	dotprod_GPU<<<1,size>>>(vect_a, vect_b, vect_c);
	cudaMemcpy(&c, vect_c, sizeof(int), cudaMemcpyDeviceToHost); 
	cudaFree(vect_a);
	cudaFree(vect_b);
	cudaFree(vect_c);

	printf("Answer = %d\n", c);
	return 0;
}
