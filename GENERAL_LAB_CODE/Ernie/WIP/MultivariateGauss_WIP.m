function [redraw, rekey, undoable] = RemoveNoise3(iClust)

global MClust_FeatureNames MClust_Clusters
global MClust_TTdn MClust_TTfn MClust_TText
global MClust_FeatureSources MClust_FeatureTimestamps

if ~license('test', 'Statistics_Toolbox') || isempty(which('mahal'))
	 % needs mahal from Stats toolbox
     return
end

Features = {};      % Features to use in calculating separation
FD = [];                 % Feature data matrix
ChannelValidity = [1 1 1 1];

    if ~isempty(MClust_FeatureNames)
        Features = MClust_FeatureNames;
    else
        disp('No MClust_ClusterFeatures variable found')
        return
    end
    
    FeaturesToGet = MClust_FeatureSources;
    for t = 1:size(FeaturesToGet,1)/4 %assuming all four channel are valid
        Featuresfile{t} = FeaturesToGet{t*4-3,1}; %obtain FD file name
    end
    
        nFeatures = size(Featuresfile,2);
        for iF = 1:nFeatures
            FDFileName = Featuresfile{iF};
            temp = load(FDFileName,'-mat');
            if size(temp.FeatureData,2) == size(ChannelValidity,2)
                FD = [FD temp.FeatureData(:,logical(ChannelValidity))];
            else
                FD = [FD temp.FeatureData];
            end
        end
        
[f1 MClust_Clusters{iClust}] = FindInCluster(MClust_Clusters{iClust});        
timediff = diff(MClust_FeatureTimestamps(f1));
WithoutRPIndex = find(timediff < 10);
f2 = f1(WithoutRPIndex);  %f2 and f3 are pairs of spikes without refractory period      
f3 = f1(WithoutRPIndex+1);

md2 = mahal(FD(f2,:),FD(f1,:));
md3 = mahal(FD(f3,:),FD(f1,:));
f_noise = zeros(size(f2));
f_noise(md2>md3) = f2(md2>md3);
f_noise(md3>md2) = f3(md3>md2);
        
    nDimension = length(MClust_FeatureNames);
    FeaturesCombination = zeros(sum(1:nDimension-1),2);
    numcomb = 0;
    MDistance = zeros(sum(1:nDimension-1),size(f2,1));
    TwoDCenter = zeros(sum(1:nDimension-1),2);
    for d1 = 1:nDimension-1
        for d2 = d1+1:nDimension
            numcomb = numcomb + 1;
            subfd = FD(:,[d1 d2]);          
            
            FeaturesCombination(numcomb,1) = d1; FeaturesCombination(numcomb,2) = d2;
            TwoDCenter(numcomb,1) = mean(subfd(:,1)); TwoDCenter(numcomb,2) = mean(subfd(:,2));
            MDistance(numcomb,:) = mahal(subfd(f_noise,:),subfd(f1,:));  
            
        end
    
    end
    
[~, bestPj] = max(MDistance,[],1);
in = false(size(f1,1),size(f_noise,1));
center = zeros(2,size(f_noise,1));
for nn = 1:size(f_noise,1)
    x1 = FD(f1,FeaturesCombination(bestPj(nn)),1);
    x2 = FD(f1,FeaturesCombination(bestPj(nn)),2);
    y1 = FD(f_noise(nn),FeaturesCombination(bestPj(nn)),1);
    y2 = FD(f_noise(nn),FeaturesCombination(bestPj(nn)),2);
    
    [in(:,nn), center(:,nn)] = mahal_movecenter([y1 y2],[x1 x2]);

end

    

        

            
            
            
            