function f = CalibrationToCapsAndSwaptions(Lambda)

%0. Load Data
[Sig Today T_Num B] = LoadData();

% 1. Compute R
m=10; % Number of swaption maturities
M=20; % Number of swaptions maturities + number of swaption underlyings
R = []; % Setting zeros for matrix R as initial values
for i=1:m
    for j=i+1:M-m+i
        for k=i+1:j
            R(i,j,k)=(B(k-1)-B(k))/(B(i)-B(j));
        end
    end
end


%2. compute the variance-covariance matrix
VCV=[];
% diagonal elements of the VCV
for k=1:m
    VCV(k,k)=yearfrac(Today, T_Num(k))*Sig(k,1)^2/Lambda(k);
end


% off-diagonal param.
s=1;
for i=1:m
    for j=i+1:m
        Sum=0;
        for v=i+j-2*s+1:j+1
            for k=i+j-2*s+1:j+1
                SumTemp = R(i+j-2*s, j+1, k)*R(i+j-2*s, j+1, v)*VCV(k-1,v-1);
                Sum=Sum+SumTemp;
            end
        end
        
        term1 = yearfrac(Today,T_Num(i+j-2*s))*Sig(i+j-2*s,i+1)^2;
        term2 = Lambda(i+j-2*s)*(Sum-2*R(i+j-2*s, j+1, i+j-2*s+1)*VCV(i+j-2*s,j)*R(i+j-2*s,j+1,j+1));
        term3 = (2*Lambda(i+j-2*s)*R(i+j-2*s,j+1,i+j-2*s+1)*R(i+j-2*s, j+1, j+1));
        
        VCV(i+j-2*s, j)=(term1 - term2)/term3;
        VCV(j,i+j-2*s)=VCV(i+j-2*s,j);
    end
    s=s+1;
end


%3. Compute the eigenvalues of the variance-covariance matrix
[E,X]=eig(VCV);
L = diag(X);

%4. compute the modified variance-covariance matrix as a function of Lambda
for i=1:m
    if L(i)<0
        L_check(i)=1;
    else
        L_check(i)=0;
    end
end

for i=1:m
    if L_check(i)==0
        for j=1:m
            E_sqrL(j,i)=E(j,i)*sqrt(L(i));
        end
    else
        for j=1:m
            E_sqrL(j,i)=0;
        end
    end
end
%E_sqrL

VCV_M=E_sqrL*E_sqrL';

%5. Computation of the theoretical swaption volatilities

Sig_theo=[];
for k=1:m
    for N=k+1:m+1
        Sum=0;
        for v=k+1:N
            for i=k+1:N
                SumTemp=R(k,N,i)*VCV_M(i-1,v-1)*R(k,N,v);
                Sum=Sum+SumTemp;
                [k N v i]
            end
        end
        Sig_theo(k,N-k)=sqrt(Sum*Lambda(k)/yearfrac(Today,T_Num(k)));
    end
end
Sig_theo

%6. Compute the residual between theoretical and market swaption
%volatilities

RSME=0;
for i=1:m
    for j=1:m-i+1
        RSME_Temp = (Sig_theo(i,j)-Sig(i,j))^2;
        RSME=RSME+RSME_Temp;
    end
end

f=RSME

%%% to add in a test framework
% Initialisation of Lambda for optimisation
%Lambda0 = [1 2 3 4 5 6 7 8 9 10];
%[Lambda, f]=fminsearch(@CalibrationToCapsAndSwaptions,Lambda0);
      