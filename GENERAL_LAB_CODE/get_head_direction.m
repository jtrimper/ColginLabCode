function HD = get_head_direction(posFile)
% function HD = get_head_direction(posFile)
%
% PURPOSE:
%  To calculate rat's head direction based on the LED coordinates
%
% INPUT:
%  posFile = path to the *.nvt file
%
% OUTPUT:
%  HD = nx2 matrix of head direction in degrees (:,2) and time in seconds (:,1)
%
%
% JBT 7/19/17*
% Colgin Lab
%
% *This is really just Raymond Skjerpeng's code (NlxHeadDir1_4) written without all the
%  spiking stuff or the subfunctions.



checkHD = 0; %set to 1 to check head direction estimates for random frames
%            NOTE: Function will have to be cancelled to get this plotting to stop


%% PARAMETERS
timeThreshold = 1.5; %s -- max time allowable for missing coordinates
sampRate = 30;


%% READ IN THE VIDEO DATA
fieldSelect = [1,0,0,0,1,0]; %Want timestamps and targets
getHeader = 0; %Get header
extractMode = 1; %Extract every record

[t,targets] = Nlx2MatVT(posFile,fieldSelect,getHeader,extractMode); %Get the data

% Convert timestamps to seconds
t = t/1000000;


%% DECODE THE TARGET DATA

numSamp = size(targets,2); %Number of samples

% Allocate memory to the array. 9 fields per sample: X-coord, Y-coord and
% 7 colour flag.
% Colour flag: 3=luminance, 4=rawRed, 5=rawGreen, 6=rawBlue, 7=pureRed,
% 8=pureGreen, 9=pureBlue.
dTargets = int16(zeros(numSamp,50,9));

for ii = 1:numSamp
    for jj = 1:50
        bitField = bitget(targets(jj,ii),1:32);
        if bitField(13)% Raw blue
            % Set the x-coord to the target
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            % Set the y-coord to the target
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,6) = 1;
        end
        if bitField(14) % Raw green
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,5) = 1;
        end
        if bitField(15) % Raw red
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,4) = 1;
        end
        if bitField(16) % Luminance
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,3) = 1;
        end
        if bitField(29) % Pure blue
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,9) = 1;
        end
        if bitField(30) % Puregreen
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,8) = 1;
        end
        if bitField(31) % Pure red
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,7) = 1;
        end
    end
end


% Find out what colours were used in the tracking
tracking = zeros(1,7);
if ~isempty(find(dTargets(:,:,3),1)) % Luminance
    tracking(1) = 1;
end
if ~isempty(find(dTargets(:,:,7),1)) % Pure Red
    tracking(2) = 1;
end
if ~isempty(find(dTargets(:,:,8),1)) % Pure Green
    tracking(3) = 1;
end
if ~isempty(find(dTargets(:,:,9),1)) % Pure Blue
    tracking(4) = 1;
end
if ~isempty(find(dTargets(:,:,4),1)) % Raw Red
    tracking(5) = 1;
end
if ~isempty(find(dTargets(:,:,5),1)) % Raw Green
    tracking(6) = 1;
end
if ~isempty(find(dTargets(:,:,6),1)) % Raw Blue
    tracking(7) = 1;
end




%% EXTRACT WHERE EACH TRACKING DIODE IS
%   Extracts the individual coordinates for the centre of mass of each
%   tracking diode. The red LEDs are assumed to be at the front and the green
%   diodes are assumed to be at the back.

frontX = 1; %tmp stand-in

ind = find(tracking(2:end));
if length(ind) <= 1
    % Need at least two colours to get head direction
    disp('ERROR: To few LED colours have been tracked. Not possible to find head direction')
    frontX = NaN;
    frontY = NaN;
    backX = NaN;
    backY = NaN;
else
    if ~tracking(2) && ~tracking(5)
        disp('ERROR: Red LED has not been tracked')
        frontX = NaN;
        frontY = NaN;
        backX = NaN;
        backY = NaN;
    end
    if ~tracking(3) && ~tracking(6)
        disp('ERROR: Green LED has not been tracked')
        frontX = NaN;
        frontY = NaN;
        backX = NaN;
        backY = NaN;
    end
end

