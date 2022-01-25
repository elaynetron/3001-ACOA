#include <stdio.h>

__global__ void add_GPU(int *vect_a, int *vect_b, int *vect_c){
	int thr = threadIdx.x;
	vect_c[thr] = vect_a[thr] + vect_b[thr];
}

int main(void) {
	int size = 4;
	int a[size] = {22,13,16,5};
	int b[size] = {5,22,17,37};
	int c[size];
	
	int *vect_a, *vect_b, *vect_c;
	cudaMalloc((void**) &vect_a, sizeof(int)*size);
	cudaMalloc((void**) &vect_b, sizeof(int)*size);
	cudaMalloc((void**) &vect_c, sizeof(int)*size);
	
	cudaMemcpy(vect_a, &a, sizeof(int)*size, cudaMemcpyHostToDevice);
	cudaMemcpy(vect_b, &b, sizeof(int)*size, cudaMemcpyHostToDevice);

	add_GPU<<<1,size>>>(vect_a, vect_b, vect_c);

	cudaMemcpy(&c, vect_c, sizeof(int)*size, cudaMemcpyDeviceToHost);
	cudaFree(vect_a);
	cudaFree(vect_b);
	cudaFree(vect_c);

	printf("C: %d %d %d %d\n", c[0], c[1], c[2], c[3]);
	return 0;
}
