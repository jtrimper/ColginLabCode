X=[];
loaded=[];
[X,loaded]=chkld([3,10:15,18],X,loaded);
[rx,cx]=size(X);
sample=[1,rx]';
%[R,N]=sect2rk(X(:,vnrld([12:19],loaded)),(1+0*[1:rx])'*([0:7]*360/8)+X(:,vnrld(11,loaded))*([0:7]*0+1)); 
%[R,N]=sect2rk(X(:,vnrld([12:19],loaded)),X(:,2)*[1,1,1,1,1,1,1,1]); 
