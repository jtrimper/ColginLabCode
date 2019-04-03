hastvar=input('Wind speed variable: '); 
dirvar=input('Wind direction variable: '); 
[vind,hast]=vectmean(X(sample,vnrld([hastvar,dirvar],loaded)));
vindrikt(vind+180,hast);

