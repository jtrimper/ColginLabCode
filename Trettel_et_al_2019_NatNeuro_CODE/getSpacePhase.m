function [spacephi_x, spacephi_y] = getSpacePhase(space_x_corr)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  getSpacePhase -- Gets the X and Y relative spatial phase from a pair of grid cells.
	%
	%	INPUTS:
	%		-- space_x_corr: the spatial cross-correlation map between the cell pairs
	%
	%
	%	OUTPUTS:
	%		-- spacephi_x: the relative spatial phase in the X direction, scaled from [0,1]
	%		-- spacephi_y: the relative spatial phase in the Y direction, scaled from [0,1]
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Get the size of the spatial cross-correlation map
	[height,width] = size(space_x_corr);

	%Get the X and Y coordinates for the center coordinate, with checks for even vs. odd numbers of bins
	if mod(width,2)==1
		centerx=(width-1)/2;
	else
		centerx = width/2;
	end
	if mod(height,2)==1
		centery=(height-1)/2;
	else
		centery = height/2;
	end

	% Get the peaks in the cross-correlation map
	[pts] = getPeaks(space_x_corr);
	% If there are no peaks, return NAN
	if(isempty(pts))
		spacephi_x=nan;
		spacephi_y=nan;
		return;
	end
	
	%Find the distance from center for all peaks
	pts(:,1)=pts(:,1)-centery;
	pts(:,2)=pts(:,2)-centerx;
	distvec = sqrt( (pts(:,1)).^2 + pts(:,2).^2);
	
	% Find the index and value of the minimum distance peak
	[v ind] = nanmin(distvec);
	
	%Find the next-closest peak by duplicating the distance vector and setting the closest to NAN
	temp_distvec=distvec;
	temp_distvec(ind) = nan;
	[v,ind2] = nanmin(temp_distvec);
	
	% Calculate the distance between the two closest peaks, assign that as the spatial period
	dist = (sqrt( nansum([(pts(ind2,1)-pts(ind,1))^2, (pts(ind2,2) - pts(ind,2))^2])));
	
	% Normalize the relative spatial phase in the X and Y directions by the spatial period
	spacephi_x = mod(pts(ind,1)/ dist,1);
	spacephi_y = mod(pts(ind,2)/dist,1);

%% Dori's method for finding the peaks in an autocorrelation map
%Sean's note:  These comments are my understanding of this code, I did not write this
function max_points = getPeaks(aCorrMap)

	% Set up difference matrices
	diff_x_1 = zeros(size(aCorrMap));
	diff_x_2 = zeros(size(aCorrMap));
	diff_y_1 = zeros(size(aCorrMap));
	diff_y_2 = zeros(size(aCorrMap));

	% 1st order diff in the x direction
	diff_x = diff(aCorrMap,1,2);
	% 1st order diff in the y direction
	diff_y = diff(aCorrMap,1,1);

	% Rectify, such that diff_x & diff_y only contain (-1,0,1).  Sign of difference remains, magnitude removed
	diff_x(diff_x > 0) = 1;
	diff_x(diff_x < 0) = -1;
	diff_y(diff_y > 0) = 1;
	diff_y(diff_y < 0) = -1;

	%Align difference matrices so the maxima can be computed
	diff_x_1(:,1:end-1) = diff_x;
	diff_x_2(:,2:end) = diff_x;
	diff_y_1(1:end-1,:) = diff_y;
	diff_y_2(2:end,:) = diff_y;

	%Find the positive-to-negative inflection points of the difference maps
	zero_x = abs(diff_x_2 - diff_x_1) == 2;
	zero_y = abs(diff_y_2 - diff_y_1) == 2;

	%The local maxima are points where X and Y inflections overlap
	local_max = zero_x & zero_y;

	% Check each of the local maxima, ensuring that there are no points of greater magnitude adjacent to them
	max_points = [];
	cnt = 0;
	for x = 2:size(local_max,2)-1
		for y = 2:size(local_max,1)-1
			if local_max(y,x) == 1 && ...
					aCorrMap(y,x) > aCorrMap(y,x-1) && ...
					aCorrMap(y,x) > aCorrMap(y,x+1) && ...
					aCorrMap(y,x) > aCorrMap(y-1,x) && ...
					aCorrMap(y,x) > aCorrMap(y+1,x-1)
				cnt = cnt + 1;
				max_points(cnt,:) = [x y];
			end
		end
	end
	%Count the number of accepted maxima
	nmaxpoints = size(max_points,1);



	% delete maximum points which are close to each other 
	% (defined as follows: a line between the points goes 
	%  through points whos value is above 0.2 of the value 
	%  of the maximal point)
	thresh = 0.75;
	good_max = ones(nmaxpoints,1);
	for i = 1:nmaxpoints
		for j = i+1:nmaxpoints
			val1 = aCorrMap(max_points(i,2),max_points(i,1));
			x1 = max_points(i,1);
			y1 = max_points(i,2);
			val2 = aCorrMap(max_points(j,2),max_points(j,1));
			x2 = max_points(j,1);
			y2 = max_points(j,2);
			% line([x1 x2],[y1 y2]);
			if abs(x2-x1) >= abs(y2-y1)
				if x2 >= x1
					x_line = x1:x2;
				else 
					x_line = x2:x1;
				end
				y_line = round(interp1([x1 x2],[y1 y2],x_line));
			else
				if y2 >= y1
					y_line = y1:y2;
				else
					y_line = y2:y1;
				end
				x_line = round(interp1([y1 y2],[x1 x2],y_line));
			end
			y_line(y_line < 1) = 1; x_line(x_line < 1) = 1;
			y_line(y_line > size(aCorrMap,1)) = size(aCorrMap,1);
			x_line(x_line > size(aCorrMap,1)) = size(aCorrMap,1);
			
			vals = diag(aCorrMap(y_line,x_line));
			
			if val2 >= val1
				if all(vals/val2 > thresh) % delete  one point
					good_max(i) = 0;
				end
			else
				if all(vals/val1 > thresh)
					good_max(j) = 0;
				end
			end
		end % j-th maxmimum
	end % i-th maximum

	% Remove the deleted maxima
	max_points(~good_max,:) = []; 
