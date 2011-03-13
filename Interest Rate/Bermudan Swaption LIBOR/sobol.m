function X = sobol(n, N)

% X = sobol(n, N)
% MATH3311/MATH5335: Files = sobol.m
% Generate the next N vectors of size n <= 6 in the Sobol sequence
% Output X is an n by N matrix with N columns giving points in R^n
% Must be called with a negative value of n to initialize
% Implementation of the Press et. al version

% Global variables required to store data from initialization
% and between calls to sobol

    global sobol_in sobol_iv sobol_ix sobol_fac

    MAXBIT = 30;

    % Numerical Recipes initialization
    MAXDIM = 6;
    mdeg = [1; 2; 3; 3; 4; 4];

    if n < 0

       % Initialization process
       sobol_iv = zeros(MAXDIM,MAXBIT);
       % Numerical Recipes initialization
       ip =   [0; 1; 1; 2; 1; 4];
       sobol_iv(:,1:4) = [ 1  3  5 15;
                           1  1  7 11;
                           1  3  7  5;
                           1  3  3 15;
                           1  1  3 13;
                           1  1  5  9];

       sobol_ix = zeros(MAXDIM,1);
       sobol_in = 0;
       if sobol_iv(1,1)~=1
          error(['Sobol_init: iv(1,1) = ', num2str(sobol_iv(1,1))]);
       end;
       sobol_fac = 1 / 2^MAXBIT;
       for k = 1:MAXDIM

          for j = 1:mdeg(k)
             sobol_iv(k,j) = sobol_iv(k,j)*2^(MAXBIT-j);
          end;

          for j = mdeg(k)+1:MAXBIT

             ipp = ip(k);
             i = sobol_iv(k,j-mdeg(k));
             i = bitxor(i, fix(i/2^mdeg(k)));
             for l = mdeg(k)-1:-1:1
                if bitand(ipp,1)~=0
                   i = bitxor(i, sobol_iv(k,j-l));
                end;
                ipp = fix(ipp/2);
             end;
             sobol_iv(k,j) = i;
          end;
       end;
       X = [];

    else

       % Generate next N vectors if size n in Sobol sequence
       % Slow for loop to generate N points
       X = zeros(n,N);
       for j = 1:N
          x = zeros(n,1);
          im = sobol_in;
          for i = 1:MAXBIT
             if bitand(im,1)==0
                break
             else
                im = fix(im/2);
             end;
          end;
          im = (i-1)*MAXDIM;
          for k = 1:min(n,MAXDIM)
             sobol_ix(k) = bitxor(sobol_ix(k), sobol_iv(im+k));
             x(k) = sobol_ix(k) * sobol_fac;
          end;
          sobol_in = sobol_in+1;
          X(:,j) = x;
       end

    end
end
