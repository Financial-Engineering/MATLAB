function C=correlateReturns(D)
    C=corrcoef(diff(D)./D(1:end-1,:));
end