#include <thrust/pair.h>
#include <thrust/device_vector.h>
#include <algorithm>
#include <cstdlib>
#include <iostream>
using namespace std;

void print(const thrust::device_vector< thrust::pair<int,int> > &v)
{thrust::pair<int,int> tmp;
  for(size_t i = 0; i < v.size(); i++)
	{tmp=v[i];
    std::cout << " " << tmp.first <<tmp.second;
  std::cout << "\n";}
}
__device__ int device_flag=0;

struct funct {
  funct(thrust::pair<int,int>  x) : x(x) {}
__device__   
void operator()(thrust::pair<int,int>  y) const {
	//printf("pair-%d-%d,%d-%d\n",x.first,x.second,y.first,y.second);
	if(device_flag==1) return;
	if(x.first==y.first||x.second==y.second||x.first-y.first==x.second-y.second||x.first-y.first==-(x.second-y.second)) {printf("NO\n%d %d\n%d %d\n",x.first,x.second,y.first,y.second);
		device_flag=1;
		
return;
	}

	

}

private:
  thrust::pair<int,int>  x;
	
};



int main(void)
{
int n,i,j,tmp,ptr=0;
cin>>n;
thrust::pair<int,int> pairs[n];
for(i=0;i<n;i++)
for(j=0;j<n;j++)
{cin>>tmp;
if(tmp==1){
pairs[ptr].first=i;
pairs[ptr].second=j;
ptr++;}
}
thrust::device_vector< thrust::pair<int,int> > q_pos(pairs,pairs+n);

int host_flag=0;

for(i=0;i<n;i++) //like a nested for
{
thrust::for_each(q_pos.begin()+i+1,q_pos.end(),funct(q_pos[i]));
cudaMemcpyFromSymbol((void*)&host_flag,device_flag,sizeof(int));
if(host_flag==1) break;
}

if(host_flag==0) cout<<"YES\n";
//print(q_pos);
  return 0;
}
