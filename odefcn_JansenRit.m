function [dt] = odefcn_JansenRit(t, x, u, A, B, a, b, C1, C2, C3, C4, Fs,v0)
p= u(1+floor(t*Fs));
dt = zeros(6,1);
dt(1) = x(4);
dt(2) = x(5);
dt(3) = x(6); 
dt(4) = A * a * Sigm(x(2) - x(3),v0)    - 2 * a * x(4) - a^2 * x(1);
dt(5) = A * a * (p+C2*Sigm(C1*x(1),v0)) - 2 * a * x(5) - a^2 * x(2);
dt(6) = B * b * C4 * Sigm(C3 * x(1),v0) - 2 * b * x(6) - b^2 * x(3);




