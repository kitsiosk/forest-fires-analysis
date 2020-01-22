x = importdata('forestfires.dat');
sz = size(x);
n = sz(1);
m = sz(2);

% Feature normalization
mu = mean(x, 1);
sigma2 = std(x, 1);
x = (x-mu)./sigma2;

% Covariance matrix
covM = cov(x);
% Eigenvectors and eigenvalues
[eigvec, eigvalM] = eig(covM);
eigval = diag(eigvalM);
% Flip order to get largest eigenvalues first
eigval = flipud(eigval);

% Scree plot
figure(1);
plot(eigval, 'bo-');
title('Scree plot')
% Compute the mean value of all the eigenvalues and draw an horizontal line
% at that value of the scree plot
lamdabar = mean(eigval);
line([0, m], [mueig, mueig]);

% From the scree plot we see that 5 eigenvalues are above the threshold so
% we estimate d=5.

% We will now estimate d using B=1000 randomized samples
B = 1000;
% Each row i of eigvalArr contains the m eigenvalues of i-th randomized
% sample
eigvalArr = zeros(B, m);
for i=1:B
    indices = randi([1, n], n, 1);
    xi = x(indices, :);     % xi is already normalized from above
    
    covMi = cov(xi);
    [~, eigvalMi] = eig(covMi);
    eigvali = diag(eigvalMi);
    eigvali = flipud(eigvali);
    eigvalArr(i, :) = eigvali;
end

% Check how many of the initial eigenvalues are in the right tail of the
% empirical distribution of eigvalArr. By right we mean after index
% (1-alpha)*B for alpha = 0.05
eigvalArr = sort(eigvalArr, 1);
alpha = 0.05;
rightInd = ceil( (1-alpha)*B );
dr = 0;
for i=1:m
    if eigval(i) > eigvalArr(rightInd, i);
        dr = dr + 1;
    end
end
% The resulting d from the randomized test is d=1, which is much smaller
% than the d=5 we found from the scree-plot.
