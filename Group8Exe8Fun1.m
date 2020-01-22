x = importdata('forestfires.dat');
n = size(x);
n = n(1);
y = x(:, 11);    % Extract the wind data in y
x = [x(:, 1:10) x(:, 12:end)];  % Remove wind from dataset

% Stepwise fit the whole dataset
[beta, ~, ~, inmodel, stats] = stepwisefit(x, y);

M = 100;
nn = 40;
inmodelArr = zeros(M, 12);

for i=1:M
    indices = randi([1, n], nn, 1);
    yM = y(indices);
    xM = x(indices, :);
    
    [betaM, ~, ~, inmodelM, statsM] = stepwisefit(xM, yM, 'display', 'Off');
    inmodelArr(i, :) = inmodelM;
end

% Sum all the columns of inmodelArr to obtain how many times the parameter
% of each column was used in the model
inmodelSum = sum(inmodelArr, 1)
% We see that the parameters 7, 8, 9 are used frequently. These parameters
% correspond to DC, ISI and temperature. We observe that these parameters
% are also the ones that were added FIRST in the initial stepwise model of
% the whole dataset. Those indicate that the wind highly depents upon those
% 3 parameters as well as that they are uncorrelated with each other.