main: mfcc.o kernel.o prefix.o dtw.o main.o
	nvcc -arch=sm_20 -lboost_system -Xcompiler -fopenmp mfcc.o kernel.o prefix.o dtw.o main.o -o run

dtw.o: dtw.cu dtw.h
	nvcc -arch=sm_20 -c dtw.cu

prefix.o: prefix.cu prefix.h
	nvcc -arch=sm_20 -c prefix.cu 

kernel.o: kernel.cu kernel.h
	nvcc -arch=sm_20 -c kernel.cu

mfcc.o: mfcc.cu
	nvcc -arch=sm_20 -c mfcc.cu

main.o: main.cu
	nvcc -arch=sm_20 -Xcompiler -fopenmp -c main.cu

clean: 
	rm -rf *.o run