if ~isnan(frontX)
    % Number of samples in the data
    numSamp = size(dTargets,1);
    
    % Allocate memory for the arrays
    frontX = zeros(1,numSamp);
    frontY = zeros(1,numSamp);
    backX = zeros(1,numSamp);
    backY = zeros(1,numSamp);
    
    % Exctract the front coordinates (red LED)
    if tracking(2) && ~tracking(5)
        % Pure red but not raw red
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,7));
            if ~isempty(ind)
                frontX(ii) = mean(dTargets(ii,ind,1));
                frontY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
    if ~tracking(2) && tracking(5)
        % Not pure red but raw red
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,4));
            if ~isempty(ind)
                frontX(ii) = mean(dTargets(ii,ind,1));
                frontY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
    if tracking(2) && tracking(5)
        % Both pure red and raw red
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,7) | dTargets(ii,:,4));
            if ~isempty(ind)
                frontX(ii) = mean(dTargets(ii,ind,1));
                frontY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
    
    % Exctract the back coordinates (green LED)
    if tracking(3) && ~tracking(6)
        % Pure green but not raw green
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,8));
            if ~isempty(ind)
                backX(ii) = mean(dTargets(ii,ind,1));
                backY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
    if ~tracking(3) && tracking(6)
        % Not pure green but raw green
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,5));
            if ~isempty(ind)
                backX(ii) = mean(dTargets(ii,ind,1));
                backY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
    if tracking(3) && tracking(6)
        % Both pure green and raw green
        for ii = 1:numSamp
            ind = find(dTargets(ii,:,8) | dTargets(ii,:,5));
            if ~isempty(ind)
                backX(ii) = mean(dTargets(ii,ind,1));
                backY(ii) = mean(dTargets(ii,ind,2));
            end
        end
    end
end



%% INTERPOLATE MISSING POSITION SAMPLES
sampThreshold = floor(timeThreshold * sampRate); % Number of samples that corresponds to the time Threshold.

for i = 1:2
    if i == 1
        x = frontX;
        y = frontY;
    else
        x = backX;
        y = backY;
    end
    
    % number of samples
    numSamp = length(x);
    % Find the indexes to the missing samples
    temp1 = 1./x;
    temp2 = 1./y;
    indt1 = isinf(temp1);
    indt2 = isinf(temp2);
    ind = indt1 .* indt2;
    ind2 = find(ind==1);
    % Number of missing samples
    N = length(ind2);
    
    if N ~= 0 %if samples ARE missing
        
        change = 0;
        
        % Remove NaN in the start of the path
        if ind2(1) == 1
            change = 1;
            count = 0;
            while 1
                count = count + 1;
                if ind(count)==0
                    break
                end
            end
            x(1:count) = x(count);
            y(1:count) = y(count);
        end
        
        % Remove NaN in the end of the path
        if ind2(end) == numSamp
            change = 1;
            count = length(x);
            while 1
                count = count - 1;
                if ind(count)==0
                    break
                end
            end
            x(count:numSamp) = x(count);
            y(count:numSamp) = y(count);
        end
        
        if change
            % Recalculate the missing samples
            temp1 = 1./x;
            temp2 = 1./y;
            indt1 = isinf(temp1);
            indt2 = isinf(temp2);
            % Missing samples are where both x and y are equal to zero
            ind = indt1 .* indt2;
            ind2 = find(ind==1);
            % Number of samples missing
            N = length(ind2);
        end
        
        ii = 1;
        while ii <= N
            
            start = ind2(ii); % Start of missing segment (may consist of only one sample)
            
            count = 0; % Find the number of samples missing in a row
            
            while 1 %FYI: This is the number, not lowercase L
                count = count + 1;
                if ind(start+count)==0
                    break
                end
            end
            
            stop = start+count; % Index to the next good sample
            if start == stop
                % Only one sample missing. Setting it to the last known good sample
                x(start) = x(start-1);
                y(start) = y(start-1);
            else
                if count < sampThreshold
                    
                    % Last good position before lack of tracking
                    x1 = x(start-1);
                    y1 = y(start-1);
                    
                    % Next good position after lack of tracking
                    x2 = x(stop);
                    y2 = y(stop);
                    
                    % Calculate the interpolated positions
                    X = interp1([1,2],[x1,x2],1:1/count:2);
                    Y = interp1([1,2],[y1,y2],1:1/count:2);
                    
                    % Switch the lacking positions with the estimated positions
                    x(start:stop) = X;
                    y(start:stop) = Y;
                    
                    
                    ii = ii+count; % Increment the counter (avoid estimating allready estimated samples)
                else
                    
                    ii = ii+count; % Too many samples missing in a row and they are left as missing
                end
            end
        end
        
        
        if i == 1
            frontX = x;
            frontY = y;
        else
            backX = x;
            backY = y;
        end
        
    end
