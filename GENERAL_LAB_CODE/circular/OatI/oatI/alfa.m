function [p]=alfa(xpos,ypos,r,col)
%
% CALL: [p]=alfa(xpos,ypos,size) 
%
X=[1.00,0.98,0.95,0.90,0.85,0.80,0.74,0.68,0.62,0.56,0.47,0.39,0.35];
Y=[0.99,0.99,0.98,0.93,0.87,0.79,0.67,0.55,0.45,0.36,0.25,0.19,0.17];
X=[X,0.30,0.25,0.20,0.15,0.09,0.05,0.04];
Y=[Y,0.14,0.12,0.13,0.16,0.23,0.30,0.340];
X=[X,0.039,0.04,0.05,0.10,0.15,0.20,0.22,0.25,0.27,0.29,0.35];
Y=[Y,0.360,0.38,0.44,0.56,0.65,0.72,0.75,0.79,0.81,0.83,0.88];
X=[X,0.36,0.37,0.380,0.400,0.420,0.450];
Y=[Y,0.89,0.90,0.905,0.915,0.925,0.936];
X=[X,0.470,0.480,0.500,0.520,0.540,0.56,0.60,0.70,0.76];
Y=[Y,0.944,0.945,0.945,0.942,0.935,0.92,0.86,0.60,0.40];
X=[X,0.81,0.83,0.85,0.87,0.90,0.94,0.96,1.00];
Y=[Y,0.24,0.20,0.18,0.16,0.15,0.16,0.17,0.20];
Y=Y-0.1;
if nargin>3, c=col; end
p=plot(xpos+r*X,ypos+r*Y,c);
%axis([-1.5 1.5 -1.25 1.25])
%end
