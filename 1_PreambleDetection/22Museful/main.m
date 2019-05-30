clear, clc;
close all;
format long;

% % >>> 读入数据 <<<
% dataCH6 = readFile( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\TEST6ch22M.dat' );
% data1 = dataCH6( 1 , : ) + 2048; % 分离出一个通道的数据
% 
% % >>> 对数据进行 Hilbert 变换 <<<
% data1_analytic = abs( hilbert( data1 ) );

% >>> 直接加载已完成转换的数据 <<<
load( 'C:\Users\刘通\Desktop\data2_analytic.mat' );
% load( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\data2_analytic.mat' );

% >>> 筛选出一段数据 <<<
startPos = 100;
stepWidth = 26e4;
data = data2_analytic( startPos + 0 * stepWidth + 1 : startPos + 9 * stepWidth );

% % >>> 报头检测（提取报头位置） <<<
preambleTemp = [ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 44) ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 66)];

s = length(data);
m = length(preambleTemp);

R = zeros(1, s - m +1);

% 恒虚警自适应门限提取报头（抗噪）
% 填充存储 adsb 位置信息的数组的第 1 个数据
lambda = 0.4;
secondStart = 0;
adsbR = [];
adsbPos = [];
lastPos = 0;
for i = 1 : s - m + 1
    thresCurrent = lambda * mean(data(i : i + m - 1));
    R(i) = 1.0 / m * preambleTemp * data(i : i + m - 1)';
    if R(i) >= thresCurrent
        adsbR(1) = R(i);
        adsbPos(1) = i;
        lastPos = i;
        secondStart = i + 1;
        break;
    end
end

% 从连续位置中筛选出相关系数最大的
k = 2;
for i = secondStart : s - m + 1
    thresCurrent = lambda * mean(data(i : i + m - 1));
    R(i) = 1.0 / m * preambleTemp * data(i : i + m - 1)';
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

disp(['初选数量 ', num2str(length(adsbPos))]);

% 进行抗干扰处理（去除杂波干扰）

% 步骤1：双卷积次选
temp1 = [preambleTemp  ones(1, 112 * 2 * 11)];
temp2 = [preambleTemp zeros(1, 112 * 2 * 11)];

adsbPos2 = [];
k = 0;
for i = 1 : length(adsbPos)
    r1 = dot(temp1, data(adsbPos(i) : adsbPos(i) + 2640 - 1));
    r2 = dot(temp2, data(adsbPos(i) : adsbPos(i) + 2640 - 1));
    if r1 / r2 >= 29
        k = k + 1;
        adsbPos2(k) = adsbPos(i);
    end
end

disp(['次选数量 ', num2str(length(adsbPos2))]);

% 步骤2：报头脉冲波形简单匹配
adsbPos3 = [];
id3 = 0;
zerosNum = 6;
for i = 1 : length(adsbPos2)
    frame_possible = data(adsbPos2(i) : adsbPos2(i) + 2640 - 1);
    preFrt = [frame_possible(6) frame_possible(6 + 11) frame_possible(6 + 22) frame_possible(6 + 33) frame_possible(6 + 66) frame_possible(6 + 77) frame_possible(6 + 88) frame_possible(6 + 99)];
    preAft = zeros(1, 4);
    for j = 1 : 4
        if preFrt(2 * (j - 1) + 1) > preFrt(2 * (j - 1) + 2)
            preAft(j) = 1;
        end
    end
    if isequal(preAft, [1 1 0 0])
       id3 = id3 + 1;
       adsbPos3(id3) = adsbPos2(i);
    end
end

disp(['三选数量 ', num2str(length(adsbPos3))]);

% % DF 验证
% adsbPos3 = [];
% id3 = 0;
% for i = 1 : length(adsbPos2)
%     frame_possible = data(adsbPos2(i) + 176 : adsbPos2(i) + 2640 - 1); 
%     df_bin_frame = zeros( 1 , 5 );
%     % 将 DF 字段转码为 2 进制序列
%     for k = 1 : 5
%         front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % 取出每微秒内的序列
%         front = front_and_after( 1 : 11 );
%         front_mean = mean( front );
%         after = front_and_after( 12 : 22 );
%         after_mean = mean( after );    
%         if front_mean > after_mean
%             df_bin_frame(k) = 1;
%         else
%             df_bin_frame(k) = 0;
%         end
%     end
%     % 求 DF 的值
%     df_format = 0;
%     for k = 1 : 5
%         df_format = df_format + df_bin_frame(k) * 2^(5-k);
%     end
%     if ( df_format == 16 || df_format == 17 || df_format == 18 )
%        id3 = id3 + 1;
%        adsbPos3(id3) = adsbPos2(i);
%     end
% end
% 
% disp(['三选数量 ', num2str(length(adsbPos3))]);

figure;
subplot(3, 1, 1);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos)
    sigPos = adsbPos(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('初选');
xlabel('点数');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

subplot(3, 1, 2);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos2)
    sigPos = adsbPos2(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('次选');
xlabel('点数');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

subplot(3, 1, 3);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos3)
    sigPos = adsbPos3(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('三选');
xlabel('点数');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % 获取屏幕尺寸
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

% >>> 译码 <<<


% % >>> 解码 <<<
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end