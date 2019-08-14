function [post,posx,posy] = loadPos_rescaled_cz(file,scalex,scaley,vfs)
% file is the video file
% scale is the ratio that transfer the location from pixels to cm
% vfs is the sample frequency of video

fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0;  % Targets
fieldSelection(6) = 0; % Points

% Do we return header 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatVT
extractMode = 1; % Extract all data
[t, x, y] = Nlx2MatVT(file,fieldSelection,extractHeader,extractMode);

%tracklength = 193; %track length in cm
% scale = 0.275;% Conversion from pixels to cm, frame is 640 by 480
x = x * scalex; % == transfer to cm ==
y = y * scaley;
t = t ./ 1000000;

%Clear zero values and rescale the positions onto a -50:50 cm square grid NOTE: this assumes that the rat reached each wall at least once
xx= x((y>0 & x>0)==1 & ~isnan(x));
yy= y((y>0 & x>0)==1 & ~isnan(x));
tt = t((y>0 & x>0)==1 & ~isnan(x));

% Create backup structures in case too much interpolation is required
bak_x=x;
bak_y=y;
bak_t=t;
bak_x((y>0 & x>0)==1 & ~isnan(x)) = xx;
bak_y((y>0 & x>0)==1 & ~isnan(x)) = yy;
bax_x(x==0)=nan;
bak_y(y==0)=nan;
bak_t(x==0)=nan;
bak_t(y==0)=nan;

%find and report the largest missing chunk of time:
fprintf('\nLargest time chunk missing: %3.4f\n',max(diff(tt-t(1))));


%Fill in the gaps that the camera missed by linear interpolation
posx=interp1(tt,xx,t,'linear');
posy=interp1(tt,yy,t,'linear');
%rescale time such that t0=0
post=t;
	
% Treshold for how far a rat can move (100cm/s), in one sample (sampFreq =
% 30 Hz)
threshold = 120/vfs;
[posx0,posy0] = removeBadTracking_cz(posx,posy,threshold);
%Clear zero values and rescale the positions onto a -50:50 cm square grid NOTE: this assumes that the rat reached each wall at least once
xx= posx0((posy0>0 & posx0>0)==1 & ~isnan(posx0));
yy= posy0((posy0>0 & posx0>0)==1 & ~isnan(posx0));
tt = t((posy0>0 & posx0>0)==1 & ~isnan(posx0));

%Fill in the gaps that the camera missed by linear interpolation
posx=interp1(tt,xx,t,'linear');
posy=interp1(tt,yy,t,'linear');
%rescale time such that t0=0


% Moving window mean filter
for cc = 8:length(posx)-7
	posx(cc) = nanmean(posx(cc-7:cc+7));   
	posy(cc) = nanmean(posy(cc-7:cc+7));
end



% Removes position "jumps", i.e position samples that imply that the rat is
% moving quicker than physical possible. Samples in the "jump" parts are
% set to NaN
%
% (c) Raymond Skjerpeng, 2008.
function [x,y] = removeBadTracking_cz(x,y,threshold)

% Indexes to position samples that are to be removed
remInd = [];

diffX = diff(x);
diffY = diff(y);
diffR = sqrt(diffX.^2 + diffY.^2);
ind = find(diffR > threshold);
if isempty(ind)
    return
end

if ind(end) == length(x)
    offset = 2;
else
    offset = 1;
end

for ii = 1:length(ind)-offset
    if ind(ii+1) == ind(ii)+1
        % A single sample position jump, tracker jumps out one sample and
        % then jumps back to path on the next sample. Remove bad sample.
        remInd = [remInd; ind(ii)+1];
        ii = ii+1;
        continue
    else
        % Not a single jump. 2 possibilities:
        % 1. Tracker jumps out, and stay out at the same place for several
        % samples and then jumps back.
        % 2. Tracker just has a small jump before path continues as normal,
        % unknown reason for this. In latter case the samples are left
        % untouched.
        
        idx = find(x(ind(ii)+1:ind(ii+1))==x(ind(ii)+1));
        if length(idx) == length(x(ind(ii)+1:ind(ii+1)));
            remInd = [remInd; (ind(ii)+1:ind(ii+1))'];
        end
    end
end
% Remove the samples
x(remInd) = 0;
y(remInd) = 0;
