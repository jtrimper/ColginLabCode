function [y,x] = make_a_sawtooth_wave(a, f, t, varargin)
% function y = make_a_sawtooth_wave(a, f, t, varargin)
%
%INPUTS:
%        a = amplitude
%        f = frequency
%        t = length(seconds)
% varargin = sampling rate in Hz (optional - default is 30000 Hz)
%
%OUTPUT:
%       y = time series of sawtooth amplitude changes
%       x = time values corresponding to the amplitude time series
%
% JB Trimper
% 1/17/19
% Colgin Lab

if nargin==4
    s=1/varargin{1};
else
    s=1/30000;
end
x=0:s:t;
y = a*sawtooth(2*pi*f*x);
