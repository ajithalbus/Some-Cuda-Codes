#include<stdio.h>
#include<cuda.h>
#include "prefix.h"
#include "kernel.h"
#include<iostream>
#include "dtw.h"
using namespace std;

int abs(int a){
    return (a>0)?a:-a;
}

double dtw_nv(mfcc x,mfcc y){

    size_t ds=sizeof(x.features[0]);
    double *D;
    double *D_host;
    feature *x_device,*y_device;
    int i,j;
    

    D_host=(double *)malloc(ds*x.N*(y.N+1));
    
    cudaMalloc(&D,ds*x.N*(y.N+1));
    //cudaMemset(&D,0,ds*xN*(yN+1));
    
    cudaMalloc(&x_device,ds*x.N);
    cudaMalloc(&y_device,ds*y.N);
    
    cudaMemcpy(x_device,x.features,ds*x.N,cudaMemcpyHostToDevice);
    cudaMemcpy(y_device,y.features,ds*y.N,cudaMemcpyHostToDevice);
    
    //calculating 1st row & 1st col
    double tmp[x.N];
    tmp[0]=abs(euclids(x.features[0],y.features[0]));
    
    for(i=1;i<x.N;i++){
    tmp[i]=tmp[i-1]+abs(euclids(x.features[0],y.features[0]));
    }
    
    cudaMemcpy(D,tmp,sizeof(double)*x.N,cudaMemcpyHostToDevice);
    
    for(i=1;i<y.N;i++)
    q3<<<1,x.N>>>(i,D,x_device,y_device,x.N,y.N);


    
    
    cudaMemcpy(D_host,D,ds*x.N*(y.N+1),cudaMemcpyDeviceToHost);
    
    /*
    for(i=0;i<y.N;i++){
        for(j=0;j<x.N;j++){
            cout<<D_host[(i*x.N)+j]<<' ';
            
        }
        cout<<endl;
    }
    */
    //return 0;
    return D_host[(y.N-1)*x.N+(x.N-1)];
    
}

int dtw_nv(int *x,int *y,int xN,int yN){
    size_t ds=sizeof(x[0]);
    int *D;
    int *D_host;
    int *x_device,*y_device;
    int i,j;
    

    D_host=(int *)malloc(ds*xN*(yN+1));
    
    cudaMalloc(&D,ds*xN*(yN+1));
    cudaMemset(&D,0,ds*xN*(yN+1));
    
    cudaMalloc(&x_device,ds*xN);
    cudaMalloc(&y_device,ds*yN);
    
    cudaMemcpy(x_device,x,ds*xN,cudaMemcpyHostToDevice);
    cudaMemcpy(y_device,y,ds*yN,cudaMemcpyHostToDevice);
    
    //calculating 1st row & 1st col
    int tmp[xN];
    tmp[0]=abs(x[0]-y[0]);
    
    for(i=1;i<xN;i++){
    tmp[i]=tmp[i-1]+abs(x[i]-y[0]);
    }
    
    cudaMemcpy(D,tmp,ds*xN,cudaMemcpyHostToDevice);
    
    for(i=1;i<yN;i++)
    q2<<<1,xN>>>(i,D,x_device,y_device,xN,yN);


    
    
    cudaMemcpy(D_host,D,ds*xN*(yN+1),cudaMemcpyDeviceToHost);
    
    for(i=0;i<yN;i++){
        for(j=0;j<xN;j++){
            cout<<D_host[(i*xN)+j]<<' ';
            
        }
        cout<<endl;
    }
    
    return 0;
        
}


int dtw(int *x,int *y,int xN,int yN)
{
    size_t ds=sizeof(x[0]);
int *D,*y_host,*X,*Y;
int *D_host;
int *x_device,*y_device;
int i,j;

D_host=(int *)malloc(ds*xN*(yN+1));

cudaMalloc(&D,ds*xN*(yN+1));
cudaMalloc(&X,ds*xN);
cudaMalloc(&Y,ds*xN);
cudaMalloc(&x_device,ds*xN);
cudaMalloc(&y_device,ds*yN);

cudaMemcpy(x_device,x,ds*xN,cudaMemcpyHostToDevice);
cudaMemcpy(y_device,y,ds*yN,cudaMemcpyHostToDevice);

int tmp[xN];
tmp[0]=abs(x[0]-y[0]);
for(i=1;i<xN;i++){
tmp[i]=tmp[i-1]+abs(x[i]-y[0]);
}

cudaMemcpy(D,tmp,ds*xN,cudaMemcpyHostToDevice);


for(i=1;i<yN;i++){
    cudaMemcpy(D_host,D+(i-1)*xN,ds*xN,cudaMemcpyDeviceToHost);
    y_host=prefix(D_host,xN);
    //for(int k=0;k<xN;k++) {cout<<"pre-"<<y_host[k];}
    cudaMemcpy(Y,y_host,ds*xN,cudaMemcpyHostToDevice);
    q<<<1,xN>>>(i,D,x_device,y_device,X,Y,xN,yN);
    cudaDeviceSynchronize();
}

cudaMemcpy(D_host,D,ds*xN*(yN+1),cudaMemcpyDeviceToHost);

for(i=0;i<yN;i++){
    for(j=0;j<xN;j++){
        cout<<D_host[(i*xN)+j]<<' ';
        
    }
    cout<<endl;
}

return 0;
}