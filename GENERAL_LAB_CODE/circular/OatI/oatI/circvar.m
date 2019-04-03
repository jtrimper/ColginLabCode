function [s]=circvar(x)
%
% CALL: 
%
%     [s]=circvar(x)
%
%  where
%         x   = vector of directions (in degrees)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University. Sweden
  [rm cm]=size(x);
  Cc=0.0; Ss=0.0;  n=0;
  for i=1:rm,
    if (finite(x(i))),
      Cc=Cc+cos(pi*x(i)/180.0); Ss=Ss+sin(pi*x(i)/180.0);  
      n=n+1.0;
    end
  end;
  r=sqrt(Cc*Cc+Ss*Ss)/n;
  s=1-r;
%end
