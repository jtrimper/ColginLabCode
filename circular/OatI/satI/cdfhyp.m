function [F]=cdfhyp(x,g,n,N)
%
% CALL: [F]=cdfhyp(x,g,n,N)
%
%
f=0;
for i=0:n,
  if (i<=x),
    f=f+hyp(i,g,n,N);
  end
end
F=f;
end
