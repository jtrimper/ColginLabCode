function [Fx]=ecdf(x,sample)
%
% CALL: [Fx]=ecdf(x,sample)
%
n=length(sample);
[rx,cx]=size(x);
[Fn,IFn]=fnifn(sample);
for j1=1:rx,
for j2=1:cx,
  Fx(j1,j2)=0.0;
  for i=1:n,
    if x(j1,j2)>IFn(i), 
      Fx(j1,j2)=Fn(i);
    end
  end
end
end
end
