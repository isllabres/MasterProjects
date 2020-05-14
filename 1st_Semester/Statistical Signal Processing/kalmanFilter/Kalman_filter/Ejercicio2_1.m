%Variables for 2.1

clear;
clc;

T = 1/2;
sigma0 = 1/5;
sigmaU = 1/10;
sigmaW = 1/2;
sigmaL = 1;

m = 100;
K = 3;

D_U = diag([sigmaU, sigmaU]);
D_W = diag([sigmaW, sigmaW]);
D_0 = diag([sigma0, sigma0, sigma0, sigma0]);
Q = diag([sigmaW, sigmaW, sigmaU, sigmaU]);
I = diag([1, 1]);

H = [1 -0.3 0 0; -0.2 -1 0 0];
A = [1 0 T 0; 0 1 0 T; 0 0 1 0; 0 0 0 1];
c1 = [0; 100]
c2 = [-100; 0]

%Set the initial points for v and r

v = zeros(2, m);
r = zeros(2, m);
x = zeros(4, m);
x(:,1) = randn([4 1]) * sqrt(sigma0);
y(:,1) = H * x(:, 1) + (sqrt(I) * randn([2 1]));

l = (sqrt(I) * randn([2 1]));

z(1, 1) = norm(x(1:2, 1) - c1) + l(1, 1);
z(2, 1) = norm(x(1:2, 1) - c2) + l(2, 1);

%Variables of 2.2. Kalman filter

Pn = zeros(4, 4, m);
Pn_ =  zeros(4, 4, m);
x_ = zeros(4, m);
x_update = zeros(4, m);
R = zeros(2, 2);
S = zeros(2, 2, m);

P0 = diag([sigma0, sigma0, sigma0, sigma0]);

T = 1/2;


Pn(:, :, 1) = P0;

%meter en un bucle for de 1 a 3 para poder plotear 3 observaciones

for i = 1:K;
    
    for n = 2:m;

        s = sqrt(Q) * randn([4 1]);
        l = sqrt(I) * randn([2 1]);

        x(:, n) = A * x(:, n - 1) + s;
        y(:, n) = H * x(:, n) + l;

        z(1, n) = norm(x(1:2, n) - c1) + l(1, 1);
        z(2, n) = norm(x(1:2, n) - c2) + l(2, 1);


    end

    %Three sample trayectories (falta hacer esto tres veces y poner los puntos
    %c1 y c2)
    figure(1)
    subplot(3,3,i)
    plot(x(1, 1 : end), x(2, 1 : end),'k-');
    hold on;    
    subplot(3,3,i+3)
    plot(1:m, x(3,1 : m), 'k-');    
    subplot(3,3,i+6)
    plot(1:m, x(4,1 : m), 'r-');
    hold off;

    figure(2)    
    subplot(2,3,i)
    plot(1:m, y(1,1 : m), 'b-')
    hold on;
    subplot(2,3,i+3)
    plot(1:m, y(2,1 : m), 'r-')
    hold off;

    figure(3)    
    subplot(2,3,i)
    plot(1:m, z(1,1:m), 'b--')
    hold on;    
    subplot(2,3,i+3)
    plot(1:m, z(2,1:m), 'r--')
    hold off;
    
end

%KALMAN FILTER

for n = 2:m;
    %Predict
    Pn_(:,:,n) = A * Pn(:,:,n-1) * A' + Q;
    x_(:,n) = A * x_update(:,n-1);
    
    %Update
    S(:,:,n) = H * Pn_(:,:,n) * H' + I;
    x_update(:,n) = x_(:,n) + Pn_(:,:,n) * H' * inv(S(:,:,n)) * (y(:,n) - H * x_(:,n));
    Pn(:,:,n) = Pn_(:,:,n) - Pn_(:,:,n) * H' * inv(S(:,:,n)) * H *Pn_(:,:,n);
    
end


figure()
plot(x_update(1, 1 : end), x_update(2, 1 : end),'k-');
hold on;
plot(x(1, 1 : end), x(2, 1 : end),'r--');
title("predicted x")

%EXTENDED KALMAN FILTER

for n = 2:m;
    %Predict
    Pn_(:,:,n) = A * Pn(:,:,n-1) * A' + Q;
    x_(:,n) = A * x_update(:,n-1);
    J =[2*(x_(1, n-1)-c1(1)) 2*(x_(1, n-1)-c1(2)) 0 0; 2*(x_(2, n-1)-c2(1)) 2*(x_(2, n-1)-c2(2)) 0 0];
    
    %Update
    S(:,:,n) = J * Pn_(:,:,n) * J' + I;
    x_update(:,n) = x_(:,n) + Pn_(:,:,n) * J' * inv(S(:,:,n)) * (z(:,n) - J * x_(:,n));
    Pn(:,:,n) = Pn_(:,:,n) - Pn_(:,:,n) * J' * inv(S(:,:,n)) * J *Pn_(:,:,n);
    
    
end


figure()
plot(x_update(1, 1 : end), x_update(2, 1 : end),'k-');
hold on;
plot(x(1, 1 : end), x(2, 1 : end),'r--');
title("predicted x")

