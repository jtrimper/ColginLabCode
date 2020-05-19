function [gridsize, orientations] = THorientation_size(Map, thresholdValue, saveName)
% function [gridsize, orientations] = THorientation_size(Map, thresholdValue, saveName)
%
%THorientation_size locates the centre and surrounding six grid nodes in
%grid cell autocorrelograms and then draws a line between the three
%opposing node pairs
%
%T&H 02.04.09
%
%Input 'Map' is the autocorrelogram (Rxy)
%Beware: you may need to tweak threshold value in line 16 to find correct
%fields when grid is messy. Only use good grids, however...

%Convert NaNs in Map to 0 for time being to allow below computations
Mapnan = isnan(Map);
Map(Mapnan) = 0;

threshold = (thresholdValue * (std2(Map)));

%Find local maxima from fields of > mean + (chosen) sd of rate map or autocorrelation
Maptest = Map > (mean2(Map)+ threshold);
[indx,indy] = find (imregionalmax(Map.*Maptest) == 1);


%Restore NaNs in Map
Map(Mapnan) = NaN;


%Find maximum closest to center of box
[a, indcentrx] = min(abs(indx - (size(Map,2)/2)));
[b, indcentry] = min(abs(indy - (size(Map,1)/2)));



%Get hypothenuses from all points around centre point
N = length(indx);

if N < 7
    disp('To few peaks to do the orientation analysis')
    gridsize = NaN;
    orientations = NaN;
    return
end

h = zeros(N,1);
for i = 1:N
    h(i) = sqrt(abs((indx(i)-(size(Map,2)/2))^2+(indy(i)-(size(Map,2)/2))^2));
end

%Located six nodes closest to center node
[a, points] = sort(h);
points = points(1:7);



%------ Figure out pairs of surrounding points that go together for grid node lines

%make list of point values from center
relpoints = [indx(points)-indx(points(1)) indy(points)-indy(points(1))];

%The six points relative location from the center point
relpoints = relpoints(2:7,:);

%Create prediction points for node pairs
oppoints = (relpoints.*-1);


%get grid(line) size
gridsize = zeros(6,1);
for i = 1:6
    gridsize(i) = sqrt(relpoints(i,1)^2 + relpoints(i,2)^2);
end
gridsize = mean(gridsize);


%------ Find maxima opposite from center for each point
%Find nodes matching prediction points best
pairs = zeros(6,6,size(relpoints,2));
for j = 1:6
    for i = 1:6
        pairs(j,i,:) = oppoints(j,:)-relpoints(i,:);
    end
end



%Indices of the closest matching actual points in the 'points' vector
indpair = zeros(6, size(pairs,3));
for i = 1:6
    [nons, indpair(i,:)] = min(sum(abs(pairs(:,i,:)),2));
end
indpair = indpair(:,1);


% To get the degree values for the three main vertices of the grid
deg = zeros(6,1);
for i = 1:6
    deg(i) = atand((relpoints(i,1))/(relpoints(i,2)));
end

orientations = sort(deg);
orientations = orientations([1 3 5]);

% 
% keyboard
% 
% 	ffb=figure(12);
% 	hold off
% 	imagesc(Map)
% 	hold on
% 
% 
% % 	Plot all local maxima in the Map which exceed 2SD
% 	plot (indy,indx,'xk','markersize',10,'linewidth',1)
% 
% % 	Plot the six grid nodes surrounding the center
% 	for i = 1:7
% 		plot (indy(points(i)),indx(points(i)),'xw','markersize',12,'linewidth',2)
% 	end
% 
% % 	Plot the grid centre-crossing lines
% 	for i = 1:6
% 		plot([indy(points(indpair(i)+1)) indy(points(indpair(indpair(i))+1))],[indx(points(indpair(i)+1)) indx(points(indpair(indpair(i))+1))],'color',[0,0,0],'linewidth',5)
% 	end
% 	axis square;
% 	hold off
% 	fName = sprintf('%s%s',saveName,'_gridOrientations');
% 	saveas(ffb,fName,'png');
% 	saveas(ffb,fName,'epsc');
% 	imageStore(figure(12),imageFormat,fName,300);
