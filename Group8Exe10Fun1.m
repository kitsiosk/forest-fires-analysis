x = importdata('forestfires.dat');
[n, m] = size(x);

% extract the RH values 
y = x(:, 10);
x = [x(:, 1:9) x(:, 11:end)];

% Apply linear model with all the variables first
train_size = ceil(0.8*n);
test_size = n - train_size;
xtrain = x(1:train_size, :);
xtest = x(train_size+1:end, :);
ytrain = y(1:train_size, :);
ytest = y(train_size+1:end, :);

% Add a vector of ones to include intercept term
xtrain = [ones(train_size, 1) xtrain];
xtest = [ones(test_size, 1) xtest];
% Train the regression model
b = regress(ytrain, xtrain);
% Make predictions on test set
yhat = xtest*b;

% Compute R2 and adjR2
R2 = 1 - sum( (ytest - mean(ytest)).^2 )/sum( (ytest - yhat).^2 );
adjR2 = 1 - (1 - R2)*(test_size-1)/(test_size-(m-1)-1);
fprintf("R^2 for full regression model : %f \n", R2);
fprintf("Adjusted R^2 for full regression model: %f \n", adjR2);
% R^2 and adjR^2 values for regression model with all 12 variables are
% 0.54 and 0.47 respectively. The training set size was 80% of the whole
% dataset and the test set size was 20%. 

% We will now use Dimensionality Reduction and PCR and compare the results
% First PCR Model. We will use as train_size the 75% of the dataset.
train_size = ceil(0.8*n);
test_size = n - train_size;
xtrain = x(1:train_size, :);
xtest = x(train_size+1:end, :);
ytrain = y(1:train_size, :);
ytest = y(train_size+1:end, :);

[coeff, scores, ~, ~, explained] = pca( xtrain - mean(xtrain));

% Plot the variance percentage explained in order to choose the correct
% dimensions d for pca
figure(1);
plot(explained, 'ro-');
title('Variance explained');

% According to the above plot we choose the dimensions of the 2 PCR models
% to be 5 and 8.
% Perform PCR with d = 8. Below we will use PLS for d = 5 and compare.
d=8;
bPCR = regress(ytrain - mean(ytrain), scores(:, 1:d));
bPCR = coeff(:, 1:d)*bPCR;
bPCR = [mean(ytrain) - mean(xtrain)*bPCR; bPCR];

%%% Alternative way to compute bPCR, results are the same
% [uM,sigmaM,vM] = svd((xtrain - mean(xtrain)),'econ');
% lambdaV = zeros(m-1,1);
% lambdaV(1:d) = 1;
% bPCR = vM * diag(lambdaV) * inv(sigmaM) * uM'* (ytrain - mean(ytrain));
% bPCR = [mean(ytrain) - mean(xtrain)*bPCR; bPCR];

% Make predictions
yPCR = [ones(test_size, 1) xtest] * bPCR;
TSS = sum( (ytest - mean(ytest)).^2 );
RSSPCR = sum( (ytest - yPCR).^2 );
R2PCR = 1 - RSSPCR/TSS;
figure(2);
plot(ytest, yPCR, 'ro');
xlabel('Test values(Real)');
ylabel('PCR values(Predicted)');
title('PCR with 5 components');

% Perform PLS;
d=5;
[~, ~, ~, ~, bPLS] = plsregress(xtrain, ytrain, d);
yPLS = [ones(test_size, 1) xtest]*bPLS;
RSSPLS = sum( (ytest - yPLS).^2 );
R2PLS = 1 - RSSPLS/TSS;
figure(3);
plot(ytest, yPLS, 'ro');
xlabel('Test values(Real)');
ylabel('PLS values(Predicted)');
title('PLS with 5 components');

adjR2PCR = 1 - (1 - R2PCR)*(test_size-1)/(test_size-(m-1)-1);
adjR2PLS = 1 - (1 - R2PLS)*(test_size-1)/(test_size-(m-1)-1);

fprintf("R2 for PCR with 8 components : %f \n", R2PCR);
fprintf("Adjusted R2 for PCR with 8 components: %f \n", adjR2PCR);
fprintf("R2 for PLS with 5 components : %f \n", R2PLS);
fprintf("Adjusted R2 for PLS with 5 components: %f \n", adjR2PLS);

% We observe that PCR with 8 components performs better that PLS with 5
% components. By changing PCR components to 8 we can also see that PCR with
% 8 components is better than with 5 components. In contrary, if we change
% PLS components from 5 to 8 we see that R2 is less meaning that PLS
% performs better with less components.
