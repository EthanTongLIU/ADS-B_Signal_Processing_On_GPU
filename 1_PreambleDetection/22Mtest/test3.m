clear, clc;
close all;

load( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\data2_analytic.mat' );
startPos = 100;
stepWidth = 26e4;
% 手动确定信号位置
% data1   = data2_analytic(startPos                  + 1 : startPos +      stepWidth); % 1.039e5, 60(not adsb); 2.336e5, 60(not adsb);
% data2   = data2_analytic(startPos +      stepWidth + 1 : startPos + 2  * stepWidth); % 0.92e4, 82(not adsb);
% data3   = data2_analytic(startPos + 2  * stepWidth + 1 : startPos + 3  * stepWidth); % 2.405e5, 140(is adsb, useless);
% data4   = data2_analytic(startPos + 3  * stepWidth + 1 : startPos + 4  * stepWidth); % 9.84e4, 68(is adsb) NO1;
% data5   = data2_analytic(startPos + 4  * stepWidth + 1 : startPos + 5  * stepWidth); % 117184, 100(is adsb) NO2;
data6   = data2_analytic(startPos + 5  * stepWidth + 1 : startPos + 6  * stepWidth); % 5.075e4, 85(is adsb, 报头失真较严重, 未检测出来) NO3; 175874, 65(is adsb) NO4; 184819, 55(is absb) NO5; 228319, 65(is adsb) NO6;
% data7   = data2_analytic(startPos + 6  * stepWidth + 1 : startPos + 7  * stepWidth); % 4.4e4, 140(is adsb, useless); 8.8e4, 140(is adsb, useless); 1.858e5, 100(not adsb); 2.565e5, 55(is adsb) NO7;
% data8   = data2_analytic(startPos + 7  * stepWidth + 1 : startPos + 8  * stepWidth); % 1.29e5, 50(is adsb) NO8;
% data9   = data2_analytic(startPos + 8  * stepWidth + 1 : startPos + 9  * stepWidth); % 1.794e5, 70(is adsb) NO9; 2.1955e5, 65(is adsb) NO10;
% data10  = data2_analytic(startPos + 9  * stepWidth + 1 : startPos + 10 * stepWidth); % 5210, 60(is adsb) NO11; 4.655e4, 85(is absb) NO12; 5.43e4, 75(not adsb) NO13;
% 前 26e5 个序列共 13 条有效 ADS-B 报文

% startPos = startPos + 26e5; % 大循环步长
% data = data2_analytic(startPos + 1 : startPos + 10 * stepWidth);

stem(1 : length(data6), data6);
hold on;
stem(228319 + 1 : 228319 + 2640, data6(228319 + 1 : 228319 + 2640), 'color', 'r');
stem(175874 + 1 : 175874 + 2640, data6(175874 + 1 : 175874 + 2640), 'color', 'r');
stem(184819 + 1 : 184819 + 2640, data6(184819 + 1 : 184819 + 2640), 'color', 'r');
title('data6 段信号序列');
xlabel('点数');
ylabel('Amplitude');
axis([0 26e4 0 120]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 0:1e4:26e4, 'ytick', 0:30:120, 'fontsize', 13);

% Objective: 从 data6 中提取出 adsb 信号
% Demand:    1. 需要动态生成门限
%            2. 准确提取上升沿
%            3. 排除虚假报头 

preambleTemp = [ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 44) ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 66)];

s = length(data6);
m = length(preambleTemp);

R = zeros(1, s - m +1);
num = 0;
for i = 1 : s - m + 1
    thresCurrent = 7 * 11 * mean(data6(i : i + m - 1));
    R(i) = dot(preambleTemp, data6(i : i + m - 1));
    if R(i) >= thresCurrent
        num = num + 1;
        disp(['位置 ', num2str(i), ' R ', num2str(R(i))]);
    end
end
disp(['数量 ', num2str(num)]);
figure;
stem(R);
hold on;
title('卷积');
xlabel('点数');
ylabel('Amplitude');
axis([1 26e4 0 4000]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 1:2e4:26e4, 'ytick', 0:500:4000, 'fontsize', 13);
