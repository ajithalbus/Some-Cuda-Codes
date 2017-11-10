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

using namespace std;
using namespace boost::filesystem;

//mfcc

//mfcc end

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
    string train="/home/ganesh/nw/dtw_cuda/datas/";
    
    string test="/home/ganesh/nw/dtw_cuda/datas/";
    
    mfcc one(train+"1/ac_1.mfcc");

    mfcc two(train+"2/ac_2.mfcc");
    mfcc three(train+"3/ac_3.mfcc");
    string testn;
    cin>>testn;
    
    mfcc testmfcc(test+testn);
    
    double d[3];
    
    d[0]=dtw_nv(one,testmfcc);
    d[1]=dtw_nv(two,testmfcc);
    d[2]=dtw_nv(three,testmfcc);

    cout<<argmin(d,3);

    

    //cout<<d;  
}