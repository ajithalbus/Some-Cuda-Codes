#include<iostream>
#include<fstream>
#include<stdlib.h>
using namespace std;
//-Xcompiler -fopenmp
class feature{
public:
    float x[38];

};


class mfcc{

public:
    int N,tmp;
    feature *features;
    mfcc(){
        cout<<"DEFAULT CONSTRUCTOR"<<endl;
    }
    mfcc(char file_name[]){
        fstream file;
        float t;
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

    float operator -(mfcc t){

    }

};
