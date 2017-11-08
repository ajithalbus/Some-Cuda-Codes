#include<stdio.h>
#include<cuda.h>

#define B 32
__device__ int pow(int a,int b){
    int result=1;
    while(b-->0){
        result*=a;
    }
    return result;
}

__global__ void k1(int *a,int d){
   int tid=blockIdx.x*B+threadIdx.x;
   if(tid>=pow(2,d)){
       a[tid]+=a[tid-pow(2, d-1)];
   }
}

__global__ void k2(int *Aux,int *S){

Aux[threadIdx.x]=S[(threadIdx.x+1)*B-1];
}

__global__ void k3(int *Aux,int d){
    if(threadIdx.x>=pow(2,d)){
        Aux[threadIdx.x]+=Aux[threadIdx.x-pow(2,d-1)];
    }
}

__global__ void k4(int *Aux,int *S){
    if(blockIdx.x==0) return;
    int tid=blockIdx.x*B+threadIdx.x;
    S[tid]+=Aux[blockIdx.x-1];
}

__global__ void k5(int *Aux,int *S){
    if(threadIdx.x==0) return;
    S[(threadIdx.x+1)*B-1]=Aux[threadIdx.x];
}