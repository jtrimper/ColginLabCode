function [Pr]=hyp(k,g,n,N)
%
% CALL: [Pr]=hyp(k,g,n,N) 
%
%
h=1;
if (k<=g),
  for i=0:n-k-1,
    h=h*(N-g-i)/(N-i);
    h=h*(n-i)/(n-k-i);
  end
  for i=0:k-1,
    h=h*(g-i)/(N-n+k-i);
  end
  Pr=h;
else
  Pr=0;
end
end
