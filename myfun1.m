 function F = myfun1(F0,P1,P2,In1,In2,R1,R2) 
%P1 = [30, 10,16];
%P2 = [35.2,10.4,15.8];
%load('data.mat');  %#ok<LOAD>
M = F0(1,:);
%{
x1 = P1(1);
y1 = P1(2);
z1 = P1(3);
x2 = P2(1);
y2 = P2(2);
z2 = P2(3);
X0=T(1);
Y0=T(2);
Z0=T(3);
%}
Fm = F0(2,:);
Inx1 = intensiity(Fm,P1,[M(1),0,0]);
Iny1 = intensiity(Fm,P1,[0,M(2),0]);
Inz1 = intensiity(Fm,P1,[0,0,M(3)]);
sen1 = Inx1+Iny1+Inz1;

Inx2 = intensiity(Fm,P2,[M(1),0,0]);
Iny2 = intensiity(Fm,P2,[0,M(2),0]);
Inz2 = intensiity(Fm,P2,[0,0,M(3)]);
sen2 = Inx2+Iny2+Inz2;

F = [sen1*R2 - In1;sen2*R1*R2 - In2]*10^0;