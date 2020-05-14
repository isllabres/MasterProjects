#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"

#define max(x,y) (x) > (y) ? (x) : (y)
#define min(x,y) (x) > (y) ? (y) : (x)

double ** bm(double *im1,double *im2,int bs,int sr,int H, int W,int medida,int bs1,double lambda);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double *im1,*im2,**u,*uout,*vout,lambda;
	mxArray *im1Data, *im2Data;
	int sr, bs, medida, H, W, bs1;
    
	
	im1Data=prhs[0];
	im2Data=prhs[1];
	im1 = mxGetPr(im1Data);
	im2 = mxGetPr(im2Data);
	bs=(int)(mxGetScalar(prhs[2]));
	sr=(int)(mxGetScalar(prhs[3]));
	medida=(int)(mxGetScalar(prhs[4]));
	lambda=(double)(mxGetScalar(prhs[5]));
	H=mxGetN(im1Data);
	W=mxGetM(im1Data);
	
	bs1=8;
	

	u=bm(im1,im2,bs,sr,H,W,medida,bs1,lambda);
    plhs[0] = mxCreateDoubleMatrix(W/bs1,H/bs1, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(W/bs1,H/bs1, mxREAL);
	
	uout = mxGetPr(plhs[0]);
	vout = mxGetPr(plhs[1]);
	memcpy(uout, u[0], (H*W)/(bs1*bs1)*sizeof(double));
	memcpy(vout, u[1], (H*W)/(bs1*bs1)*sizeof(double));
    return;
}

double ** bm(double *im1,double *im2,int bs,int sr,int H, int W,int medida,int bs1, double lambda)
{
	
	char *if1, *if2;
	FILE *f1, *f2,*fid;
	int i,j,iidx,jidx,x,y,xmin,ymin,xmax,ymax,p,q;
	double minC,C,aux,m1,m2,d1,d2,aux2;
	double **u;
	int leidos;  	
  	
  	u=(double **)malloc(2*sizeof(double *));
  	u[0]=calloc((H*W)/(bs1*bs1),sizeof(double));
	u[1]=calloc((H*W)/(bs1*bs1),sizeof(double));
	
	for(i=bs;i<=(W-bs);i=i+bs1){
		for(j=bs;j<=(H-bs);j=j+bs1){
			xmin=max(i-sr,bs);
			xmax=min(i+sr,W-bs);
			ymin=max(j-sr,bs);
			ymax=min(j+sr,H-bs);
			if(xmax<=xmin)
				printf("error xmax %d xmin %d i %d sr %d W %d bs %d\n",xmax,xmin,i,sr,W,bs);
			if(ymax<=ymin)
				printf("error\n");
			minC=1e10;
			for(x=xmin;x<xmax;x++){
				for(y=ymin;y<ymax;y++){
					C=0;
					if(medida==3){
						m1=0;
						m2=0;
						d1=0;
						d2=0;
						for(p=-bs;p<=bs;p++){
							for(q=-bs;q<=bs;q++){
								aux=im1[(j+q)*W+i+p];
								m1+=aux;
								d1+=aux*aux;
								aux=im2[(y+q)*W+x+p];
								m2+=aux;
								d2+=aux*aux;
							}
						}
						m1=m1/((2*bs+1)*(2*bs+1));
						m2=m2/((2*bs+1)*(2*bs+1));
						d1=sqrt(d1/((2*bs+1)*(2*bs+1))-m1*m1);
						d2=sqrt(d2/((2*bs+1)*(2*bs+1))-m2*m2);
					}
					C=0;
					for(p=-bs;p<=bs;p++){
						for(q=-bs;q<=bs;q++){
							if(medida==1){
								aux=(im1[(j+q)*W+i+p]-im2[(y+q)*W+x+p]);
								C+=aux*aux;
							}
							else if(medida==2){
								C+=abs(im1[(j+q)*W+i+p]-im2[(y+q)*W+x+p]);
							}
							else if(medida==3){
								aux=(im1[(j+q)*W+i+p]-m1)/d1;
								aux2=(im2[(y+q)*W+x+p]-m2)/d2;
								C+=aux*aux2;
							}
						}
					}
					C=C/((2*bs+1)*(2*bs+1));
					if(medida==1){
						C=C+lambda*10*(abs(x-i)+abs(y-j));
					}
					else if(medida==2){
						C=C+lambda*0.5*(abs(x-i)+abs(y-j));
					}
					else{
						C=fabs(C);
						C=1-C;
						C=C+lambda*0.1*(abs(x-i)+abs(y-j));
					}
					
					if(C<=minC){
						iidx=i/bs1;
					    jidx=j/bs1;
						u[0][jidx*(W/bs1)+iidx]=x-i;
						u[1][jidx*(W/bs1)+iidx]=y-j;
						minC=C;
					}
				}
			}
		}
	}

	return u;
}
