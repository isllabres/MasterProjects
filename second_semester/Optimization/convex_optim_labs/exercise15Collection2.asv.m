n = 2;

A = [0.5 -0.7; -0.8 -1.9; 2.1 1.3];
b = [1; 1; 1];
c = [0.1;1.2];

u = norm(b, 2);
l = -1;

for i=1:1
   t= (u+l)/2;
   
   cvx_begin
    variables x(n)
    minimize 1
    subject to
       norm(A*x-b, 2) - t*(1+c'*x) <= 0
       1+c' * x > 0
   cvx_end

   cvx_optval
%    cvx_status

   if(cvx_optval == 1)
       u=t;
       xstar = x
   else
    l=t;
   end
end 