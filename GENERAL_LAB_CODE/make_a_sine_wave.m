function y = make_a_sine_wave(a, f, t, varargin)
%function y = make_a_sine_wave(a, f, t, varargin)
%
%INPUTS: 
%        a = amplitude
%        f = frequency
%        t = length(seconds)
% varargin = sampling rate in Hz (optional - default is 30000 Hz)
%
%OUTPUT:
%       y = time series of sinusoidal amplitude changes
%
% JB Trimper
% 9/17/14
% Manns Lab

if nargin==4
  s=1/varargin{1}; 
else 
  s=1/30000; 
end
t=0:s:t; 
y=a*sin(2*pi*f*t); 
