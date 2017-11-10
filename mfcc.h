#ifndef MFCC_H 
#define MFCC_H

class feature{
public:
    float x[38];
};


class mfcc{
public:
    int N,tmp;
    feature *features;
    __host__ mfcc();
    __host__ mfcc(char file_name[]);
};
__host__ __device__ float euclids(feature *,feature *);
#endif