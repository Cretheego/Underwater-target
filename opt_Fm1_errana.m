%% 
clear all
%蛙人磁矩
%Fm = [32,7, 12];
M = [2,2,2]*1;

%目标磁矩分量初始值
M0 = [1,1,1]*1;
L0 = [10,10,10];


%传感器坐标
P1 = [0, 0, 0];
P2 = [3, 0, 0];

%产生轨迹数据
T=1;
F0 =[M0;L0];
%options=optimset('Display','iter','LargeScale','off','Algorithm','Levenberg-Marquardt');
options=optimset('LargeScale','off','Algorithm','Levenberg-Marquardt');
SNR=25;

%输出到文件
result_file=fopen('E:\磁场建模\定位方法\仿真\result.txt','w+');

sheet=1;
ms=zeros(100,3);
alpha = 10*pi/180;
belta = 10*pi/180;
gama  = 15*pi/180;
R1_1 = R1(alpha,belta,gama);

for n=1:100
    %误差设置
    %位置误差
    deltaL1 = 1*normrnd(0,(0.05)/3,1,3);
    deltaL2 = 1*normrnd(0,(0.05)/3,1,3);
    %角度误差
    dA = 1*normrnd(0,(2*pi/180)/3,1,3);
    %三轴误差
    dAE1 = 1*normrnd(0,(0.1*pi/180)/3,1,3);
    dAE2 = 1*normrnd(0,(0.1*pi/180)/3,1,3);
    
    R_1=R1(alpha+dA(1),belta+dA(2),gama+dA(3));
    R_21=R2(dAE1(1),dAE1(2),dAE1(3));
    R_22=R2(dAE2(1),dAE2(2),dAE2(3));
    for k=-5:1:5
        t=1;
        for j=-5:1:5
            %坐标
            Ft(t,1)=k;
            Ft(t,2)=j;
            Ft(t,3)=5;

            %产生传感器数据
            [Inx1(t,:), r1(t)] = intensiity(Ft(t,:),P1+deltaL1,[M(1),0,0]);
            [Iny1(t,:), r1(t)] = intensiity(Ft(t,:),P1+deltaL1,[0,M(2),0]);
            [Inz1(t,:), r1(t)] = intensiity(Ft(t,:),P1+deltaL1,[0,0,M(3)]);
            In1c(t,:)=Inx1(t,:)+Iny1(t,:)+Inz1(t,:);
            %In1(t,:) = In1c(t,:)+0.05*randn(1,3);
            In1(t,:)=awgn(In1c(t,:)*R_21,SNR);
            [Inx2(t,:), r2(t)] = intensiity(Ft(t,:),P2+deltaL2,[M(1),0,0]);
            [Iny2(t,:), r2(t)] = intensiity(Ft(t,:),P2+deltaL2,[0,M(2),0]);
            [Inz2(t,:), r2(t)] = intensiity(Ft(t,:),P2+deltaL2,[0,0,M(3)]);
            %In2(t,:) = Inx2(t,:)+Iny2(t,:)+Inz2(t,:)+0.05*randn(1,3);
            In2c(t,:)=Inx2(t,:)+Iny2(t,:)+Inz2(t,:);
            In2(t,:)=awgn(In2c(t,:)*R_1*R_22,SNR);
            %求解
            %save('data.mat', 'P1','P2','In1', 'In2');%In1*10^9;In2*10^9];
            [F,fval]= fsolve(@myfun1,F0,options,P1,P2,In1(t,:),In2(t,:),R1_1,eye(3));
            Ms(:,t)=F(1,:)';
            Ls(:,t)=F(2,:)';
            F0 = 0.1+[F(1,:);F(2,:)];%初值

            errM = (F(1,:)-M0)./M0;
            errF = (F(2,:)-Ft(t,:))./Ft(t,:);
            %fprintf(result_file,'%4.2f %4.2f %4.2f\r\n',errM(1),errM(2),errM(3));
            %fprintf(result_file,'%4.2f %4.2f %4.2f\r\n',errF(1),errF(2),errF(3));
            t=t+1;
        end
        %小于10%的认为成功
        stats(k+6,:) = sum(abs((Ls-Ft')./Ft')<0.1,2)/(t-1);   
    end
    
    ms(n,:)=mean(stats);
    n
end 
xlswrite('E:\磁场建模\定位方法\仿真\stats.xls',stats);
fclose(result_file);
mean(ms)
figure(1)
plot(Ls(1,:));
hold on
plot(Ft(:,1));
hold off
figure(2)
plot(Ft(:,1));
Ls
Ft'
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

