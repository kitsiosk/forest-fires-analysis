x = importdata('forestfires.dat');
n = size(x);
n = n(1);
temp_all = x(:, 9);
rh_all = x(:, 10);

% Add a ones column for constant term
temp_all = [ones(n, 1) temp_all];
b_real = regress(rh_all, temp_all);
b_real = b_real(2);

M = 100;
nn = 40;
B = 100;
alpha = 0.05;

b_arr = zeros(M, 1);
bint_arr_par = zeros(M, 2);
bint_arr_boot = zeros(M, 1);

% Counters of how many times the confidence intervals contain the acutal
% value of b
count_par = 0;
count_boot = 0;
for i=1:M
    indices = randi([1, n], nn, 1);
    temp = temp_all(indices, :);
    rh = rh_all(indices);
    % Parametric confidence intervals
    [b, bint] = regress(rh, temp);
    b = b(2);
    b_arr(i) = b;
    bint = bint(2, :);
    bint_arr_par(i, :) = bint;
    
    % Boostrap confidence intervals
    bootstrap_arr = zeros(B, 1);
    for j=1:B
        indices_boot = randi([1, nn], nn, 1);
        temp_b = temp(indices_boot, :);
        rh_b = rh(indices_boot);
        b_boot = regress(rh_b, temp_b);
        b_boot = b_boot(2);
        bootstrap_arr(j) = b_boot;
    end
    bootstrap_arr = sort(bootstrap_arr);
    low_b = bootstrap_arr(floor(alpha*B));
    up_b = bootstrap_arr(ceil((1-alpha)*B));
    bint_arr_boot(i, 1) = low_b;
    bint_arr_boot(i, 2) = up_b;
    
    if b_real > bint(1) && b_real < bint(2)
        count_par = count_par + 1;
    end
    if b_real > low_b && b_real < up_b
        count_boot = count_boot + 1;
    end
end

% Plot the histogram of the M=100 values of b
histogram(b_arr);
% It is clear from the histogram that the vast majority of times the b
% computed from the small sample is very close to the real one. But there
% are also some samples that give bad estimates of b, although the number
% of these samples is generally small.

fprintf("Percentage of parametric intervals containing the real value of b: %0.2f \n", count_par/M);
fprintf("Percentage of bootstrap intervals containing the real value of b: %0.2f \n", count_boot/M);
% The percentage for the parametric and bootstrap intervals are very close 
% to each other with parametric being a little better
