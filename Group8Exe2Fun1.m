x = importdata('forestfires.dat');

% Load the data
indicesBurnt = (x(:, 13) ~= 0);
temp1 = x(indicesBurnt, 9);
temp0 = x(~indicesBurnt, 9);
rh0 = x(~indicesBurnt, 10);
rh1 = x(indicesBurnt, 10);
wind0 = x(~indicesBurnt, 11);
wind1 = x(indicesBurnt, 11);

% Perfom the two-sample t-test for mean values
[h_temp, p_temp, ci_temp] = ttest2(temp0, temp1);
[h_rh,   p_rh,   ci_rh]   = ttest2(rh0, rh1);
[h_wind, p_wind, ci_wind] = ttest2(wind0, wind1);
% None of the above tests rejects the Null Hypothesis at 95% confidence
% level so we can assume that the mean values for burnt and non-burnt 
% areas are the same at 95% confidence level.

M = 50;
nn = 20;
cis_temp = zeros(M, 2);
cis_rh   = zeros(M, 2);
cis_wind = zeros(M, 2);

for i=1:M
    indices = randi([1, length(temp0)], nn, 1);
    
    [h_temp_sample, p_temp_sample, ci_temp_sample] = ...
        ttest2(temp0(indices), temp1(indices));
    cis_temp(i, :) = ci_temp_sample;
    
    [h_rh_sample, p_rh_sample, ci_rh_sample] = ...
        ttest2(rh0(indices), rh1(indices));
    cis_rh(i, :) = ci_rh_sample;
    
    [h_wind_sample, p_wind_sample, ci_wind_sample] = ...
        ttest2(wind0(indices), wind1(indices));
    cis_wind(i, :) = ci_wind_sample;
end

% Plot confidence bounds for temperature mean difference
figure(1)
plot(cis_temp(:, 1), 'rx')
hold on
plot(cis_temp(:, 2), 'bx')
plot([1, 1], ci_temp, 'gx')
line([1 M], [0, 0])
legend('Lower bound', 'Upper Bound', 'Bounds from A, B')
xlabel('Iteration i=1...M')
ylabel('Confidence bound')
title('Temperature mean difference confidence bounds')

% Plot confidence bounds for relative humidity mean difference
figure(2)
plot(cis_rh(:, 1), 'rx')
hold on
plot(cis_rh(:, 2), 'bx')
plot([1, 1], ci_rh, 'gx')
line([1 M], [0, 0])
legend('Lower bound', 'Upper Bound', 'Bounds from A, B')
xlabel('Iteration i=1...M')
ylabel('Confidence bound')
title('Relative humidity mean difference confidence bounds')

% Plot confidence bounds for wind mean difference
figure(3)
plot(cis_wind(:, 1), 'rx')
hold on
plot(cis_wind(:, 2), 'bx')
plot([1, 1], ci_wind, 'gx')
line([1 M], [0, 0])
legend('Lower bound', 'Upper Bound', 'Bounds from A, B')
xlabel('Iteration i=1...M')
ylabel('Confidence bound')
title('Wind mean difference confidence bounds')

% In the above three figures we have plotted the lower and upper bounds for
% each one of the M=50 random samples(Blue and Red crosses) as well as the
% lower and upper bounds from the whole Datasets A and B(green crosses). It
% is obvious that the lower bounds are in general below zero(Black
% horizontal line in plots) and the upper bounds are above zero for the
% vast majority of the samples so we can safely conclude that the means of
% the temperature, RH, and wind are the same and the size of the sample 
% does not matter.

