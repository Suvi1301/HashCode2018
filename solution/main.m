% Load the file
M = dlmread('e_high_bonus.in');

R = M(1, 1);
C = M(1, 2);
V = M(1, 3);
N = M(1, 4);
B = M(1, 5);
T = M(1, 6);

data = M(2 : N + 1, :);

juxtapose = zeros(N, N);

deets = zeros(N, 5);

fromZero = zeros(N, 1);

for i = 1:N 
  deets(i, 1) = abs(data(i, 1) - data(i, 3)) + abs(data(i, 2) - data(i, 4));
  deets(i, 2) = data(i, 5);
  deets(i, 3) = data(i, 6);
  deets(i, 4) = deets(i, 3) - deets(i, 2) - deets(i, 1);
  deets(i, 5) = i;
  fromZero(i, 1) = data(i, 1) + data(i, 2);
end

for i = 1:N
  for j = 1:N
    if i < j
      juxtapose(i, j) = abs(data(j, 3) - data(i, 1)) + abs(data(j, 4) - data(i, 2));
    elseif i > j
      juxtapose(i, j) = abs(data(i, 3) - data(j, 1)) + abs(data(i, 4) - data(j, 2));
    end
  end
end


sorted = sortrows(deets, 4);
sorted = sortrows(deets, 3);
sorted = sortrows(deets, 1);
sorted = sortrows(deets, 2);


results = zeros(V, N);
times = zeros(V, 1);
last = zeros(V, 1);
index = zeros(V, 1);

% Assign to start.
for i = 1 : V
  results(i, 1) = sorted(i, 5);
  times(i) = fromZero(results(i)) + sorted(i, 1);
  last(i) = results(i);
  index(i) = 2;
end

nextTime = zeros(V, 2);

% The actual algorithm.
for i = V + 1 : N
  for j = 1 : V
    nextTime(j, 1) = juxtapose(last(j), sorted(i, 5)) + sorted(i, 1) + times(j);
    nextTime(j, 2) = sorted(i, 5);
  end
  
  [X, I] = min(nextTime(:, 1));
  
  results(I, index(I)) = sorted(i, 5);
  times(I) = X;
  last(I) = sorted(i, 5);
  index(I) = index(I) + 1;
end

bigboy = max(index);
results = results(:, 1 : bigboy);

results = results - 1;
numOfRiders = index - 1;

A = [numOfRiders results];

dlmwrite('hoefile.txt', A);