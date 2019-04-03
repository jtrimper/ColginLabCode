function [X,varnbrs]=ldmlvars(varnbrs);
%
% Gets the variables from interml.v??
%
% CALL: [X,S]=ldmlvars(varnbrs); 
%
% where
%
%     varnbrs = row vector of variable number to be loaded,
%     X       = matrix whose columns are the variables loaded,
%     S       = row vector of the variables loaded.     
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
X=[];
[ro,co]=size(varnbrs);
for i=1:co,
  if (varnbrs(i)==1),
    load interml.v1
    x=interml;
  elseif (varnbrs(i)==2),
    load interml.v2
    x=interml;
  elseif (varnbrs(i)==3),
    load interml.v3
    x=interml;
  elseif (varnbrs(i)==4),
    load interml.v4
    x=interml;
  elseif (varnbrs(i)==5),
    load interml.v5
    x=interml;
  elseif (varnbrs(i)==6),
    load interml.v6
    x=interml;
  elseif (varnbrs(i)==7),
    load interml.v7
    x=interml;
  elseif (varnbrs(i)==8),
    load interml.v8
    x=interml;
  elseif (varnbrs(i)==9),
    load interml.v9
    x=interml;
  elseif (varnbrs(i)==10),
    load interml.v10
    x=interml;
  elseif (varnbrs(i)==11),
    load interml.v11
    x=interml;
  elseif (varnbrs(i)==12),
    load interml.v12
    x=interml;
  elseif (varnbrs(i)==13),
    load interml.v13
    x=interml;
  elseif (varnbrs(i)==14),
    load interml.v14
    x=interml;
  elseif (varnbrs(i)==15),
    load interml.v15
    x=interml;
  elseif (varnbrs(i)==16),
    load interml.v16
    x=interml;
  elseif (varnbrs(i)==17),
    load interml.v17
    x=interml;
  elseif (varnbrs(i)==18),
    load interml.v18
    x=interml;
  elseif (varnbrs(i)==19),
    load interml.v19
    x=interml;
  elseif (varnbrs(i)==20),
    load interml.v20
    x=interml;
  elseif (varnbrs(i)==21),
    load interml.v21
    x=interml;
  elseif (varnbrs(i)==22),
    load interml.v22
    x=interml;
  elseif (varnbrs(i)==23),
    load interml.v23
    x=interml;
  else
    disp([' Not more than 23 variables at the moment!'])
  end
%b=varnbrs
%load b
%x8=interml
X=[X,x];
%load interml.v11
%x11=interml;
end
