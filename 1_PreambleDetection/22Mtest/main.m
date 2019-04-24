clear, clc;
close all;

load( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\data2_analytic.mat' );
startPos = 100;
stepWidth = 26e4;
% 手动确定信号位置
% data1   = data2_analytic(startPos                  + 1 : startPos +      stepWidth); % 1.039e5, 60(not adsb); 2.336e5, 60(not adsb);
% data2   = data2_analytic(startPos +      stepWidth + 1 : startPos + 2  * stepWidth); % 0.92e4, 82(not adsb);
% data3   = data2_analytic(startPos + 2  * stepWidth + 1 : startPos + 3  * stepWidth); % 2.405e5, 140(is adsb, useless);
data4   = data2_analytic(startPos + 3  * stepWidth + 1 : startPos + 4  * stepWidth); % 9.84e4, 68(is adsb) NO1;
% data5   = data2_analytic(startPos + 4  * stepWidth + 1 : startPos + 5  * stepWidth); % 1.172e5, 100(is adsb) NO2;
% data6   = data2_analytic(startPos + 5  * stepWidth + 1 : startPos + 6  * stepWidth); % 5.075e4, 85(is adsb) NO3; 1.7587e5, 65(is adsb) NO4; 1.8482e5, 55(is absb) NO5; 2.283e5, 65(is adsb) NO6;
% data7   = data2_analytic(startPos + 6  * stepWidth + 1 : startPos + 7  * stepWidth); % 4.4e4, 140(is adsb, useless); 8.8e4, 140(is adsb, useless); 1.858e5, 100(not adsb); 2.565e5, 55(is adsb) NO7;
% data8   = data2_analytic(startPos + 7  * stepWidth + 1 : startPos + 8  * stepWidth); % 1.29e5, 50(is adsb) NO8;
% data9   = data2_analytic(startPos + 8  * stepWidth + 1 : startPos + 9  * stepWidth); % 1.794e5, 70(is adsb) NO9; 2.1955e5, 65(is adsb) NO10;
% data10  = data2_analytic(startPos + 9  * stepWidth + 1 : startPos + 10 * stepWidth); % 5210, 60(is adsb) NO11; 4.655e4, 85(is absb) NO12; 5.43e4, 75(not adsb) NO13;
% 前 26e5 个序列共 13 条有效 ADS-B 报文

% startPos = startPos + 26e5; % 大循环步长
% data = data2_analytic(startPos + 1 : startPos + 10 * stepWidth);

stem(1 : length(data4), data4);
hold on;
stem(98410 + 1 : 98410 + 2640, data4(98410 + 1 : 98410 + 2640), 'color', 'r');
title('data4 段信号序列');
xlabel('点数');
ylabel('Amplitude');
axis([0 26e4 0 90]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 0:1e4:26e4, 'ytick', 0:30:90, 'fontsize', 13);

% Objective: 从 data4 中提取出 adsb 信号
% Demand:    1. 需要动态生成门限
%            2. 双卷积排除虚假报头 

adsbSeq = data4(98410 + 1 : 98410 + 2640);
figure;
hold on;
t0 = linspace(0, 120, 2640);
stem(t0, adsbSeq);
title('ADS-B 信号序列');
xlabel('Time(\mus)');
ylabel('Amplitude');
axis([-20 140 0 90]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 0:4:120, 'ytick', 0:30:90, 'fontsize', 13);

mean4FrontPulse = mean([adsbSeq(11 * 0 + 1 : 11 * 0 + 11) adsbSeq(11 * 2 + 1 : 11 * 2 + 11) adsbSeq(11 * 7 + 1 : 11 * 7 + 11) adsbSeq(11 * 9 + 1 : 11 * 9 + 11)])
plot([-20 140], [mean4FrontPulse mean4FrontPulse], 'color', 'r');

preambleTemp = [ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 44) ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 66)];
temp1 = [preambleTemp  ones(1, 112 * 2 * 11)];
temp2 = [preambleTemp zeros(1, 112 * 2 * 11)];

r1 = dot(temp1, adsbSeq)
r2 = dot(temp2, adsbSeq)
r1/r2

s = length(data4);
n = length(adsbSeq);
m = length(preambleTemp);

R1 = zeros(1, s - n + 1);
R2 = zeros(1, s - n + 1);
num = 0;
for i = 1 : s - n + 1
    R1(i) = dot(temp1, data4(i : i + n - 1));
    R2(i) = dot(temp2, data4(i : i + n - 1));
    if (R1(i)/R2(i) >= 30)
       num = num + 1;
    end
end
disp('数量');
disp(num);