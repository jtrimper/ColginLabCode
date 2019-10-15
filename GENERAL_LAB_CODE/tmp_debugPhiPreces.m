% tmp_debugPhiPreces

% Centers of rate-map angular bins
rmBinEdges = linspace(0,360,(360/5)+1);
rmBinAngs = edges_to_x_vals(rmBinEdges);

figure('name', ['Unit ' num2str(u)], 'Position', [13          88        1901         828]);
allSpksByPos = zeros(1, length(rmBinAngs));
for b = 1:4
    cd(['begin', num2str(b)]);
    
    
    [radPos, coords] = read_in_circtrack_coords('VT1.nvt');
    spksByPos = zeros(1, length(rmBinAngs));
    spkTms = rat(r).task(t).bout(b).unit{reg}(u).spkTms;
    rm(:,b) = get_ratemap_circtrack(spkTms, coords, radPos, spatBinSz, 1, 1);
    for st = 1:length(spkTms)
        tmpTm = spkTms(st);
        spkPosInd = find(radPos(:,1)<=tmpTm, 1, 'Last');
        if ~isempty(spkPosInd)
            precSpkPos = radPos(spkPosInd,2);
            [~,minInd] = min(abs(circ_dist(deg2rad(precSpkPos), deg2rad(rmBinAngs))));
            spksByPos(minInd) = spksByPos(minInd) + 1;
        end
    end
    
    
    subplot(2,5,b);
    plot(rmBinAngs, rm(:,b));
    xlim([0 360]);
    hold on;
    yBnds = get(gca, 'YLim');
    ylim(yBnds);
    title(['Begin ' num2str(b)]);
    for p = 1:length(unit(u).pf)
        ln = line([unit(u).pf(p).pkPos, unit(u).pf(p).pkPos], yBnds);
        set(ln, 'LineStyle', '--', 'Color', [1 0 0]);
    end
    if b == 1
        ylabel('Firing Rate (Hz)'); 
    end
    fix_font; 
    
    
    subplot(2,5,5+b);
    bar(rmBinAngs, spksByPos)
    hold on;
    xlim([0 360]);
    yBnds = get(gca, 'YLim');
    ylim(yBnds);
    for p = 1:length(unit(u).pf)
        ln = line([unit(u).pf(p).pkPos, unit(u).pf(p).pkPos], yBnds);
        set(ln, 'LineStyle', '--', 'Color', [1 0 0]);
    end
    if b == 1
        ylabel('Spike Counts'); 
    end
    xlabel('Position (degrees)'); 
    fix_font; 
    
    
    allSpksByPos = allSpksByPos + spksByPos;
    
    cd ../
end


subplot(2,5,5);
avgRm = nanmean(rm,2);
smRm = smooth_circtrack_ratemap(avgRm', 5);
plot(rmBinAngs, avgRm);
xlim([0 360]);
hold on;
plot(rmBinAngs, smRm);
yBnds = get(gca, 'YLim');
ylim(yBnds);
title('Average(top) / Sum(bot)'); 
for p = 1:length(unit(u).pf)
    ln = line([unit(u).pf(p).pkPos, unit(u).pf(p).pkPos], yBnds);
    set(ln, 'LineStyle', '--', 'Color', [1 0 0]);
    pfEdges = rmBinEdges([unit(u).pf(p).inds(1) unit(u).pf(p).inds(end)+1]);
    poly = fill([pfEdges fliplr(pfEdges)], [yBnds(1) yBnds(1) yBnds(2) yBnds(2)], [0 0 0]);
    alpha .3
end
fix_font; 



subplot(2,5,10);
bar(rmBinAngs, allSpksByPos)
xlim([0 360]);
hold on;
yBnds = get(gca, 'YLim');
ylim(yBnds);
for p = 1:length(unit(u).pf)
    ln = line([unit(u).pf(p).pkPos, unit(u).pf(p).pkPos], yBnds);
    set(ln, 'LineStyle', '--', 'Color', [1 0 0]);
    pfEdges = rmBinEdges([unit(u).pf(p).inds(1) unit(u).pf(p).inds(end)+1]);
    poly = fill([pfEdges fliplr(pfEdges)], [yBnds(1) yBnds(1) yBnds(2) yBnds(2)], [0 0 0]);
    alpha .3
end
fix_font; 
