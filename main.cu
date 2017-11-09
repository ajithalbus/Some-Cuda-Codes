#include<stdio.h>
#include "prefix.h"
#include "dtw.h"
#include<iostream>
int main(){
    int x[]={1,2,3},y[]={2,4,6};
    /*for(int i=1;i<=5;i++){
        x[i]=i;
    }*/
    
    int d=dtw(x,y,3,3);

}