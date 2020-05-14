Pn = zeros(4, 4, m);
Pn_ =  zeros(4, 4, m);
x_ = zeros(4, m);
x_update = zeros(4, m);
R = zeros(2, 2);
S = zeros(2, 2, m);

P0 = diag([sigma0, sigma0, sigma0, sigma0]);

H = [1 -0.3 0 0; -0.2 -1 0 0];
T = 1/2;
A = [1 0 T 0; 0 1 0 T; 0 0 1 0; 0 0 0 1];

sigma0 = 1/5;
sigmaU = 1/10;
sigmaW = 1/2;
sigmaL = 1;
Q = diag([sigmaW, sigmaW, sigmaU, sigmaU]);
I = diag([1, 1]);

Pn(:, :, 1) = P0

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