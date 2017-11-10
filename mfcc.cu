#include<iostream>
#include<fstream>
#include<stdlib.h>
#include<cuda.h>
#include "mfcc.h"
using namespace std;
//-Xcompiler -fopenmp


    __host__ mfcc::mfcc(){
        cout<<"DEFAULT CONSTRUCTOR"<<endl;
    }
    __host__ mfcc::mfcc(char file_name[]){
        fstream file;
        file.open (file_name, ios::in );
        file>>tmp>>N;
        features=(feature *)malloc(N*sizeof(feature));
        for(int i=0;i<N;i++){
            for(int j=0;j<38;j++){
                file>>features[i].x[j];
            }
        }
        //cout<<features[0].x[37];
    }

    



__host__ __device__ float euclids(feature *a,feature *b){
    int i;
    float value=0;
    for (i=0;i<38;i++){
        value+=(a->x[i]-b->x[i])*(a->x[i]-b->x[i]);
    }
    return sqrt(value);
}