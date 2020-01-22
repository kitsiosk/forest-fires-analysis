x = importdata('forestfires.dat');

indicesBurnt = (x(:, 13) ~= 0);
temp0 = x(~indicesBurnt, 9);
temp1 = x(indicesBurnt, 9);
rh0   = x(~indicesBurnt, 10);
rh1   = x(indicesBurnt, 10);
wind0 = x(~indicesBurnt, 11);
wind1 = x(indicesBurnt, 11);

B = 1000;
n = length(temp0);
m = length(temp1);
temp_med_diff = median(temp0) - median(temp1);
rh_med_diff = median(rh0) - median(rh1);
wind_med_diff = median(wind0) - median(wind1);

% Array of all data to choose the bootstrap samples from
temp = [temp0; temp1];
rh = [rh0; rh1];
wind = [wind0; wind1];

temp_med_arr = zeros(B, 1);
rh_med_arr = zeros(B, 1);
wind_med_arr = zeros(B, 1);

for i=1:B
    % Use boostrap test so we will have resampling
    indices0 = randi([1 n], n, 1);
    indices1 = randi([1 m], m, 1);
    
    temp_med0 = median(temp(indices0));
    temp_med1 = median(temp(indices1));
    
    rh_med0 = median(rh(indices0));
    rh_med1 = median(rh(indices1));
    
    wind_med0 = median(wind(indices0));
    wind_med1 = median(wind(indices1));
    
    temp_med_arr(i) = temp_med0 - temp_med1;
    rh_med_arr(i) = rh_med0 - rh_med1;
    wind_med_arr(i) = wind_med0 - wind_med1;
end

% For temperature check if the actual difference of the medians for burnt
% and not burnt is between the 95% of the elements of the boostrap array
temp_med_arr = [temp_med_diff; temp_med_arr];
temp_med_arr = sort(temp_med_arr);
alpha = 0.05;
low_index = floor(alpha*length(temp_med_arr));
up_index  = ceil((1-alpha)*length(temp_med_arr));
if(temp_med_diff < temp_med_arr(low_index) || temp_med_diff > temp_med_arr(up_index))
    fprintf("Null Hypothesis rejected. Medians for temperature are not the same at 95 percent confidence level \n");
else
    fprintf("Null Hypoithesis not rejected. Medians for temperature are the same at 95 percent confidence level \n");
end

% Do the same for Wind
wind_med_arr = [wind_med_diff; wind_med_arr];
wind_med_arr = sort(wind_med_arr);
alpha = 0.05;
low_index = floor(alpha*length(wind_med_arr));
up_index  = ceil((1-alpha)*length(wind_med_arr));
if(wind_med_diff < wind_med_arr(low_index) || wind_med_diff > wind_med_arr(up_index))
    fprintf("Null Hypothesis rejected. Medians for wind are not the same at 95 percent confidence level \n");
else
    fprintf("Null Hypoithesis not rejected. Medians for wind are the same at 95 percent confidence level \n");
end

% Do the same for RH
rh_med_arr = [rh_med_diff; rh_med_arr];
rh_med_arr = sort(rh_med_arr);
alpha = 0.05;

% The above results indicate that for temepratures the median is not the
% same at 95% confidence level for burnt and non-burnt areas, while it is
% the same for RH and Wind.
low_index = floor(alpha*length(rh_med_arr));
up_index  = ceil((1-alpha)*length(rh_med_arr));
if(rh_med_diff < rh_med_arr(low_index) || rh_med_diff > rh_med_arr(up_index))
    fprintf("Null Hypothesis rejected. Medians for RH are not the same at 95 percent confidence level \n");
else
    fprintf("Null Hypoithesis not rejected. Medians for RH are the same at 95 percent confidence level \n");
end

%%% Now we will test for small samples of size nn=20. We will use M=50 such
%%% samples and compare the results with the above.
M = 50;
nn = 20;

% Initialize the arrays for the samples
temp_med_arr_s = zeros(B, 1);
rh_med_arr_s = zeros(B, 1);
wind_med_arr_s = zeros(B, 1);

% Arrays that will count how many time the null hypothesis has been
% rejected
temp_null_counts = zeros(M, 1);
rh_null_counts = zeros(M, 1);
wind_null_counts = zeros(M, 1);

for ii=1:M
    for i = 1:B
        indices0 = randi([1 n], nn, 1);
        indices1 = randi([1 m], nn, 1);
        
        rh_med0 = median(rh(indices0));
        rh_med1 = median(rh(indices1));

        wind_med0 = median(wind(indices0));
        wind_med1 = median(wind(indices1));
        
        temp_med_arr_s(i) = temp_med0 - temp_med1;
        rh_med_arr_s(i) = rh_med0 - rh_med1;
        wind_med_arr_s(i) = wind_med0 - wind_med1;
    end

    % For temperature check if the actual difference of the medians for burnt
    % and not burnt is between the 95% of the elements of the boostrap array
    temp_med_arr_s = [temp_med_diff; temp_med_arr_s];
    temp_med_arr_s = sort(temp_med_arr_s);
    alpha = 0.05;
    low_index = floor(alpha*length(temp_med_arr_s));
    up_index  = ceil((1-alpha)*length(temp_med_arr_s));
    if(temp_med_diff < temp_med_arr_s(low_index) || temp_med_diff > temp_med_arr_s(up_index))
        temp_null_counts(ii) = 1;
    else
        temp_null_counts(ii) = 0;
    end
    
    % Do the same for Wind
    wind_med_arr_s = [wind_med_diff; wind_med_arr_s];
    wind_med_arr_s = sort(wind_med_arr_s);
    alpha = 0.05;
    low_index = floor(alpha*length(wind_med_arr_s));
    up_index  = ceil((1-alpha)*length(wind_med_arr_s));
    if(wind_med_diff < wind_med_arr_s(low_index) || wind_med_diff > wind_med_arr_s(up_index))
        wind_null_counts(ii) = 1;
    else
        wind_null_counts(ii) = 0;
    end

    % Do the same for RH
    rh_med_arr_s = [rh_med_diff; rh_med_arr_s];
    rh_med_arr_s = sort(rh_med_arr_s);
    alpha = 0.05;

    % The above results indicate that for temepratures the median is not the
    % same at 95% confidence level for burnt and non-burnt areas, while it is
    % the same for RH and Wind.
    low_index = floor(alpha*length(rh_med_arr_s));
    up_index  = ceil((1-alpha)*length(rh_med_arr_s));
    if(rh_med_diff < rh_med_arr_s(low_index) || rh_med_diff > rh_med_arr_s(up_index))
        rh_null_counts(ii) = 1;
    else
        rh_null_counts(ii) = 0;
    end
end

fprintf("At M=50 repetitions of the test the number of times the null hypothesis was rejected for temperature is %d \n", sum(temp_null_counts));
fprintf("At M=50 repetitions of the test the number of times the null hypothesis was rejected for RH is %d \n", sum(rh_null_counts));
fprintf("At M=50 repetitions of the test the number of times the null hypothesis was rejected for wind is %d \n", sum(wind_null_counts));

% The above indicate that the results remain the same even if we use a
% small sample instead of a large one.