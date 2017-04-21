h_total = 0;
for i=1:100
    z=randn(1,500);
    %[h,p] = chi2gof(z,'alpha',0.01);
    [h,p] = chi2gof(z);
    h_total = h_total + h;
end
h_total