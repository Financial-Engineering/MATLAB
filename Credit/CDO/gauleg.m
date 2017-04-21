function [x, w] = gauleg(n, a, b)
% [x, w] = gauleg(n, a, b)
% MATH3311/MATH5335: File = gauleg.m
% Calcualte the n Gauss-Legendre quadrature points x and weights w
% for the interval [a, b]
% A better method is via the eigenvalues of a tridiagonal matrix

% Points are symmetric in the interval
m = fix((n+1)/2);
xmid = (a+b)/2;
xlen = (b-a)/2;

% Starting points for Newton's method to find
% roots of the Legendre polynomials
const = pi/(n+1/2);
z = cos(const*([1:m]-1/4));

% Newton's method
ztol = eps;
itmax = 20;
it = 0;
iterate = 1;
while iterate & it < itmax
   
   it = it + 1;
   % Recurrence to evaluate the Legendre polynomial
   p1 = ones(1,m);
   p2 = zeros(1,m);
   for j = 1:n
      p3 = p2;
      p2 = p1;
      p1 = ((2*j-1)*z.*p2 - (j-1)*p3)/j;
   end;
   
   % the derivative is given by a relation involving pp
   % the polynomial of one lower order
   pp = n*(z.*p1-p2)./(z.*z-1);
   
   % Store old point and get new point from Newton's method
   z1 = z;
   z = z1 - p1./pp;
   
   perr = max(abs(p1));
   zerr= max(abs(z-z1));
   iterate = zerr>ztol;

   %fprintf('it = %d, perr = %.2e, zerr = %.2e\n', it, perr, zerr);
   
end;

if it >= itmax
   fprintf('\nWarning: Maximum number of iterations reach in gauleg');
   fprintf('\nperr = %2.e, zerr = %.2e\n', perr, zerr);
   pause;
end;

% Compute the weights
w = 2*xlen./((1-z.*z).*pp.*pp);

% Scale roots and add symmetric couterparts
if n==2*m
   nz = m;
else 
   nz = m-1;
end;
x = [xmid-xlen*z  xmid+xlen*fliplr(z(1:nz))];
w = [w fliplr(w(1:nz))];


