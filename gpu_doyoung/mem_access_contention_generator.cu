#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <sys/types.h>
#include <nvToolsExt.h>
#include <string.h>
#include <assert.h>
#include <sys/time.h>

// CUDA runtime
#include <cuda.h>
#include <cuda_runtime.h>

// helper functions and utilities to work with CUDA
//#include <helper_functions.h>
//#include <helper_cuda.h>

	__global__
void vertorADDGPU(unsigned int n, float *x, float *y, float *z) {
	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	// Memory reads of 8MB and memory writes of 4MB in turn
	// because n = 0x1 << 20
//	if(idx < n) {
		z[idx] = x[idx] + y[idx];
//	}
}

double time_is_it_now(){
	struct timeval time;
	if(gettimeofday(&time,NULL)){
			return 0;
	}
	return (double)time.tv_sec + (double)time.tv_usec*.000001;
}

int main(int argc, char *argv[]) {
	unsigned ;int n = 0x1 << 20;
	int thr_num;
	float *x, *y, *z, *d_x, *d_y, *d_z;
	unsigned int flags = cudaHostAllocMapped;

	// Check the number of arguments
	if (argc != 2) {
		printf("please use with one argument\n");
		printf("The argument is thread num\n");
		return 1;
	}
	thr_num = atoi(argv[1]);

	// Dynamic memory allocation by using zero-copy memory mechanism
#if 0
	x = (float*)malloc(n*sizeof(float));
	y = (float*)malloc(n*sizeof(float));
	z = (float*)malloc(n*sizeof(float));
#else
	cudaHostAlloc((void **)&x, n * sizeof(float), flags);
	cudaHostAlloc((void **)&y, n * sizeof(float), flags);
	cudaHostAlloc((void **)&z, n * sizeof(float), flags);

#endif
	// Initialize the two input arrays
	for (unsigned int i = 0; i < n; i++) {
        x[i] = rand() / (float) RAND_MAX;
        y[i] = rand() / (float) RAND_MAX;
	}
#if 0
	cudaMalloc((void**)&d_x, n*sizeof(float));
	cudaMalloc((void**)&d_y, n*sizeof(float));
	cudaMalloc((void**)&d_z, n*sizeof(float));
	cudaMemcpy(d_x, x, n*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, y, n*sizeof(float), cudaMemcpyHostToDevice);
#else
	cudaHostGetDevicePointer((void **)&d_x, (void *)x, 0);
	cudaHostGetDevicePointer((void **)&d_y, (void *)y, 0);
	cudaHostGetDevicePointer((void **)&d_z, (void *)z, 0);
#endif
	// Set the number of threads
	dim3 block(thr_num);
	dim3 grid((unsigned int)ceil(n / (float)block.x));
	
	//double start;
	//int cnt =0;
	//start = time_is_it_now();
	while(1) {
		//printf("start\n");
		vertorADDGPU<<<thr_num, 1024>>>(n, d_x, d_y, d_z);
		//cudaDeviceSynchronize();
		//usleep(500);
#if 0
		if(cnt%10000 == 0){
			printf(" execution time : %lf \n", time_is_it_now() - start);
			start = time_is_it_now();
		}
#endif		
	//	cnt++;
	}
#if 0
	checkCudaErrors(cudaDeviceSynchronize());
#else
	cudaDeviceSynchronize();
#endif
	cudaFree(d_x);
	cudaFree(d_y);
	return 1;
}
