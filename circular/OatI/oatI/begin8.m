X=[];
loaded=[];
[X,loaded]=chkld([1:19],X,loaded);
[rx,cx]=size(X);
sample=[1:rx]';
cage=[12:19];
[R,N,A1,A2,Ang]=sect2rk(X(:,vnrld([12:19],loaded)),(1+0*[1:rx])'*([0:7]*360/8)+X(:,vnrld(11,loaded))*([0:7]*0+1)); 
M=Ang(:,1);
