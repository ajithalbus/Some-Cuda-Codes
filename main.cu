#include<stdio.h>
#include "prefix.h"
#include "dtw.h"
#include<iostream>
#include<fstream>
#include<stdlib.h>
#include<cuda.h>
#include <boost/filesystem.hpp>
#include <string>
#include "mfcc.h"
#include <omp.h>
using namespace std;
using namespace boost::filesystem;

//mfcc

//mfcc end
char * to_string(int x){
    char *a=(char *)malloc(2);
    a[0]=x+48;
    a[1]='\0';
    return a;
}

int argmin(double v[],int n){
    int i,min=0;
    double minval=1000000.0;
    for(i=0;i<n;i++){
        if(v[i]<minval){
            minval=v[i];
            //cout<<v[i]<<' ';
            min=i+1;
        }
    }
    return min;
}

int main(){
    //int x[]={1,2,3};
    /*for(int i=1;i<=5;i++){
        x[i]=i;
    }*/
    //int d=dtw_nv(x,x,3,3);
    int i;
    string train="/home/ganesh/nw/dtw_cuda/datas/";
    
    string test="/home/ganesh/nw/dtw_cuda/datas/";
    string testn;
    cin>>testn;
    
    mfcc testmfcc(test+testn);
       mfcc* templates=(mfcc *)malloc(sizeof(mfcc)*10);
    
    #pragma omp parallel for 
    for(i=1;i<=9;i++){
        templates[i-1]=mfcc(train+to_string(i)+"/ac_"+to_string(i)+".mfcc");
        //cout<<"D-READ "<<i<<endl;
    }
    //cout<<train+to_string(1)+"/ac_"+to_string(1)+".mfcc";
    //cout<<dtw_nv(templates[0],testmfcc);
    
    double d[9];
    #pragma omp parallel for
    for(i=0;i<9;i++){
        d[i]=dtw_nv(testmfcc,templates[i]);
        //cout<<"D-TEST "<<i<<endl;
    }
    cout<<argmin(d,9);
    /*
        mfcc one(train+"1/ac_1.mfcc");

    mfcc two(train+"2/ac_2.mfcc");
    mfcc three(train+"3/ac_3.mfcc");
    string testn;
    
    double d[3];
    
    d[0]=dtw_nv(one,testmfcc);
    d[1]=dtw_nv(two,testmfcc);
    d[2]=dtw_nv(three,testmfcc);

    cout<<argmin(d,3);

    */

    //cout<<d;  
}