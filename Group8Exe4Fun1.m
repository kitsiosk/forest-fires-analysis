x = importdata('forestfires.dat');
n = size(x);
n = n(1);
m = 40;
alpha = 0.05;
indices = randi([1, n], m, 1);
x_reduced = x(indices, :);

% Perform the parametric t-test for correlation to colums 5-11 and print
% the result each time. The null hypothesis is H0: r=0.
for i=5:11
    for j=i+1:11
        x1 = x_reduced(:, i);
        x2 = x_reduced(:, j);
        corr_matrix = corrcoef(x1, x2);
        r = corr_matrix(1, 2);
        t = r*sqrt((m-2)/(1-r^2));
        p = 2*(1 - tcdf(abs(t), m-2));
        if p < alpha
            % Null hypothesis rejected
            fprintf("(%d, %d) -> Significant correlation according to parametric test at 95 percent confidence level\n", i, j);
        else
            % Null hypothesis accepted
            fprintf("(%d, %d) -> No correlation according to parametric test at 95 percent confidence level\n", i, j);
        end
    end
end
fprintf("\n\n");
% Perform randomized test for B=1000 repetitions and samples of size nn=40.
% Assume ull hypothesis H0: r=0
B = 1000;
nn = 40;

for i=5:11
    for j=i+1:11
        
        r_arr = zeros(B, 1);
        for k=1:B
            indices = randi([1, n], m, 1);
            x1 = x(indices, i);
            x2 = x(indices, j);
            corr_matrix = corrcoef(x1, x2);
            r = corr_matrix(1, 2);
            r_arr(k) = r;
        end
        
        r_arr = sort(r_arr);
        if r_arr(floor(alpha*B))<0 && r_arr(ceil((1-alpha)*B))>0
            % Null hypothesis accepted
            fprintf("(%d, %d) -> NO correlation according to randomization test at 95 percent confidence level\n", i, j);
        else
            fprintf("(%d, %d) -> Significant correlation according to randomization test at 95 percent confidence level\n", i, j);
        end
    end
end

% By comparing the two tests they seem to agree at almost
% every pair of indices, as the results of the fprintf() shows

