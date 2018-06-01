function auc = findAuc(values)
%function auc = findAuc(values)
%
% DESCRIPTION:
%  - Designed similarly to JRM's 'return_theta_quart_auc'
%  - Modifications:
%      - Function is not specifically designed for theta quartile times
%          - Being written for use with percent of total gamma peaks in each theta quartile
%      - Function will not remove outliers
%  - Calls 'polygon_clipper' downloaded from Matlab File Exchange
%
% INPUT:
%   - 'values' is an m by n matrix of rats by quartile durations or proportions (immediately converted via cumsum so same result)
%
% OUTPUT:
%   - 'auc' is a vector containing the area under the curve for each row (rat)
%
% JBT 4/14/15

if size(values,2) ~= 4
    error ('Number of columns does not equal 4. Columns = quartiles, therefore size(values,2) must equal 4')
end

cum = cumsum(values,2);

for r = 1:size(cum,1)
 
    cumPerc = cum(r,:) ./ cum(r,4); 
    
    %polygon representing area (triangle) underneath unity line
    P1.x = [0 1 1 0];
    P1.y = [0 1 0 0];
    
    xvals = [0 .25 .5 .75 1 0];%0,0 is first and last point to close polygon
    yvals = [0 cumPerc 0];
    
    %use PolygonClip to find difference polygons (above diagonal) plus intersection polygons (below diagonal)
    P2.x = xvals;
    P2.y = yvals;
    
    DiffP = PolygonClip(P2,P1,0);
    IntP =  PolygonClip(P2,P1,1);
    
    DiffA = 0;
    IntA = 0;
    
    %polygons above diagonal
    for p = 1:length(DiffP)
        DiffA = DiffA + polyarea(DiffP(p).x, DiffP(p).y);
    end
    
    %polygons below diagonal
    for p = 1:length(IntP)
        IntA =  IntA + polyarea(IntP(p).x,  IntP(p).y);
    end
    
    %total off-diagonal area
    auc(r) = DiffA + IntA;
end