#include<stdio.h>
#include<cuda.h>
#include<math.h>

#include<iostream>
#include "kernel.h"
#define B 32
using namespace std;

int* prefix(int *x,int n){
int p=ceil(n*1.0/B);
;
int *S;
int *Aux;
int *S_host;
int *Aux_host;
S_host=(int *)malloc(sizeof(x[0])*(n+1));
Aux_host=(int *)malloc(sizeof(x[0]*p));
cudaMalloc(&S,sizeof(x[0])*n);
cudaMemcpy(S,x,sizeof(x[0])*n,cudaMemcpyHostToDevice);

cudaMalloc(&Aux,sizeof(x[0])*p);



for(int d=1;d<=ceil(log(B)+1);d++){
    k1<<<p,B>>>(S,d);
}



cudaDeviceSynchronize();




k2<<<1,p>>>(Aux,S);

cudaDeviceSynchronize();




for(int d=1;d<=ceil(log(p)+1);d++){
    k1<<<1,p>>>(Aux,d);
}
cudaDeviceSynchronize();

/*cudaMemcpy(Aux_host,Aux,sizeof(x[0])*p,cudaMemcpyDeviceToHost);
for(int i=0;i<p;i++){
    cout<<i<<'-'<<Aux_host[i]<<"\n";
}
*/

k4<<<p,B-1>>>(Aux,S);

cudaDeviceSynchronize();

k5<<<1,p>>>(Aux,S);

cudaDeviceSynchronize();

cudaMemcpy(S_host,S,sizeof(x[0])*n,cudaMemcpyDeviceToHost);
/*
for(int i=0;i<n;i++){
    cout<<i+1<<'-'<<S_host[i]<<"\n";
}*/
cudaFree(S);
cudaFree(Aux);
free(Aux_host);
/*
cudaMemcpy(S_host,S,sizeof(x[0])*n,cudaMemcpyDeviceToHost);
for(int i=0;i<n;i++){
    cout<<i+1<<'-'<<S_host[i]<<"\n";
}*/

if(S_host[0]!=x[0]){
S_host[n]=S_host[n-1]+x[n];
return S_host+1;}
return S_host;

}