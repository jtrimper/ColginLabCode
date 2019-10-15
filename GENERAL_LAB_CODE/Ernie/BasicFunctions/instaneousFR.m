function [FRmatrix] = instaneousFR(spkMatrix,winL,sampFreq)

FRmatrix = zeros(size(spkMatrix));
for ii = ceil(winL/2):size(spkMatrix,2)-ceil(winL/2)
    FRmatrix(:,ii) = sum(spkMatrix(:,ii-floor(winL/2)+1:ii+floor(winL/2)),2);
end
FRmatrix = FRmatrix./(winL/sampFreq);