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

__device__ int d_min(int a,int b){
    if(a<b) return a;
    return b;
}

__device__ int d_max(int a,int b){
    if(a>b) return a;
    return b;
}

__device__ int dist(int a,int b){
    return max(a,b)-min(a,b);
}

__global__ void k1(int *a,int d){
   int tid=blockIdx.x*B+threadIdx.x;
   if(threadIdx.x>=pow(2,d-1)){
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

__global__ void q(int i,int *D,int *x_device,int *y_device,int *X,int *Y,int xN,int yN){
    int j=threadIdx.x,t,z;
    if(j==0) {X[0]=x_device[0];return;}

    t=d_min(D[(i-1)*xN+j],D[(i-1)*xN+(j-1)])+dist(y_device[i],x_device[j]);
    z=t-Y[j];
    X[j]=min(z,X[j-1]);
    printf("x-%d y-%d\n",X[j],z);
    D[i*xN+j]=X[j]+Y[j];

}