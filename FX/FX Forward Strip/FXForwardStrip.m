function [ K ] = FXForwardStrip( Sold_Currency, Fixed_Currency, USD_PV_Amount, DF_Fixed_Currency, DF_Equivalent_Currency, Spot_USD_Fixed, Spot_USD_Equivalent, Exchange_Amounts )
%FXFORWARDSTRIP Summary of this function goes here

%Phi
if (Sold_Currency==Fixed_Currency)
    Phi=-1;
else
    Phi=1;
end;

% Forward rates
FW_Fixed=DF_Fixed_Currency./DF_Fixed_Currency(1);
FW_Floating=DF_Equivalent_Currency./DF_Equivalent_Currency(1);

% Numerator
Numerator=Phi*sum(Exchange_Amounts.*DF_Fixed_Currency)-USD_PV_Amount/Spot_USD_Fixed;

% Denominator
FW_Fixed_Per_Float=(Spot_USD_Equivalent/Spot_USD_Fixed).*FW_Floating./FW_Fixed;
Denominator=Phi*sum(Exchange_Amounts.*DF_Fixed_Currency.*FW_Fixed_Per_Float);

% Answer
K(1)=Numerator/Denominator;

% Proof
K(2)=Spot_USD_Fixed*sum(Phi.*Exchange_Amounts.*(1-K(1).*FW_Fixed_Per_Float).*DF_Fixed_Currency);

end

