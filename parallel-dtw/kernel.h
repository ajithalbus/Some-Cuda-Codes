#ifndef KERNEL_H 
#define KERNEL_H
#include "mfcc.h"
__global__ void k1(int *,int);
__global__ void k2(int *,int *);
__global__ void k3(int *,int );
__global__ void k4(int *,int *);
__global__ void k5(int *,int *);
__global__ void q(int ,int *,int *,int *,int *,int *,int,int);
__global__ void q2(int ,int *,int *,int *,int ,int);    
__global__ void q3(int ,double *,feature *,feature *,int ,int);    

#endif