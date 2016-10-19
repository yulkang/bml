function [ X,f,t ] = dft(x,Fs, varargin)
% [ X,f,t ] = dft(x,Fs, varargin)
%
% Assumes x is an N x 1 column vector
% and Fs is the sampling rate.

% from https://www.mathworks.com/matlabcentral/answers/155349#answer_152198

N = size(x,1);
dt = 1/Fs;
t = dt*(0:floor(N-1))';
dF = Fs/N;
f = dF*(0:floor(N/2-1))'; % Hz
X = fft(x, varargin{:})/N;
X = X(1:floor(N/2));
X(2:end) = 2*X(2:end);

%      figure;
%      plot(f,abs(X));
end