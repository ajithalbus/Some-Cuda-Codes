#include<iostream>
#include<fstream>
#include<stdlib.h>
#include<cuda.h>
#include "mfcc.h"
#include<string>
using namespace std;
//-Xcompiler -fopenmp


     mfcc::mfcc(){
        cout<<"DEFAULT CONSTRUCTOR"<<endl;
    }
     mfcc::mfcc(string file_name){
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

    



__host__ __device__ double euclids(feature a,feature b){
    int i;
    double value=0;
    for (i=0;i<38;i++){
        value+=(a.x[i]-b.x[i])*(a.x[i]-b.x[i]);
        //printf("%f-%f=%f\n",a.x[i],b.x[i],value);;
    }
    return sqrt(value);
}