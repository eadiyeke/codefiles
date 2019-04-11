#include <stdio.h>
#include <string.h>
#include "mex.h"

/*nominal gonderme, charify et:/*/
void compgini4numeric(double *prob,double *outmat, double *inp1, double *inp2,size_t numcat,size_t numcat2)
{
    
    mwSize i,j;
   int cntr,numofnonzeros=0;
   double sumsq=0.0;
    if(numcat2>1){
        for(i=0;i<numcat;i++){
            cntr=0;
            for(j=0;j<numcat2;j++){
                if(inp1[j]==inp2[i]){
                    cntr=cntr+1;
                }
            }
           // printf("%d\n",cntr);
            outmat[i]=cntr;
        }     
    }
   /*check purity: count nonzeros of the cats*/
   for(i=0;i<numcat;i++){
       if(outmat[i]!=0.0)
           numofnonzeros++;
   }
   if(numofnonzeros==1){
       prob[0]=0.0;
   }
   for(i=0;i<numcat;i++){
       sumsq=sumsq+((outmat[i]/numcat2)*(outmat[i]/numcat2));
   }
   prob[0]=1.0-sumsq;
   if(numcat2<=1)
      prob[0]=0.0;
   
   
    
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{ double *inp1,*inp2;
  //size_t M1,M2,m1,m2;
  double *outmat;
  double *prob;
  //int status,status2;
  size_t numcat;
  size_t numcat2;
  /*m1=mxGetM(prhs[0])*sizeof(mxChar);
   * m2=mxGetM(prhs[1])*sizeof(mxChar);
   * M1=mxGetM(prhs[0])*sizeof(mxChar)+1;
   * M2=mxGetM(prhs[1])*sizeof(mxChar)+1;
   * inp1=mxMalloc(M1);
   * inp2=mxMalloc(M2);
   * status = mxGetString(prhs[0], inp1, (mwSize)M1);
   * status2 = mxGetString(prhs[1], inp2, (mwSize)M2);*/
  inp1=mxGetPr(prhs[0]);
  inp2=mxGetPr(prhs[1]);
  numcat=mxGetM(prhs[1]);
  numcat2=mxGetM(prhs[0]);
  //countcats = mxGetPr(prhs[2]);
  plhs[1]=mxCreateDoubleMatrix(1,numcat, mxREAL);
  outmat = mxGetPr(plhs[1]);
  plhs[0]=mxCreateDoubleMatrix(1,1, mxREAL);
  prob = mxGetPr(plhs[0]);
  /*mexPrintf("%d\n",strlen(inp1));
  mexPrintf("The input string is:  %s\n", inp1);
  mexPrintf("The input string is:  %s\n", inp2);*/
  
  compgini4numeric(prob,outmat,inp1,inp2,numcat,numcat2);
  //mxFree(inp1);
  //mxFree(inp2);
}