#include <stdio.h>

__global__ void calc_GPU(int *vect_a, double *vect_result){
	int thr = threadIdx.x;
	int blk = blockIdx.x;
	int size = 4;
	__shared__ double temp[4];
	double price[4] = {29.99, 14.99, 9.99, 24.99};
	temp[thr] = vect_a[blk*blockDim.x + thr]*price[thr];
	__syncthreads();
	for (int i = 0; i < size; i++)
		vect_result[blk] += temp[i];
}

int main(void) {
	int size = 4;
	int a[7*size] = {3,5,2,0, 2,4,5,1, 0,3,3,1, 3,5,4,4, 4,5,5,3, 10,13,21,16, 8,11,15,8};
	double result[7] = {0,0,0,0,0,0,0};
	
	int *vect_a;
	double *vect_result;
	cudaMalloc((void**) &vect_a, sizeof(int)*7*size);
	cudaMalloc((void**) &vect_result, sizeof(double)*7);
	
	cudaMemcpy(vect_a, &a, sizeof(int)*7*size, cudaMemcpyHostToDevice);

	calc_GPU<<<7,size>>>(vect_a, vect_result);
	cudaDeviceSynchronize();

	cudaMemcpy(&result, vect_result, sizeof(double)*7, cudaMemcpyDeviceToHost);
	cudaFree(vect_a);
	cudaFree(vect_result);

	printf("Sales: %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n", result[0], result[1], 
result[2], result[3], result[4], result[5], result[6]);
	return 0;
}
