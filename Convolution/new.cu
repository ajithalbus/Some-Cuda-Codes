/*
Template code for convolution. CS6023, IITM */
#include<stdio.h>
#include<cuda.h>
#include<math.h>

#define W 1024 // Input DIM
#define OW (W-4) // Output DIM
#define D 8   // Input and Kernel Depth
#define T 5  // Kernel DIM
#define N 128 // Number of kernels

void fillMatrix(unsigned char *matrix){

unsigned char (*m)[W][D]=(unsigned char (*)[W][D])matrix;

for(int i=0;i<W;i++){
	for(int j=0;j<W;j++){
		for(int k=0;k<D;k++){
			m[i][j][k]=(i*j+j*k+i*k+i*2+j*3+k*4)%255;
				}
			}
		}
}



void fillKernel(float *kernel){

float (*t)[T][T][D]=(float (*)[T][T][D])kernel;

for(int i=0;i<N;i++){
	for(int j=0;j<T;j++){
		for(int k=0;k<T;k++){
			for(int l=0;l<D;l++){
			t[i][j][k][l]=fmod(-(i+1)*2.1+(j+1)*3.2-(k+1)*4.8+(l+1)*7.1,1.0);
				}
			}
		}
	}
}



void print_matrix_to_file(float *m){

	const char *fname = "assignment4_out";
	FILE *f = fopen(fname, "w");

	float (*mat)[OW][OW]=(float (*)[OW][OW])m;		

	for(unsigned i=0; i < N; i++) {
		for(unsigned j=0; j < OW; j++)
			for(unsigned k=0;k<OW;k++)
				fprintf(f,"%4f ", mat[i][j][k]);
		fprintf(f,"\n");
	}
	fclose(f);
}
__global__ void conv(unsigned char *matrix,float *tile,float *output){

int filter=blockIdx.x;
int eX=blockIdx.y;
int eY=threadIdx.x;

unsigned char (*m)[W][D]=(unsigned char (*)[W][D])matrix;
float (*t)[T][T][D]=(float (*)[T][T][D])tile;
float (*o)[OW][OW]=(float (*)[OW][OW])output;

__shared__ unsigned char slice[W][D];

float psum;

if(eX<2||eX>W-3) return;

for(int j=0;j<T;j++){
	for(int i=0;i<D;i++){
		slice[eY][i]=m[(eX+j-2)][eY][i];
		
	}
__syncthreads();
	psum=0.0f;
	if(!(eY<2||eY>W-3)){
		for(int k=0;k<T;k++){
			for(int l=0;l<D;l++){
				psum+=t[filter][j][k][l]*slice[eY+k-2][l];	
				}
		}
		atomicAdd(&o[filter][(eX-2)][eY-2],psum);
	}
__syncthreads();

}

}



int main()
{

	unsigned char *matrix=(unsigned char*)malloc(sizeof(unsigned char)*W*W*D);
	float *kernel=(float*)malloc(sizeof(float)*T*T*D*N);
	float *output=(float *)malloc(sizeof(float)*N*OW*OW);


	fillMatrix(matrix);
	fillKernel(kernel);


	unsigned char *Dmatrix;cudaMalloc(&Dmatrix,sizeof(unsigned char)*W*W*D);
	float *Dkernel;cudaMalloc(&Dkernel,sizeof(float)*N*T*T*D);
	float *Doutput;cudaMalloc(&Doutput,sizeof(float)*N*OW*OW);

	cudaMemcpy(Dmatrix, matrix, sizeof(unsigned char)*W*W*D,cudaMemcpyHostToDevice);
	cudaMemcpy(Dkernel, kernel, sizeof(float)*T*T*D*N,cudaMemcpyHostToDevice);


	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	float milliseconds = 0;
	cudaEventRecord(start,0);

	//Make your cuda kernel call
	
	conv<<<dim3(N,W),W>>>(Dmatrix,Dkernel,Doutput);
	cudaDeviceSynchronize();


	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&milliseconds, start, stop);
	printf("%f\n",milliseconds);


	cudaMemcpy(output, Doutput, sizeof(float)*N*OW*OW,cudaMemcpyDeviceToHost);

	//Use print_matrix_to_file function only 
	
	print_matrix_to_file(output);

}
