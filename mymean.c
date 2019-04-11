#include "mex.h"

void mymean(double *outmse, double *ymtr, size_t M)
{
    mwSize m;
    double armean,msesum=0.0,arsum=0.0;
    for(m=0;m<M;m++){
        arsum+=ymtr[m];
    }
    armean=arsum/M;
    if(M>1){
        outmse[0]=armean;
    }
    else{
       outmse[0]=0.0;
    }
    
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{ double *ymtr,*outmse;
 size_t M;
 //size_t numel;
  M=mxGetM(prhs[0]);
  ymtr=mxGetPr(prhs[0]);
  //numel=mxGetN(prhs[0]);
  plhs[0]=mxCreateDoubleMatrix(1, 1, mxREAL);
  outmse = mxGetPr(plhs[0]);
  /*call the routine*/
 mymean(outmse,ymtr,M);
  
  
  
  /* code here */
}