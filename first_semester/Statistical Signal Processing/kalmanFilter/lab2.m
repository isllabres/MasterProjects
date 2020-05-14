%Exercise 2.1
clear;
clc;

T = 1/2;
sigma0 = 1/5;
sigmaU = 1/10;
sigmaW = 1/2;
sigmaL = 1;

m = 100;

D_U = diag([sigmaU, sigmaU]);
D_W = diag([sigmaW, sigmaW]);
D_0 = diag([sigma0, sigma0, sigma0, sigma0]);
Q = diag([sigmaW, sigmaW, sigmaU, sigmaU]);
A = [1 0 T 0; 0 1 0 T; 0 0 1 0; 0 0 0 1];


%Set the initial points for v and r

v = zeros(2, m);
r = zeros(2, m);
x = zeros(4, m);


x(:,1) = randn([4 1]) * sqrt(sigma0);
for n = 2:m;
    s = sqrt(Q) * randn([4 1]);
    x(:, n) = A * x(:, n - 1) + s;
end;


plot(x(1, 1 : end), x(2, 1 : end),'k-');
