function D = nmahalanobis(Y,X)
% D = nmahalanobis(Y,X) returns the Mahalanobis distance normalized by the
% number of variables of each observation in Y from the reference data in X. Each
% row is an observation and each column is a variable. Y and X must have
% the same number of columns.
% Edwin Sutrisno 8/24/2012

%% Checking for input error
if length(X) <= 1 | length(Y) <= 1
    D = nan;
    disp('Input error: number of observations be greater than 1')
    return
elseif max(isnan(X) + isinf(X)) == 1 | max(isnan(Y) + isinf(Y)) == 1
    D = nan;
    disp('Input error: invalid input format')
    return
end

%%
%%sadfadfs
% % Calculate the mean (centroid) of X
% MU = mean(X);
% 
% % Calculate the covariance matrix of X
% SIGMA = cov(X);
% 
% % Deviation of each point in Y from MU
% DevY = Y-repmat(MU,size(Y,1),1);
% 
% % Calculate the squared mahalanobis distance
% TranDY = DevY*SIGMA^(-1); %transform the deviations using covariance
% DevY2 = TranDY.*DevY; %multiply element by element
% D2 = sum(DevY2,2); %this is the same result as Matlab's mahal function which gives the squared distance
D2= mahal(Y,X);

% Normalize with the number of variables
NorD2 = D2/size(X,2); %divide by the number of variables

% Take square root to return to standard unit
D = sqrt(NorD2);