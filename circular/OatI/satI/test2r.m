function  [pval, r] = test2r(x,y)
%TEST2R   Test for equal location of two samples using rank test
%         
%         [pval, ranksum] = test1r(x,y)
%         
%         This is the Wilcoxon-Mann-Whitney test. It is two sided. 
%         If you want a one sided alternative then devide pval by 2.

%       Anders Holtsberg, 18-11-93
%       Copyright (c) Anders Holtsberg

x = x(:);
x = x(find(x~=0));
y = y(:);
y = y(find(y~=0));
n = length(x);
m = length(y);
mP = ceil((m*n+1)/2);
P = zeros(mP,n+1);
P(1,:) = P(1,:) + 1;
for i=1:m
   for j = 1:n
      P(:,j+1) = (P(:,j+1)*i + [zeros(min(i,mP),1); P(1:mP-i,j)]*j)/(i+j);
   end
end

P = P(:,n+1);

% --- count number of y's less than x's ---

[z, I] = sort([x;y]);
R = 1:m+n;
r = sum(R(find(I<=n)));
ranksum = r;

% --- and the propability under the null hypothesis of that 
%     outome or worse is ... 

r = r - n*(n+1)/2;
r = min(r,m*n-r);
pval = min(2*sum(P(1:r+1)),1);