end



%% SMOOTH THE EXTRACTED POSITION WITH A MOVING WINDOW MEAN FILTER

% Set missing samples to NaN. Necessary when using the mean filter.
indf = find(frontX==0);
frontX(indf) = NaN;
frontY(indf) = NaN;
indb = find(backX==0);
backX(indb) = NaN;
backY(indb) = NaN;


% Smooth samples with a mean filter over 15 samples
for cc = 8:length(frontX)-7
    frontX(cc) = nanmean(frontX(cc-7:cc+7));
    frontY(cc) = nanmean(frontY(cc-7:cc+7));
    backX(cc) = nanmean(backX(cc-7:cc+7));
    backY(cc) = nanmean(backY(cc-7:cc+7));
end


% Set the missing samples back to zero
frontX(indf) = 0;
frontY(indf) = 0;
backX(indb) = 0;
backY(indb) = 0;


% Calculate the head stage direction in degrees
HD(:,2) = headDirection(frontX,frontY,backX,backY);

% Concatenate the time-stamps onto that vector
HD(:,1) = t;

%% OPTIONAL PLOTTING
if checkHD == 1
    fprintf('\n\n\n\t\t\tNote that this head direction plotting loop will not stop until function is cancelled.\n\n\n\n');
    
    figure('Position', [ 7         528        1641         420])
    for a = 1:10000
        tmpInd = randi([1 length(HD)], 1); %pick a random idex
        
        
        %% PLOT THE RAT'S PATH FOR THE 20 FRAMES AROUND THE RANDO INDEX
        %   and mark the start with an asterisk
        subplot(1,2,1);
        hold on;
        ctrX = mean([frontX(tmpInd-10:tmpInd+10); backX(tmpInd-10:tmpInd+10)]);
        ctrY = mean([frontY(tmpInd-10:tmpInd+10); backY(tmpInd-10:tmpInd+10)]);
        plot(ctrX, ctrY, 'Color', [.5 .5 .5]);
        plot(ctrX(1), ctrY(1), '*k');
        
        %% FOR THE 5 FRAMES IN THE MIDDLE OF THIS CHUNK
        for i = 1:4
            
            %% CALCULATE THE CENTROID AND MARK WITH A # 1-5
            ctrX = mean([frontX(tmpInd+i-1) backX(tmpInd+i-1)]);
            ctrY = mean([frontY(tmpInd+i-1) backY(tmpInd+i-1)]);
            text(ctrX, ctrY, num2str(i), 'Color', [0 0 0]);
            
            %% MARK THE CALCULATED FRONT AND BACK OF THE HEADSTAGE WITH F & B
            text(frontX(tmpInd+i-1), frontY(tmpInd+i-1), 'F', 'Color', [0 1 0]);
            text(backX(tmpInd+i-1), backY(tmpInd+i-1), 'B', 'Color', [1 0 0]);
            
        end
        
        %% GET THE AXIS FIT AROUND THE PLOT
        xMin = min([frontX(tmpInd:tmpInd+4) backX(tmpInd:tmpInd+4)])-30;
        xMax = max([frontX(tmpInd:tmpInd+4) backX(tmpInd:tmpInd+4)])+30;
        yMin = min([frontY(tmpInd:tmpInd+4) backY(tmpInd:tmpInd+4)])-30;
        yMax = max([frontY(tmpInd:tmpInd+4) backY(tmpInd:tmpInd+4)])+30;
        axis([xMin xMax yMin yMax]);
        
        %% PLOT THE HEAD DIRECTION ANGLE FOR THE 5TH FRAME OF THE F/B FRAMES
        subplot(1,2,2);
        tmpHD = deg2rad(HD(tmpInd:tmpInd+4));
        polar([tmpHD(5) tmpHD(5)], [0 1]);
        
        pause
        clf
        
    end
end


end %function