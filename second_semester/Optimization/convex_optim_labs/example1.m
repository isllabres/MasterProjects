n = 4;
m = 10; 
A = rand(m,n);
Q = rand(n,n);
b = ones(m,1);
c = ones(n,1);

cvx_begin
 variable x(n)
 minimize(c' * x)
 subject to 
  A * x <= b;
cvx_end

%% 
cvx_begin
 variables x(1) y(1)
 minimize(x+y)
 subject to 
  x >= 1
  y == 2
cvx_end

%%
cvx_begin
 variables x(n)
 minimize(x'*Q*x)
 subject to 
  for i=1:m
      a(:,i)'*x <= b(i)
  end
cvx_end

