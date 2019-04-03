function [z, u] = algorithm1(data)
%Mean vector z and covariance matrix u of (x, y)
%Algorithm 1, Fisher (1993), p. 210

x = cos(data);
y = sin(data);

n = max(size(data));

z1 = sum(x/n);
z2 = sum(y/n);
z = [z1; z2];

u11 = sum((x-z1).*(x-z1)/n);
u22 = sum((y-z2).*(y-z2)/n);

u12 = sum((x-z1).*(y-z2)/n);
u21 = u12;

u = [u11 u12;u21 u22];