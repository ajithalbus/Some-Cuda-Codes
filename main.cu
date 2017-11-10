#include<stdio.h>
#include "prefix.h"
#include "dtw.h"
#include<iostream>
#include<fstream>
#include<stdlib.h>
#include<cuda.h>
#include <boost/filesystem.hpp>
#include <string>
//#include "mfcc.h"

using namespace std;
using namespace boost::filesystem;

//mfcc

class feature{
public:
    float x[38];

};


class mfcc{

public:
    int N,tmp;
    feature *features;
    __host__ mfcc(){
        cout<<"DEFAULT CONSTRUCTOR"<<endl;
    }
    __host__ mfcc(string file_name){
        fstream file;
        file.open (file_name.c_str(), ios::in );
        file>>tmp>>N;
        features=(feature *)malloc(N*sizeof(feature));
        for(int i=0;i<N;i++){
            for(int j=0;j<38;j++){
                file>>features[i].x[j];
            }
        }
        //cout<<features[0].x[37];
    }

    

};


__host__ __device__ float euclids(feature *a,feature *b){
    int i;
    float value=0;
    for (i=0;i<38;i++){
        value+=(a->x[i]-b->x[i])*(a->x[i]-b->x[i]);
    }
    return sqrt(value);
}
//mfcc end



int main(){
    //int x[]={1,2,3};
    /*for(int i=1;i<=5;i++){
        x[i]=i;
    }*/
    //int d=dtw_nv(x,x,3,3);
    string fd="/home/ganesh/nw/dtw_cuda/datas/1/ac_";
    
    mfcc one(fd+"1.mfcc");
    mfcc two(fd+"2.mfcc");
    mfcc three(fd+"3.mfcc");
    
}