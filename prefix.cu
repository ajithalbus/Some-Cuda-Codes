#include<stdio.h>
#include<cuda.h>
#include<math.h>
#include<iostream>
#include "kernel.h"
#define B 32
using namespace std;

void prefix(int *x,int n){
int p=ceil(n*1.0/B);

int *S;
int *Aux;
int *S_host;

S_host=(int *)malloc(sizeof(x[0])*n);

cudaMalloc(&S,sizeof(x[0])*n);
cudaMemcpy(S,x,sizeof(x[0])*n,cudaMemcpyHostToDevice);

cudaMalloc(&Aux,sizeof(x[0])*p);

for(int d=1;d<=log(B);d++){
    k1<<<p,B>>>(S,d);
}
cudaDeviceSynchronize();



k2<<<1,p>>>(Aux,S);

cudaDeviceSynchronize();


for(int d=1;d<=ceil(log(p));d++){
    k3<<<1,p>>>(Aux,d);
}
cudaDeviceSynchronize();

k4<<<p,B-1>>>(Aux,S);

cudaDeviceSynchronize();

k5<<<1,p>>>(Aux,S);

cudaDeviceSynchronize();
cudaMemcpy(S_host,S,sizeof(x[0])*n,cudaMemcpyDeviceToHost);
for(int i=0;i<n;i++){
    cout<<S_host[i]<<endl;
}

}