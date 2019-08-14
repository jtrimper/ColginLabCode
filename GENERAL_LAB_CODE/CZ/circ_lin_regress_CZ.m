function [para,z,p] = circ_lin_regress(x, pha, bound)

if nargin < 3
    bound = 2;
end

% convert degrees to rad
if max(abs(pha)) > 2*pi
    pha = pi*pha/180;
end

% a0 = fminsearch(@(a) dist(x,pha,a),a_threshold);  % slope
a0 = fminbnd(@(a) dist(x,pha,a),-bound,bound,optimset('Disp','off','TolX',1e-8));  % slope
% a0 = fminunc(@(a) dist(x,pha,a),a_threshold);
Y = sum(sin(pha-2*pi*a0*x));
X = sum(cos(pha-2*pi*a0*x));
pha0 = atan2(Y, X);
para = [a0, pha0];

% circular-linear correlation
z = correlation_cir_lin(x,pha,para);

% circular-linear correlation for shuffle data
% z_shuf = nan(1000,1);
% n = length(x);
% for rep = 1:1000
%     ind = randperm(n);
%     pha_shuf = pha(ind);
%     a0_shuf = fminbnd(@(a) dist(x,pha_shuf,a),-2,2);  % slope
%     Y = sum(sin(pha_shuf-2*pi*a0_shuf*x));
%     X = sum(cos(pha_shuf-2*pi*a0_shuf*x));
%     pha0_shuf = atan2(Y, X);
%     para_shuf = [a0_shuf, pha0_shuf];
%     z_shuf(rep) = correlation_cir_lin(x,pha_shuf,para_shuf);
% end

% p-val for the regression significance
p = 1-erf(abs(z)/sqrt(2));

function D = dist(x, pha, a)
Y = sum(sin(pha-2*pi*a*x));
X = sum(cos(pha-2*pi*a*x));
pha0 = atan2(Y, X);
pha0 = repmat(pha0,size(x,1),size(x,2));
mean0 = mean(cos(pha-2*pi*a*x-pha0));
D = 2*(1-mean0);


function z = correlation_cir_lin(x,pha,para)
a0 = para(1);
pha_fit = mod(2*pi*abs(a0)*x, 2*pi);
P1 = sum(sin(pha-circularStat(pha)).*sin(pha_fit-circularStat(pha_fit)));
P2 = sqrt( sum(sin(pha-circularStat(pha)).^2) * sum(sin(pha_fit-circularStat(pha_fit)).^2) );
P = P1/P2;

ii = 0; jj = 2;
lamda02 = mean( (sin(pha-circularStat(pha)).^ii) .* (sin(pha_fit-circularStat(pha_fit)).^jj) );
ii = 2; jj = 0;
lamda20 = mean( (sin(pha-circularStat(pha)).^ii) .* (sin(pha_fit-circularStat(pha_fit)).^jj) );
ii = 2; jj = 2;
lamda22 = mean( (sin(pha-circularStat(pha)).^ii) .* (sin(pha_fit-circularStat(pha_fit)).^jj) );

z = P* sqrt( length(x)*lamda02*lamda20/lamda22 );