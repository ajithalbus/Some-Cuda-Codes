// Tested working with single block , in GPGPU-SIM with sm_20.
#include<stdio.h>
#include<math_functions.h>
#include<cuda.h>

/* The kernel "msort" should sort the input array using parallel merge-sort. */

__device__ int pow(int a,int b){
    int pwr=1,i;
    for(i=0;i<b;i++)
        pwr*=a;
    return pwr;
}

__global__ void msort(int *d_input, int* d_temp, int N)
{int lvl=1;
int id=threadIdx.x+blockIdx.x*blockDim.x;
int i,m,r,k,j,p;


while(int(pow(2,lvl))<=pow(2,int(ceil(log2(float(N))))))

{
    if(id<N){
    
if(id%pow(2,lvl)==0)
{
i=id;
m=(id+int(pow(2,lvl-1))>N)?N:id+int(pow(2,lvl-1));
j=m;
r=(id+int(pow(2,lvl))>N)?N:id+int(pow(2,lvl));
k=id;

for(p=id;p<r;p++)
d_temp[p]=d_input[p];

while(i<m &&j<r){
    if(d_temp[i]<d_temp[j]){
        d_input[k++]=d_temp[i++];
    }
    else
    {
        d_input[k++]=d_temp[j++];
    }

}
while(i<m){
    d_input[k++]=d_temp[i++];
}
while(j<r){
    d_input[k++]=d_temp[j++];
}

}


    
    }
    
lvl++;
__syncthreads();    


}
}





