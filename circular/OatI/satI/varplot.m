function varplot(X,xvar,yvar,var);
%
% CALL: varplot(xvar,yvar,var);
%
plot(X(:,varnrof(xvar,var)),X(:,varnrof(yvar,var)),'o')
end
