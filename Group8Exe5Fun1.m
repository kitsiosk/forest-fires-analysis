x = importdata('forestfires.dat');
n = size(x);
n = n(1);
m = 40;
rng(0); % Seed to reproduce results
indices = randi([1, n], m, 1);
temp = x(indices, 9);
rh = x(indices, 10);
wind = x(indices, 11);

% First lets plot the relative scatter plots
figure(1)
plot(temp, rh, 'bo');
xlabel('Temperature')
ylabel('RH')
title('RH vs Temperature scatter plot')
figure(2)
plot(temp, wind, 'bo');
xlabel('Temperature')
ylabel('Wind')
title('Wind vs Temperature scatter plot')

% We see a linear correlation in the RH vs Temp while there is no such
% obvious correlation in the Wind vs Temp plot

% Add a ones column for constant term
temp = [ones(40, 1) temp];

[b, ~, rb, ~, statsb] = regress(rh, temp);
[c, ~, rc, ~, statsc] = regress(wind, temp);

R2b = statsb(1);
R2c = statsc(1);
fprintf("R^2 statistic for RH vs Temp regression: %0.5f \n", R2b);
fprintf("R^2 statistic for Wind vs Temp regression: %0.5f \n", R2c);
% We observe that for wind the R^2 statistic is near zero meaning that
% there is no correlation between wind and temperature. The value 0.31 for
% RH means that there is a correlation but not a very strong one, but
% clearly better that wind. If we tried to fit a polynomial in the RH vs
% temp relationship we could expect better results whil for wind it would
% not help that much because the temperature seems to be kind of constant.

% Plot the sample autocorrelation and the confidence boundaries of the
% residuals of each regression.
figure(3);
autocorr(rb);
figure(4);
autocorr(rc);
% We clearly see that the residuals are not correlated for every lag ô>0
% and the only correlation exists at ô=0.
