Pn = zeros(4, 4, m);
Pn_ =  zeros(4, 4, m);
x_ = zeros(4, m);
x_update = zeros(4, m);
R = zeros(2, 2);
S = zeros(2, 2, m);

P0 = diag([sigma0, sigma0, sigma0, sigma0]);

Pn(:, :, 1) = P0

for n = 2:m;
   
end
