function [rho] = corr_EH(x,y)

 if size(x,2) ~= size(y,2)
     error('the size of two vectors has to be equal')
 
 elseif size(x,2) == size(y,2)

     xy = x.*y;
     sx = sum(x);
     sx2 = sum(x.^2);
     sy = sum(y);
     sy2 = sum(y.^2);
     
    rho=(size(x,2)*xy-sx*sy)...
        ./sqrt(size(x,2)*sx2-sx.^2)./sqrt(size(x,2)*sy2-sy.^2);
    
 end

end