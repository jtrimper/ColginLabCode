function v = speed2D(x,y,t)

N = length(x);
v = zeros(N,1);

for ii = 2:N-1
    v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
end
v(1) = v(2);
v(end) = v(end-1);