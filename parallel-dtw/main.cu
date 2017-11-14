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

int argmin_val(double v[],int n){
    int i,min=0;
    double minval=1000000.0;
    for(i=0;i<n;i++){
        if(v[i]<minval){
            minval=v[i];
            //cout<<v[i]<<' ';
            min=i+1;
        }
    }
    return minval;
}

int main(){
    /*int x[]={1,2,3,4,5},y[]={2,4,6,2};
    int d=dtw_nv(x,y,5,4);
    //cout<<d;
    
    */
    int i,j;
    string train="/home/ganesh/nw/dtw_cuda/datas/";
    
    string test="/home/ganesh/nw/dtw_cuda/datas_test/";
    string testn;
    cout<<"Enter test file :: ";
    cin>>testn;
    
    mfcc testmfcc(test+testn);

    mfcc* templates=(mfcc *)malloc(sizeof(mfcc)*30);
    //omp_set_num_threads(30);
    double d[10];
    for(i=1;i<=9;i++){
        double temp_d[30];
        
        for(j=0;j<30;j++){
            templates[j]=mfcc(train+to_string(i)+"/"+to_string(j)+".mfcc");
        }

        #pragma omp parallel for
        for(j=0;j<30;j++){
            temp_d[j]=dtw_nv(testmfcc,templates[j]);
        }
        #pragma omp barrier
        #pragma omp flush
        
        d[i-1]=argmin_val(temp_d,30);
    }

    cout<<endl;
    /*for(i=0;i<9;i++)
    cout<<"diff-score - "<<i+1<<'-'<<d[i]<<endl;
*/
    cout<<"Predicted label :: "<<argmin(d,9)<<endl;
    
}