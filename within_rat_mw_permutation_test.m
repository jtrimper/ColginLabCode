function [metric, T, F] = within_rat_mw_permutation_test(rat, params, movingwin, numRandos, numOrigIts)
% function [metric, T, F] = within_rat_line_permutation_test_v2(rat, params, movingwin, numRandos, numOrigIts)
%
%
% like within_rat_line_permutation_test but for time x frequency
%
%JBT 10/10/15


numRats = 6;
fprintf ('NOTE: Function assumes 6 rats and 4 subregions for each\n');
combos = [1 2; 2 3; 3 4]; %only gonna do the direct connection interactions
numSD = 1;
min_clust_len = 8; %minimum cluster length (in # of points)
alpha = .05; %alpha level to check against (NOTE: if numTapers = 2, make sure alpha reflects two comparisons)

%suppress warning messages from 'nchoosek'
id = 'MATLAB:nchoosek:LargeCoefficient';
warning('off', id);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        GET THE LOWEST NUMBER OF SWEEPS ACROSS ALL CONDITIONS, ALL RATS         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for r = 1:6
    for c = 1:2
        if r == 1 && c == 1
            minNumSwps = size(rat(r).condn(c).eegData,2);
        end
        
        if size(rat(r).condn(c).eegData,2) < minNumSwps
            minNumSwps = size(rat(r).condn(c).eegData,2);
        end
    end
end
fprintf ('\n\nLOWEST NUMBER OF SWEEPS IS %d.\n   ...subsampling all data down to %d sweeps\n\n', minNumSwps, minNumSwps);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                CALCULATE THE T x F POWER FOR EACH SWEEP                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n\nCalculating spectrum and cross spectrum:\n');
params.trialave = 0;
for r = 1:numRats
    % for r = 1
    fprintf ('   Rat %d\n', r);
    for c = 1:2
        for p = 1:3
            reg1 = combos(p,1);par
            reg2 = combos(p,2);
            
            [~,~,tmpS12, tmpS1, tmpS2, T, F] = cohgramc (rat(r).condn(c).eegData(:,:,reg1), rat(r).condn(c).eegData(:,:,reg2), movingwin, params); %output is time x freq x trials
            
            rat(r).condn(c).S12(:,:,:,p) = tmpS12;
            if p == 1
                rat(r).condn(c).S(:,:,:,reg1) = tmpS1;
                rat(r).condn(c).S(:,:,:,reg2) = tmpS2;
            elseif p == 3
                rat(r).condn(c).S(:,:,:,reg1) = tmpS1;
                rat(r).condn(c).S(:,:,:,reg2) = tmpS2;
            end
        end
    end
end
fprintf ('\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     FIRST GO THROUGH AND GET ALL SPECTRAL ESTIMATES FROM THE ORIGINAL DATA     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n\nGETTING SPECTRAL ESTIMATES FOR THE ORIGINAL DATA...\n');
for r = 1:numRats;
    % for r = 1
    fprintf (' Rat: %d\n', r);
    
    clear tmpCondn & tmpEegData %clear the tmpCondn & tmpEegData variables -- very important
    
    numSwps = [ size(rat(r).condn(1).eegData,2) size(rat(r).condn(2).eegData,2)];
    fprintf ('   Number of swps per condition:\n      Cond1: %d\n      Cond2: %d\n\n', numSwps);
    
    %when getting stats from the original data, we're gonna take it one condition at a time
    for c = 1:2
        fprintf ('            Condn: %d\n', c);
        if numSwps(c) == minNumSwps; %if we're on a/the condition where the number of sweeps equals the minimum number across all rats
            numIts = 1;%only do one iteration
            tmpInds = 1:numSwps(c); %and use all of the sweeps
            fprintf ('              No subsampling necessary for estimating stats for original data; current numSwps equals minNumSwps.\n') %going to use all of the trials each time since trial nums are equal
            
        else%if the number of sweeps in this condition is not equal to minimum number across all rats...
            
            fprintf ('              Subsampling %d sweeps down to %d sweeps for estimating stats for original data\n', numSwps(c), minNumSwps);
            
            maxPossibleIts = nchoosek(numSwps(c), minNumSwps);
            if maxPossibleIts < numOrigIts
                fprintf ('                - Can not do %d (numOrigIts) subsampling iterations through original data because max number of unique shuffles is %d\n\n', numOrigIts, maxPossibleIts);
                numIts = maxPossibleIts;
            else
                fprintf('                - Doing %d (numOrigIts) subsampling iterations through original data\n\n', numOrigIts);
                numIts = numOrigIts;
            end
            
            %figure out which trials to use for each subsampling iteration
            biggerNumInds = 1:numSwps(c);%create indices for 1:the current number of sweeps (which is also the bigger number of sweeps)
            mixer = zeros(1,numSwps(c));%create a vector of all zeros that is the same length
            mixer(1:minNumSwps) = 1;%add 'ones' to that for each of the minimum number of sweeps
            
            tmpInds = [];%create a variable to hold the different shuffle indices
            while size(tmpInds,1) < numIts%while the number of unique shuffles is less than the desired amount
                mixer = mixer(randperm(length(mixer)));%keep reshuffling the zeros & ones
                tmpInds = [tmpInds; biggerNumInds(mixer==1)]; %#ok - and use the zeros & ones as indices to select a random subset of the original set of indices
                tmpInds = unique(tmpInds, 'rows');%keep this shuffle only if it's a unique shuffle
            end
        end
        
        
        fprintf ('                  Iteration #: ')
        for i = 1:numIts;
            
            %print iteration number in a manageable way
            if i == 1, fprintf ('1');
            elseif (i > 1) && (mod(i,100) == 1); fprintf ('\n                             '); end
            if (i > 1) && (mod(i,100)~=1) && (mod(i,10) == 0), fprintf (',  %d', i); elseif i>1 && (mod(i,100) == 1), fprintf ('%d',i); end
            if i == numIts; fprintf ('\n'); end
            
            for p = 1:3;
                reg1 = combos(p,1);
                reg2 = combos(p,2);
                
                %get the spectrum values calculated earlier
                S1 = rat(r).condn(c).S(:,:,tmpInds(i,:),reg1);
                S2 = rat(r).condn(c).S(:,:,tmpInds(i,:),reg2);
                S12 = rat(r).condn(c).S12(:,:,tmpInds(i,:),p);
                
                %average spectra and phase coherence across trials
                S1 = squeeze(mean(S1,3));
                S2 = squeeze(mean(S2,3));
                S12 = squeeze(mean(S12,3));
                
                %calculate coherence
                C12 = S12./sqrt(S1.*S2); %coherencY
                C = abs(C12); %coherence
                
                %fisher transform coherence, log transform/convert to decibels power
                S1 = 10 * log10(abs(S1));
                S2 = 10 * log10(abs(S2));
                S12 = 10 * log10(abs(S12));
                C = atanh(C);
                
                %store the spectral metric values
                tmpCondn(c).metric(1).values(:,:,p,i) = C;%#ok
                tmpCondn(c).metric(2).values(:,:,p,i) = S12;%#ok
                tmpCondn(c).metric(3).values(:,:,p,i) = S1;%#ok
                tmpCondn(c).metric(4).values(:,:,p,i) = S2; %#ok
                
            end%combos
        end%iterations
        
        %AVERAGE ACROSS ALL THE SHUFFLE ITERATIONS FOR EACH TAPER
        for m = 1:4
            metric(m).values(:,:,r,:,c) = squeeze(mean(tmpCondn(c).metric(m).values,4));%#ok
        end
        
    end%conditions
end%rat



%CALCULATE THE DIFFERENCE BETWEEN VALUES FOR EACH CONDITION
for m = 1:4
    
    metric(m).AVG = squeeze(mean(metric(m).values,3));
    metric(m).SEM = squeeze(semfunct(metric(m).values,3));
    
    metric(m).difVals = metric(m).values(:,:,:,:,1) - metric(m).values(:,:,:,:,2); %output = time x freq x rat x combo
    metric(m).difAVG = squeeze(mean(metric(m).difVals,3)); %output = time x freq x combo
    metric(m).difSEM = squeeze(semfunct(metric(m).difVals,3));
    for p = 1:3
        tmp = metric(m).difAVG(:,:,p);
        metric(m).cluster_thresh(p) = std(abs(tmp(:))) * numSD; %numSD standard deviations from average metric magnitude > or < zero for each combo
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     THEN GO THROUGH AGAIN, RANDOMIZING THE DATA WITHIN EACH RAT     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n\nGETTING SPECTRAL ESTIMATES FOR THE RANDOMIZED DATA...\n');
for r = 1:numRats
    fprintf (' Rat %d\n', r);
    
    numSwps = [ size(rat(r).condn(1).eegData,2) size(rat(r).condn(2).eegData,2)];
    fprintf ('   Number of swps per condition:\n      Cond1: %d\n      Cond2: %d\n\n', numSwps);
    
    for c = 1:2
        if numSwps(c) ~= minNumSwps %if the number of sweeps for each condition is not equal to minNumSwps, going to have to subsample it down for every randomization
            biggerNumInds = 1:numSwps(c); %create indices for 1:the current number of sweeps
            mixer = zeros(1,numSwps(c)); %create a vector of all zeros that is the same length
            mixer(1:minNumSwps) = 1; %add a 'ones' to that for each of the minNumSwps
            
            condn(c).tmpInds = []; %#ok -- create a variable to hold the different shuffle indices
            for i = 1:numRandos%for each of the desired number of random iterations
                mixer = mixer(randperm(length(mixer)));%keep reshuffling the zeros & ones
                condn(c).tmpInds(i,:) = biggerNumInds(mixer==1);%and use the zeros & ones as indices to select a random subset of the original set of indices
            end
        end
    end
    
    fprintf ('               Iteration #: ')
    for i = 1:numRandos
        
        %print iteration number in a manageable way
        if i == 1, fprintf ('1');
        elseif (i > 1) && (mod(i,100) == 1); fprintf ('\n                             '); end
        if (i > 1) && (mod(i,100)~=1) && (mod(i,10) == 0), fprintf (',  %d', i); elseif i>1 && (mod(i,100) == 1), fprintf ('%d',i); end
        if i == numRandos; fprintf ('\n'); end
        
        for c = 1:2
            if numSwps(c) == minNumSwps; %if we're on a/the condition with the smaller number of sweeps, use all of the sweeps for every iteration
                condn(c).S12 = rat(r).condn(c).S12;
                condn(c).S = rat(r).condn(c).S;
            else
                condn(c).S12 = rat(r).condn(c).S12(:,:,condn(c).tmpInds(i,:),:); %else, get the pre-selected random sweeps for this iteration
                condn(c).S = rat(r).condn(c).S(:,:,condn(c).tmpInds(i,:),:);
            end
        end
        
        S12bucket = cat(3,condn(1).S12, condn(2).S12);%put all of the spectral power data into a bucket
        Sbucket = cat(3,condn(1).S, condn(2).S);
        
        newOrder = randperm(size(S12bucket,3)); %new order of trials
        S12bucket = S12bucket(:,:,newOrder,:);%mix up the bucket
        Sbucket = Sbucket(:,:,newOrder,:);
        
        rCond(1).S12 = S12bucket(:,:,1:minNumSwps,:); %pull first minNumSwps of the sweeps out of the bucket and call them condition 1
        rCond(1).S = Sbucket(:,:,1:minNumSwps,:);
        
        rCond(2).S12 = S12bucket(:,:,minNumSwps+1:end,:); %call the rest condition 2
        rCond(2).S = Sbucket(:,:,minNumSwps+1:end,:);
        
        
        
        for p = 1:3%for each combination of subregions
            reg1 = combos(p,1);
            reg2 = combos(p,2);
            
            for rc = 1:2%condition
                
                %get pre-calculated spectra
                S1 = rCond(rc).S(:,:,:,reg1);
                S2 = rCond(rc).S(:,:,:,reg2);
                S12 = rCond(rc).S12(:,:,:,p);
                
                %average spectra and phase coherence across trials
                S1 = squeeze(mean(S1,3));
                S2 = squeeze(mean(S2,3));
                S12 = squeeze(mean(S12,3));
                
                %calculate coherence
                C12 = S12./sqrt(S1.*S2); %coherencY
                C = abs(C12); %coherence
                
                %fisher transform coherence, log transform/convert to decibels power
                S1 = 10 * log10(abs(S1));
                S2 = 10 * log10(abs(S2));
                S12 = 10 * log10(abs(S12));
                C = atanh(C);
                
                %save for later
                rCond(rc).metric(1).values(:,:,p,i,r) = C;
                rCond(rc).metric(2).values(:,:,p,i,r) = S12;
                rCond(rc).metric(3).values(:,:,p,i,r) = S1;
                rCond(rc).metric(4).values(:,:,p,i,r) = S2;
                
            end%condition(random)
        end%combos
    end%iteration
end%rat




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     FIND THE CLUSTER SUM THRESHOLD FOR EACH TAPER/METRIC/COMBO      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n\nFINDING CLUSTER SUM THRESHOLDS...\n');
for m = 1:4
    
    allRandoDifs = rCond(1).metric(m).values - rCond(2).metric(m).values;%find the difference between conditions
    metric(m).randoDifVals = squeeze(mean(allRandoDifs,5)); %average across rats for each iteration - output: vals x combo x iteration
    
    for p = 1:3
        cluster_thresh = metric(m).cluster_thresh(p);%get the previously defined cluster threshold for this taper/metric/combo
        
        rand_maxs = zeros(1,numRandos);
        for i = 1:size(metric(m).randoDifVals,4);
            rand_diff = metric(m).randoDifVals(:,:,p,i);
            pos_binary_diff = zeros(size(rand_diff));
            neg_binary_diff = zeros(size(rand_diff));
            pos_binary_diff(rand_diff > cluster_thresh) = 1;
            neg_binary_diff(rand_diff < -cluster_thresh) = 1;
            
            pos_clusters = (bwconncomp(pos_binary_diff,4));%caution, for arrays, bwconncomp does not heed connectivity input...
            neg_clusters = (bwconncomp(neg_binary_diff,4));% ...will have to check size of clusters below
            
            tmp_clust_max = 0;
            %look for max absolute value
            for c = 1:length(pos_clusters.PixelIdxList)
                if(length(pos_clusters.PixelIdxList{c}) >= min_clust_len)%have to check b/c bwconncomp does not for arrays
                    tmp_clust_sum =  sum(rand_diff(pos_clusters.PixelIdxList{c}));
                    if(tmp_clust_sum > tmp_clust_max)
                        tmp_clust_max = tmp_clust_sum;
                    end
                end%>min_clust_len
            end%end of cluster loop
            for c = 1:length(neg_clusters.PixelIdxList)
                if(length(neg_clusters.PixelIdxList{c}) >= min_clust_len)%have to check b/c bwconncomp does not for arrays
                    tmp_clust_sum =  abs(sum(rand_diff(neg_clusters.PixelIdxList{c})));
                    if(tmp_clust_sum > tmp_clust_max)
                        tmp_clust_max = tmp_clust_sum;
                    end
                end%>min_clust_len
            end%end of cluster loop
            
            rand_maxs(i) = tmp_clust_max; %store the max cluster sum observed for this iteration
        end
        
        rand_maxs = sort(rand_maxs); %sort the max cluster sums
        metric(m).rand_maxs = rand_maxs; %store the sorted values for checking later if you want to
        alpha_ind = round(numRandos - (alpha * numRandos)); %figure out the index for the cluster sum significance threshold
        
        metric(m).clust_sum_thresh(p) = rand_maxs(alpha_ind); %and actually get that significance threshold
        
    end%combo
end%metric


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           CHECK ACTUAL DATA AGAINST CLUSTER_SUM_THRESH              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n\nCHECKING ACTUAL DATA AGAINST THRESHOLDS...\n');
for m = 1:4
    for p = 1:3
        orig_diff = metric(m).difAVG(:,:,p); %input = vals x combo -- original average difference between conditions
        init_cluster_thresh = metric(m).cluster_thresh(p);%initial cluster detection threshold
        cluster_signif_thresh = metric(m).clust_sum_thresh(p);%cluster significance threshold
        
        pos_binary_diff = zeros(size(orig_diff));
        neg_binary_diff = zeros(size(orig_diff));
        pos_binary_diff(orig_diff > init_cluster_thresh) = 1;
        neg_binary_diff(orig_diff < - init_cluster_thresh) = 1;
        pos_clusters = (bwconncomp(pos_binary_diff,4));%caution, for arrays, bwconncomp does not heed connectivity input...
        neg_clusters = (bwconncomp(neg_binary_diff,4));% ...will have to check size of clusters below
        
        %start out with all zeros
        %above threshhold clusters will then be set to 1 below
        corrected_thresh_diff = zeros(size(orig_diff));
        
        %which clusters are statistically significant?
        %for the real data, we will mark as 0 all clusters < min_clust_len
        %positive
        for c = 1:length(pos_clusters.PixelIdxList)
            if(length(pos_clusters.PixelIdxList{c}) >= min_clust_len)%have to check b/c bwconncomp does not for arrays
                tmp_clust_sum =  sum(orig_diff(pos_clusters.PixelIdxList{c}));
                if(tmp_clust_sum >= cluster_signif_thresh)%<=alpha
                    corrected_thresh_diff(pos_clusters.PixelIdxList{c})=1;
                end
            end%>min_clust_len
        end%end of positive cluster loop
        %negative
        for c = 1:length(neg_clusters.PixelIdxList)
            if(length(neg_clusters.PixelIdxList{c}) >= min_clust_len)%have to check b/c bwconncomp does not for arrays
                tmp_clust_sum =  abs(sum(orig_diff(neg_clusters.PixelIdxList{c})));
                if(tmp_clust_sum >= cluster_signif_thresh)%<=alpha
                    corrected_thresh_diff(neg_clusters.PixelIdxList{c})=1;
                end
            end%>min_clust_len
        end%end of negative cluster loop
        
        corrected_thresh_diff(corrected_thresh_diff == 1) = orig_diff(corrected_thresh_diff == 1); %change 1s to the actual magnitude values
        metric(m).corrected_thresh_diff(:,:,p) = corrected_thresh_diff;
        
    end%combos
end%metric



end%function