function [I,comp,comprass,nn]=ajneAn(M)
%
% CALL: 
%
%     [A]=ajneAn(x)
%
%  where
%         x    = column vector of directions (in degrees)
%

% Copyright 1995, Björn Holmquist, Dept of Math. Stat., Lund University.
[rm cm]=size(M);
for k=1:cm,
j=0;
for i=1:rm,
  if (finite(M(i,k))),
     j=j+1;
     x(j)=M(i,k)*pi/180;;
  end
end; % for i
n=length(x); b=0; rass=0;
nn(k)=n;
%x=sort(x);
for j=2:n,
  for i=1:j-1,
    b=b+min(x(j)-x(i),2*pi-x(j)+x(i)); % Mardia korrigerad
    rass=rass+pi-abs(pi-abs(x(j)-x(i))); % Hermanns and Rasson, 1985
  end % for i
end % for j
comprass(k)=n*pi/2-2*rass/n;
comp(k)=n*pi/2-2*b/n;
%I(k)=0; delta=0.2;
%for j=delta:delta:360
% I(k)=I(k)+(N(x,pi*j/180)-n/2)^2*(2*pi)*delta/360;
%end
I(k)=n*comprass(k);
end % for k
%end fcn


