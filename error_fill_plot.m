function [line_handle, poly_handle]=error_fill_plot(x,y,err,color)
%function [line_handle, poly_handle]=error_fill_plot(x,y,err,color)
%
% PURPOSE:
%   Function plots X vs. Y +/- shaded error in the color specified.
%
% INPUT:
%       x = 1 x n x values
%       y = 1 x n y values
%   color = A color name string, which will be used by the called function 'rgb' downloaded from MATLAB Central
%           NOTE: If you don't want to download 'rgb' and would rather use an RGB triplet, use "error_fill_plot2"
%
% OUPUT:
%   line_handle = handle for the line that is plotted
%   poly_handle = handle for the shaded error polygon
%
% JB Trimper
% 10/20/14
% Manns Lab

if length(x)~=length(y) || length(x)~=length(err) || length(y)~=length(err)
    error 'Length of inputs must be the same.';
end

if (size(x,2)==1); x=x'; end
if (size(y,2)==1); y=y'; end
if (size(err,2)==1); err=err'; end

upper_error=y+err;
lower_error=y-err;

x_poly=[x, fliplr(x)];
hold on;
error_poly=[lower_error, fliplr(upper_error)];

poly_handle=fill(x_poly,error_poly, rgb(color));
set(poly_handle, 'edgecolor', rgb(color));
alpha(.3);

line_handle=plot(x,y,'color', rgb(color), 'LineWidth', 2);


end %fnctn
