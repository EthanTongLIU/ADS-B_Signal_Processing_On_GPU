clear, clc;
close all;

load( 'D:\1_Work\Y_�о������⣨2018��12������\3_L�����źŴ���ϵͳ\0_Data\3_6ChannelData_22M\data2_analytic.mat' );
startPos = 100;
stepWidth = 26e4;
% �ֶ�ȷ���ź�λ��
% data1   = data2_analytic(startPos                  + 1 : startPos +      stepWidth); % 1.039e5, 60(not adsb); 2.336e5, 60(not adsb);
% data2   = data2_analytic(startPos +      stepWidth + 1 : startPos + 2  * stepWidth); % 0.92e4, 82(not adsb);
% data3   = data2_analytic(startPos + 2  * stepWidth + 1 : startPos + 3  * stepWidth); % 2.405e5, 140(is adsb, useless);
% data4   = data2_analytic(startPos + 3  * stepWidth + 1 : startPos + 4  * stepWidth); % 9.84e4, 68(is adsb) NO1;
% data5   = data2_analytic(startPos + 4  * stepWidth + 1 : startPos + 5  * stepWidth); % 117184, 100(is adsb) NO2;
% data6   = data2_analytic(startPos + 5  * stepWidth + 1 : startPos + 6  * stepWidth); % 5.075e4, 85(is adsb, ��ͷʧ�������, δ������) NO3; 175874, 65(is adsb) NO4; 184819, 55(is absb) NO5; 228319, 65(is adsb) NO6;
% data7   = data2_analytic(startPos + 6  * stepWidth + 1 : startPos + 7  * stepWidth); % 4.4e4, 140(is adsb, useless); 8.8e4, 140(is adsb, useless); 185822, 100(not adsb); 2.565e5, 55(is adsb) NO7;
% data8   = data2_analytic(startPos + 7  * stepWidth + 1 : startPos + 8  * stepWidth); % 129005, 50(is adsb) NO8;
% data9   = data2_analytic(startPos + 8  * stepWidth + 1 : startPos + 9  * stepWidth); % 179342, 70(is adsb) NO9; 2.1955e5, 65(is adsb, ���޵�Ϊ6���Լ�����) NO10;
data10  = data2_analytic(startPos + 9  * stepWidth + 1 : startPos + 10 * stepWidth); % 5221, 60(is adsb) NO11; 46557, 85(is absb) NO12; 54310, 75(not adsb);
% ǰ 26e5 �����й� 13 ����Ч ADS-B ����

% startPos = startPos + 26e5; % ��ѭ������
% data = data2_analytic(startPos + 1 : startPos + 10 * stepWidth);

stem(1 : length(data10), data10);
hold on;
sigPos =   5221; stem(sigPos + 1 : sigPos + 2640, data10(sigPos + 1 : sigPos + 2640), 'color', 'r');
sigPos =  46557; stem(sigPos + 1 : sigPos + 2640, data10(sigPos + 1 : sigPos + 2640), 'color', 'r');
sigPos =  49151; stem(sigPos + 1 : sigPos + 2640, data10(sigPos + 1 : sigPos + 2640), 'color', 'r');
sigPos =  54310; stem(sigPos + 1 : sigPos + 2640, data10(sigPos + 1 : sigPos + 2640), 'color', 'r');
sigPos = 134529; stem(sigPos + 1 : sigPos + 2640, data10(sigPos + 1 : sigPos + 2640), 'color', 'r');
title('data10 ���ź�����');
xlabel('����');
ylabel('Amplitude');
axis([0 26e4 0 120]);
scrsz = get(0,'ScreenSize'); % ��ȡ��Ļ�ߴ�
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 0:1e4:26e4, 'ytick', 0:30:120, 'fontsize', 13);

% Objective: �� data10 ����ȡ�� adsb �ź�
% Demand:    1. ��Ҫ��̬��������
%            2. ׼ȷ��ȡ������
%            3. �ų���ٱ�ͷ 

preambleTemp = [ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 44) ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 66)];

s = length(data10);
m = length(preambleTemp);

R = zeros(1, s - m +1);

% ���洢 adsb λ����Ϣ������ĵ� 1 ������
secondStart = 0;
adsbR = [];
adsbPos = [];
lastPos = 0;
for i = 1 : s - m + 1
    thresCurrent = 7 * 11 * mean(data10(i : i + m - 1));
    R(i) = dot(preambleTemp, data10(i : i + m - 1));
    if R(i) >= thresCurrent
        adsbR(1) = R(i);
        adsbPos(1) = i;
        lastPos = i;
        secondStart = i + 1;
        break;
    end
end

% ������λ����ɸѡ�����ϵ������
k = 2;
for i = secondStart : s - m + 1
    thresCurrent = 7 * 11 * mean(data10(i : i + m - 1));
    R(i) = dot(preambleTemp, data10(i : i + m - 1));
    if R(i) >= thresCurrent
        if i == lastPos + 1
            if R(i) > adsbR(k - 1)
                adsbR(k - 1) = R(i);
                adsbPos(k - 1) = i;
                lastPos = i;
            else
                lastPos = lastPos + 1;
                continue;
            end
        else
            adsbR(k) = R(i);
            adsbPos(k) = i;
            lastPos = i;
            k = k + 1;
        end
    end
end

disp(['���� ', num2str(length(adsbPos))]);

figure;
stem(R);
hold on;
title('���');
xlabel('����');
ylabel('Amplitude');
axis([1 26e4 0 3000]);
scrsz = get(0,'ScreenSize'); % ��ȡ��Ļ�ߴ�
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', 1:2e4:26e4, 'ytick', 0:500:3000, 'fontsize', 13);
