function csat
% Selects between different types of circular analysis
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.

f1=figure('NumberTitle','off','Name','Circular Analysis','Pointer','crosshair');
g1=uimenu('Label','Platform','Position',1);
uimenu(g1,'Label','Circular Plot','Callback','circlesh','Position',1);
%'circle(M,''degrees'')','Position',1);
uimenu(g1,'Label','Orientogram','Callback','orient','Position',2);
%uimenu(g1,'Label','ANOVA','Callback','ANOVA','Position',3);
%uimenu(g1,'Label','Quit','Callback','quit','Position',4);







