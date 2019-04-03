function P=permmat(d)
%
%
l=length(d);
P=zeros(l,l);
for i=1:l
  P(i,d(i))=1;
end
end
