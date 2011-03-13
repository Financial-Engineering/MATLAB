function II=CDFBVNorm(a,b,rho)
% computes the value of Pr[X<a,Y<b] when X and Y are N(0,1) margins,
% correlated with a parameter rho
minfty=-15;
tol=10^(-6);
II=quadl(@itgd,minfty,b,tol,0,a,rho);


