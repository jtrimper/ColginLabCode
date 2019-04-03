X=[];
loaded=[];
[X,loaded]=chkld([1:23],X,loaded);
[rx,cx]=size(X);
sample=[1:rx]';
cage=[12:23];
[R,N,A1,A2,Ang]=sect2rk(X(:,vnrld(cage,loaded)),(1+0*[1:rx])'*([0:11]*360/12)+X(:,vnrld(11,loaded))*([0:11]*0+1)); 
M=Ang(:,1);
