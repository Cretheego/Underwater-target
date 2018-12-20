clear all
%传感器坐标
P1 = [0, 0, 0];
P2 = [2, 0, 0];
%蛙人坐标
%Fm = [32,7, 12];
M = [0.6,0.25,0.7];

%蛙人磁矩分量初始值
M0 = [0.1,0.1,0.1];
L0 = [-1,-1,-1];

%产生轨迹数据
T=1;
F0 =[M0;L0];
options=optimset('Display','iter','LargeScale','off','Algorithm','Levenberg-Marquardt');
%options=optimset('Display','iter','LargeScale','on','Algorithm','Levenberg-Marquardt');
%options=optimset('LargeScale','off','Algorithm','Levenberg-Marquardt');
SNR=20;
t=1;
for k=1:0.5:25
    Ft(t,1)=k/2.5-5;
    Ft(t,2)=-k/2.5+5;
    Ft(t,3)=2;
    
    %产生传感器数据
    [Inx1(t,:), r1(t)]= intensiity(Ft(t,:),P1,[M(1),0,0]);
    [Iny1(t,:), r1(t)] = intensiity(Ft(t,:),P1,[0,M(2),0]);
    [Inz1(t,:), r1(t)] = intensiity(Ft(t,:),P1,[0,0,M(3)]);
    In1c(t,:)=Inx1(t,:)+Iny1(t,:)+Inz1(t,:);
    %In1(t,:) = In1c(t,:)+0.05*randn(1,3);
    In1(t,:)=awgn(In1c(t,:),SNR);
    [Inx2(t,:), r2(t)] = intensiity(Ft(t,:),P2,[M(1),0,0]);
    [Iny2(t,:), r2(t)] = intensiity(Ft(t,:),P2,[0,M(2),0]);
    [Inz2(t,:), r2(t)] = intensiity(Ft(t,:),P2,[0,0,M(3)]);
    %In2(t,:) = Inx2(t,:)+Iny2(t,:)+Inz2(t,:)+0.05*randn(1,3);
    In2c(t,:)=Inx2(t,:)+Iny2(t,:)+Inz2(t,:);
    In2(t,:)=awgn(In2c(t,:),SNR);
    %求解
    %save('data.mat', 'P1','P2','In1', 'In2');%In1*10^9;In2*10^9];
    [F,fval]= fsolve(@myfun1,F0,options,P1,P2,In1(t,:),In2(t,:));
    Ms(:,t)=F(1,:)';
    Ls(:,t)=F(2,:)';
    F0 = 0.1+[F(1,:);F(2,:)];
    t=t+1;
end
figure(1)
plot(Ls(1,:));
hold on
plot(Ft(:,1));
hold off
figure(2)
plot(Ft(:,1));
Ls-Ft'
sum((Ls(:,18:34)-Ft(18:34,:)'),2)./sum(Ft(18:34,:))'

figure(3)
subplot(211)
plot(r1);
subplot(212)
plot(r2);
figure(4)
%subplot(211)
plot(In1c(:,1),'r.');
hold on 
plot(In1(:,1),'k+');
hold off
legend('真实信号','带噪信号');
%subplot(212)
%plot(In1-In1c);
figure(5)
plot(sum((Ms)))

