x = importdata('forestfires.dat');
n = size(x);
n = n(1);
y = x(:, 13);   % Extract area as the wanted result
y = log(y+0.01)

% Loop over all attributes
for i=1:5
    % Make a scatter plot to have an idea of the model to use(Lineal,
    % Polynomial, etc).
    figure(i)
    plot(x(:, i), y, 'bo');
end