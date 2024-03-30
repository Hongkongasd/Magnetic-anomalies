%% importdata
clear; clc;
u=4*pi*1e-7; 
fs=1000;
d=0.33;
E1=load('H:\湛江\0323\区域1\后\01.txt');
% E1=E1(30242:end,:);
%%
test=lowpass(E1,1,1000);
test=highpass(E1,0.007,1000);
B_targets(:,1:24)=E1(1:end,1:24)*1e-9;  %有目标磁场，单位T
B_targets(:,25)=E1(1:end,25)./1000; %单位m

B_target=meihaomi_jiguang(B_targets);
% B_target=B_targets;

save B_target.txt -ascii B_target


%%  8个磁通门探测值
B1=B_target(:,1:3);B2=B_target(:,4:6);B3=B_target(:,7:9);B4=B_target(:,10:12);
B5=B_target(:,13:15);B6=B_target(:,16:18);B7=B_target(:,19:21);B8=B_target(:,22:24);
CT=zeros(length(B_target(:,1)),6);
%% 磁梯度张量
[Bxx,Bxy,Bxz,Byy,Byz,Bzz,ct]=gradient(d,B1,B2,B3,B4,B5,B6,B7,B8);  %计算磁梯度张量
Bzz=Bzz(1:end);
Bxx=Bxx(1:end);
Bxy=Bxy(1:end);
Bxz=Bxz(1:end);
Byy=Byy(1:end);
Byz=Byz(1:end);
ct=ct(1:end); 

save Bxx.txt -ascii Bxx
save Bxy.txt -ascii Bxy
save Bxz.txt -ascii Bxz
save Byy.txt -ascii Byy
save Byz.txt -ascii Byz
save Bzz.txt -ascii Bzz
save ct.txt -ascii ct
%% 绘图
figure
plot(B_target(1:end,25),Bxx(:,1)*1e9,'r','linewidth',1.2)
hold on
plot(B_target(1:end,25),Bxy(:,1)*1e9,'b','linewidth',1.2)
plot(B_target(1:end,25),Bxz(:,1)*1e9,'g','linewidth',1.2)
plot(B_target(1:end,25),Byy(:,1)*1e9,'k','linewidth',1.2)
plot(B_target(1:end,25),Byz(:,1)*1e9,'linewidth',1.2)
plot(B_target(1:end,25),Bzz(:,1)*1e9,'linewidth',1.2)
plot(B_target(1:end,25),ct*1e9,'linewidth',1.2)
ylabel('nT/m')
legend('Bxx','Bxy','Bxz','Byy','Byz','Bzz','CT')
set(gca,'unit','centimeter','position',[2 2 8 6])



% figure()
% plot(B3(:,3)-B8(:,3))

%%
 x0=zeros(6,1);
% X0(3,:)=3
lb = [];
ub = [];
options = optimoptions('lsqnonlin','Display','iter');
options.Algorithm = 'levenberg-marquardt';
[Y, ~] = lsqnonlin(@fm,x0,lb,ub,options);     % 调用LM函数

