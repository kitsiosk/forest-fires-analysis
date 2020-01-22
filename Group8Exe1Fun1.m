x = importdata('forestfires.dat');

indicesBurnt = (x(:, 13) ~= 0);
temp1 = x(indicesBurnt, 9);
temp0 = x(~indicesBurnt, 9);
rh0 = x(~indicesBurnt, 10);
rh1 = x(indicesBurnt, 10);
wind0 = x(~indicesBurnt, 11);
wind1 = x(indicesBurnt, 11);

figure(1); hold on;
title('Temperature');
histogram(temp0, 1:40);
histogram(temp1, 1:40);
legend('Not Burnt', 'Burnt');
hold off;

figure(2); hold on;
title('Relative Humidity');
histogram(rh0, 10:3:100);
histogram(rh1, 10:3:100);
legend('Not Burnt', 'Burnt');
hold off;

figure(3); hold on;
title('Wind');
histogram(wind0, 1:0.5:12);
histogram(wind1, 1:0.5:12);
legend('Not Burnt', 'Burnt');
hold off;

% Perform the goodness-of-fit chi square test for normal distribution
% with alpha=0.01. The result is 0 for temperature of non-burnt areas meaning, 
% that the hypothesis that those data come from normal distribution 
% can NOT be rejected. For Humidity and Wind and temperature at burnt areas
% the test returns 1 so we can reject the hypothesis that those data
% with 99% confidence come from a normal distrubition
chi2gof(temp0, 'Alpha', 0.01, 'NBins', 30)
chi2gof(temp1, 'Alpha', 0.01, 'NBins', 30)
chi2gof(rh0,   'Alpha', 0.01, 'NBins', 30)
chi2gof(rh1,   'Alpha', 0.01, 'NBins', 30)
chi2gof(wind0, 'Alpha', 0.01, 'NBins', 30)
chi2gof(wind1, 'Alpha', 0.01, 'NBins', 30)

% For the rejected cases perform goodness-of-fit test for the Poisson
% Distribution at 99% confidence level
% Run the following lines until the next comment with different arguments
% in histogram(__, 5) to test all the data.
hist = histogram(rh0, 5);
bins = 0:4;
observedCounts = hist.Values;
n = sum(observedCounts);
lambdaHat = sum(bins.*observedCounts)/n;
expCounts = n*poisspdf(bins,lambdaHat);
[h, p] = chi2gof(bins,'Ctrs',bins, 'Frequency',observedCounts, ...
                     'Alpha', 0.01, 'Expected',expCounts, 'NParams', 1);
% Only Relative Humidity passes the hypothesis test for
% Poisson distribution with the goodness-of-fit test.

% Just by seeing the histograms, the PDFs of the 3 attributes seem to 
% comme from the same distribution. The temperature seems like a 
% normal distribution while Humidity and Wind come from a more skewed
% distribution. The Humidity at not burnt areas passes the goodnes-of-fit
% test for poisson distribution with a=0.01 but with a p-value=0.015