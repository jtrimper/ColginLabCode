function scplmat(X)
%
%
%
[n,p]=size(X);
%subplot(p,p,1)
for i=1:p,
  for j=1:p,
   x=X(:,j);
   y=X(:,i);
   if (i>j)|(i<j),
     subplot(p,p,(i-1)*p+j)
     plot(x,y,'o')
   end
  end
end
