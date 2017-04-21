#include <iostream>

#include <math.h>
#include <mkl_vml_functions.h>
#include <mkl_vsl_defines.h>
#include <mkl_vsl_functions.h>

#define MAX(a,b) (a)>(b)?(a):(b)

const int BLOCK_SIZE = 1024;
const int nsamples=65535;
const int SEED=253;
const double R=0.05;
const double VOLATILITY=0.20;
const double S0=100;
const double E=100;
const double T=1;

int main (int argc, char * const argv[]) {
	VSLStreamStatePtr   stream; 
	static double dbBuf[BLOCK_SIZE]; 
	double dbDrift, dbVolatilitySqrtOfT; 
	double dbA, dbSigma, dbB, dbBeta; 
	double dbPayoff; 
	double dbSum, dbSqrSum; 
	double dbExpectedPayoff; 
	double dbDiscountedPayoff; 
	double dbStdErr; 
	int iNBlocks, iNTail; 
	int i,j; 
	
	iNBlocks = nsamples / BLOCK_SIZE; 
	iNTail = nsamples - iNBlocks*BLOCK_SIZE; 
	
	/**************************************************************** 
	 Step 1. Random number generator initialization 
	 ****************************************************************/ 
	vslNewStream( &stream, VSL_BRNG_MCG31, SEED ); 
	/**************************************************************** 
	 Step 2. Simulation 
	 ****************************************************************/ 
	dbDrift = R - 0.5*VOLATILITY*VOLATILITY; 
	dbVolatilitySqrtOfT = VOLATILITY*sqrt(T); 
	
	dbA = dbDrift; 
	dbSigma = dbVolatilitySqrtOfT; 
	dbB = -E; 
	dbBeta = S0; 
	
	dbSum = 0.0; 
	dbSqrSum = 0.0; 
	/* Main loop */ 
	for ( i = 0; i < iNBlocks; i++ ) 
	{ 
		vdRngLognormal( VSL_METHOD_DLOGNORMAL_ICDF, stream, 
					   BLOCK_SIZE, dbBuf, dbA, dbSigma, dbB, dbBeta ); 
		for ( j = 0; j < BLOCK_SIZE; j++ ) 
		{ 
			dbPayoff = MAX( dbBuf[j], 0.0 ); 
			dbSum += dbPayoff; 
			dbSqrSum += dbPayoff*dbPayoff; 
		} 
	} 
	dbExpectedPayoff = dbSum / (double)nsamples; 
    dbDiscountedPayoff = exp(-R*T)*dbExpectedPayoff; 
    dbStdErr = sqrt( (dbSqrSum-dbSum*dbSum/(double)nsamples)/ 
					(double)(nsamples-1)/(double)(nsamples) ); 
	/**************************************************************** 
	 Step 3. Deleting the stream 
	 ****************************************************************/ 
    vslDeleteStream( &stream ); 
	
	double sterr = dbStdErr; 
    return dbDiscountedPayoff; 
} 	

