function a = percentile(X,p)
% The function percentile(X,p) returns the "p"th percentile value from data
% X. p must be between 0 and 1. X must be a column vector. Each row in X is an observation.

n = length(X); %total number of points
X = sort(X); %sort in ascending order per column

%linear interpolation
ranking = p*n;

LowerIdx = floor(ranking);
if LowerIdx == 0
    LowerIdx = 1;
elseif LowerIdx == n
    LowerIdx = n-1;
end

UpperIdx = LowerIdx+1;
lox = X(LowerIdx);
upx = X(UpperIdx);
a = lox + (ranking-LowerIdx)*(upx-lox);

%checking for input error
if length(X) <= 1
    a = nan;
    disp('Percentile input error: number of input elements must be greater than 1')
elseif max(isnan(X) + isinf(X)) == 1
    a = nan;
    disp('Percentile input error: invalid input format')
end
