function [a]=Ainv(y)
%
%  [a]=Ainv(y)
[rx,cx]=size(y);
%found='n';
% for i=1:1000
%  if (A(i/20)>x)
%    if (found(1)=='n')
%      a=i/20;
%      found='j';
%    end
%  end
%  if (found=='n')
%    a=1000/20;
%  end
% end
x=abs(y);
%%e=[1:1000]; t=ones(cx,1)*A(e/20)>x'*ones(1,1000);
%%s=sum(t'); a=abs(y).*(50.05-s/20)./y;
b=0*x;
%if A(b)<x
%for i=1:1000,
%  b=b+(A(b)<x)*0.01;
%end
%for i=1:10,
%  b=b+(A(b)>x)*0.01;
%end
 lambda=2.55;
for i=1:25,
  b=b+(x-A(b))*lambda;
end
a=b;
%end

