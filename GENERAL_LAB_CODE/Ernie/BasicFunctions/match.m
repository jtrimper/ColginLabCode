function targetInd = match(input,target)
N = length(input);

targetInd = zeros(N,1);

for ii = 1:N
    diff = (target-input(ii)).^2;
    [m,ind] = min(diff);
    targetInd(ii) = ind(1);
end