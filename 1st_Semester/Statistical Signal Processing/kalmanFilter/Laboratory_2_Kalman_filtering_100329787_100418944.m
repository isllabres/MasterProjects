close all;
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
c1 = [0; 100];
c2 = [-100; 0];

%Set the initial points for v and r

v = zeros(2, m);
r = zeros(2, m);
x = zeros(4, m);
x(:,1) = randn([4 1]) * sqrt(sigma0);
y(:,1) = H * x(:, 1) + (sqrt(I) * randn([2 1]));

l = (sqrt(I) * randn([2 1]));

z(1, 1) = norm(x(1:2, 1) - c1) + l(1, 1);
z(2, 1) = norm(x(1:2, 1) - c2) + l(2, 1);

%Variables for Kalman filter

Pn = zeros(4, 4, m);
Pn_ =  zeros(4, 4, m);
x_ = zeros(4, m);
x_update = zeros(4, m);
R = zeros(2, 2);
S = zeros(2, 2, m);

Pne=  zeros(4, 4, m);
Pn_e =  zeros(4, 4, m);
x_e = zeros(4, m);
x_update_e = zeros(4, m);
h = zeros(2, m);
Re = zeros(2, 2);
Se = zeros(2, 2, m);

P0 = diag([sigma0, sigma0, sigma0, sigma0]);

T = 1/2;


Pn(:, :, 1) = P0;

% Define the vectors for MSE
MSE_pos = zeros(K, m);
MSE_v = zeros(K, m);
MSE_pose = zeros(K, m);
MSE_ve = zeros(K, m);

%Running 3 iterations

for i = 1:K;
    
    for n = 2:m;

        s = sqrt(Q) * randn([4 1]);
        l = sqrt(I) * randn([2 1]);

        x(:, n) = A * x(:, n - 1) + s;
        y(:, n) = H * x(:, n) + l;

        z(1, n) = norm(x(1:2, n) - c1) + l(1, 1);
        z(2, n) = norm(x(1:2, n) - c2) + l(2, 1);


    end
    figure(1);
   
    subplot(3,3,i);
    plot(x(1, 1 : end), x(2, 1 : end),'k-');
    hold on;    
    plot(c1(1),c1(2),'o');
    plot(c2(1),c2(2),'o');   
    axis([-110 110 -110 110]);
    title([i, "Sample trayectories"]); 
    legend('trayectories','c1', 'c2');
    hold off    
    subplot(3,3,i+3)
    plot(1:m, x(3,1 : m), 'k-');
    hold on;
    legend('velocity X');
    hold off;    
    subplot(3,3,i+6)
    plot(1:m, x(4,1 : m), 'r-');
    hold on;
    legend('velocity Y');
    hold off;

    figure(2);
    
    subplot(2,3,i);
    plot(1:m, y(1,1 : m), 'b-');
    hold on;    
    title([i, "Linear observations"]);   
    legend('component X');
    hold off;    
    subplot(2,3,i+3);
    plot(1:m, y(2,1 : m), 'r-');
    hold on;
    legend('component Y');
    hold off;

    figure(3);
    
    subplot(2,3,i);
    plot(1:m, z(1,1:m), 'b--');
    hold on;
    title([i, "Non-Linear observations"]);   
    legend('component X');
    hold off;    
    subplot(2,3,i+3);
    plot(1:m, z(2,1:m), 'r--');
    hold on;
    legend('component Y');
    hold off;
    
    %KALMAN FILTER

    for n = 2:m;
        %Predict
        Pn_(:,:,n) = A * Pn(:,:,n-1) * A' + Q;
        x_(:,n) = A * x_update(:,n-1);

        %Update
        S(:,:,n) = H * Pn_(:,:,n) * H' + I;
        x_update(:,n) = x_(:,n) + Pn_(:,:,n) * H' * inv(S(:,:,n)) * (y(:,n) - H * x_(:,n));
        Pn(:,:,n) = Pn_(:,:,n) - Pn_(:,:,n) * H' * inv(S(:,:,n)) * H *Pn_(:,:,n);

        
        MSE_pos(i, n) = trace(Pn(1:2,1:2,n));
        MSE_v(i, n) = trace(Pn(3:4,3:4,n));
    end
    
    figure(4)
    subplot(3,1,i)
    plot(x_update(1, 1 : end), x_update(2, 1 : end),'k-');
    hold on;
    plot(x(1, 1 : end), x(2, 1 : end),'r--');
    title([i, "Kalman filter"]);
    legend('prediction','real');
    hold off;

    %EXTENDED KALMAN FILTER

    for n = 2:m;
        %Predict
        Pn_e(:,:,n) = A * Pne(:,:,n-1) * A' + Q;
        x_e(:,n) = A * x_update_e(:,n-1);
        J =[2*(x_e(1, n)-c1(1)) 2*(x_e(2, n)-c1(2)) 0 0; 
            2*(x_e(1, n)-c2(1)) 2*(x_e(2, n)-c2(2)) 0 0];

        h(:,n)= [norm(x_e(1:2, n)' - c1);  norm(x_e(1:2, n)' - c2)];
        y(:,n) = h(:,n)+J*(x(:, n)-x_e(:,n))+l;
        %Update
        Se(:,:,n) = J * Pn_e(:,:,n) * J' + I;
        x_update_e(:,n) = x_e(:,n) + Pn_e(:,:,n) * J' * inv(Se(:,:,n)) * (y(:,n) - h(:,n));
        Pne(:,:,n) = Pn_e(:,:,n) - Pn_e(:,:,n) * J' * inv(Se(:,:,n)) * J *Pn_e(:,:,n);
        
        MSE_pose(i, n) = trace(Pne(1:2,1:2,n));
        MSE_ve(i, n) = trace(Pne(3:4,3:4,n));

    end
    
    figure(5)
    subplot(3,1,i)
    plot(x_update_e(1, 1 : end), x_update_e(2, 1 : end),'k-');
    hold on;
    plot(x(1, 1 : end), x(2, 1 : end),'r--');
    title([i, "Extended Kalman filter"]);
    legend('prediction','real');
    hold off;    


    figure(6);
    subplot(2, 3, i);
    plot(MSE_pos(i, :),'r-');
    axis([0 m -1 2]);
    hold on;
    title([i, "Kalman filter pos MSE"]);
    subplot(2, 3, i+3);
    plot(MSE_v(i, :),'b-');
    axis([0 m -1 2]);
    title([i, "Kalman filter vel MSE"]);
    hold off;    
    
    figure(7);
    subplot(2, 3, i);
    plot(MSE_pose(i, :),'r-');
    axis([0 m -0.5 0.5]);
    hold on;
    title([i, "E-Kalman filter pos MSE"]);
    subplot(2, 3, i+3);
    plot(MSE_ve(i, :),'b-');
    axis([0 m -1 2]);
    title([i, "E-Kalman filter vel MSE"]);
    hold off;   

end