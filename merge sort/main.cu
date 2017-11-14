#include<stdio.h>
#include "kernels.h"
#define N 32
int main()

{int tmpx[N];
//int x[N]={64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
int x[N]={32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
int *kerx,*tmp,i;//*counter,c=99;
cudaMalloc(&kerx,sizeof(int)*N);
cudaMalloc(&tmp,sizeof(int)*N);
//cudaMalloc(&counter,sizeof(int));
cudaMemcpy(kerx,x,sizeof(int)*N,cudaMemcpyHostToDevice);


msort<<<1,N>>>(kerx,tmp,N);

cudaThreadSynchronize();
cudaMemcpy(x,kerx,sizeof(int)*N,cudaMemcpyDeviceToHost);
cudaMemcpy(tmpx,tmp,sizeof(int)*N,cudaMemcpyDeviceToHost);

//cudaMemcpy(&c,counter,sizeof(int),cudaMemcpyDeviceToHost);
//printf("\ncounter-%d\n",c);


for(i=0;i<N;i++)
printf("%d\n",x[i]);


}
