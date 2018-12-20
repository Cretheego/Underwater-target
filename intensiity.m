function [In,r] = intensiity(X0,X1,M)
x = X1(1);
y = X1(2);
z = X1(3);

x0 = X0(1);
y0 = X0(2);
z0 = X0(3);
m = M(1);
n = M(2);
p = M(3);

%空气中的磁导率
u0=4*pi*10^(-7);%H/m
S = 10^9;
r = sqrt((x-x0)^2+(y-y0)^2+(z-z0)^2);
% Inx = u0/(4*pi)*(3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(x-x0)/r^5-m/r^3);
% Iny = u0/(4*pi)*(3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(y-y0)/r^5-n/r^3);
% Inz = u0/(4*pi)*(3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(z-z0)/r^5-p/r^3);
Inx = u0/(4*pi*r^3)*(S*3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(x-x0)/r^2-S*m);
Iny = u0/(4*pi*r^3)*(S*3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(y-y0)/r^2-S*n);
Inz = u0/(4*pi*r^3)*(S*3*(m*(x-x0)+n*(y-y0)+p*(z-z0))*(z-z0)/r^2-S*p);

In = [Inx,Iny,Inz];