function han = y_zero_line(optCol)

yRange = get(gca, 'YLim'); 
han = line([0 0], yRange); 
set(han, 'LineStyle', '--', 'Color', [0 0 0]); 
if nargin == 1
    set(han, 'Color', rgb(optCol)); 
end