#include<stdio.h>
#include "prefix.h"
#include "dtw.h"
#include<iostream>
#include "mfcc.cc"
using namespace std;
int main(){
    int x[]={1,2,3};
    /*for(int i=1;i<=5;i++){
        x[i]=i;
    }*/
    //int d=dtw_nv(x,x,3,3);
    char fd[50]="/home/ganesh/dtw_cuda/datas/1/ac_1.mfcc";
    mfcc vari(fd);

}