function p=gausspolarpdf(a,phi,l1,l2)
p=(2*pi*(((sin(a-phi)).^2)*sqrt(l1/l2)+((cos(a-phi)).^2)*sqrt(l2/l1))).^-1;
