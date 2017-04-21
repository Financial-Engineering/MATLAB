function C = convo(m,p)
% -------------------------------------------------------------------------
% C = convo(m,p)
% This function calculates the convolution of the pdf.
%
% C = output vector of convolution values.
% m = mfold convolution.
% p = matrix of loss value and probabilities given one default pair.
% -------------------------------------------------------------------------

p = p(:);
if(m==1)
    C = p;
elseif (m==2)
    C = conv(p,p);
else
    convolution = conv(p,p);
    for i=3:m
        convolution = conv(convolution,p);
    end
    C = convolution;
end
