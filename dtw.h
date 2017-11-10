#ifndef DTW_H 
#define DTW_H
#include "mfcc.h"

int  dtw(int *,int *,int,int);
int dtw_nv(int *,int *,int,int);
double dtw_nv(mfcc x,mfcc y);
#endif