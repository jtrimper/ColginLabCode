function y_zero_line(optCol)

yRange = get(gca, 'YLim'); 
ln = line([0 0], yRange); 
set(ln, 'LineStyle', '--', 'Color', [0 0 0]); 
if nargin == 1
    set(ln, 'Color', rgb(optCol)); 
end