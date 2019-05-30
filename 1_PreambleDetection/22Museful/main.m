clear, clc;
close all;
format long;

% % >>> �������� <<<
% dataCH6 = readFile( 'D:\1_Work\Y_�о������⣨2018��12������\3_L�����źŴ���ϵͳ\0_Data\3_6ChannelData_22M\TEST6ch22M.dat' );
% data1 = dataCH6( 1 , : ) + 2048; % �����һ��ͨ��������
% 
% % >>> �����ݽ��� Hilbert �任 <<<
% data1_analytic = abs( hilbert( data1 ) );

% >>> ֱ�Ӽ��������ת�������� <<<
load( 'C:\Users\��ͨ\Desktop\data2_analytic.mat' );
% load( 'D:\1_Work\Y_�о������⣨2018��12������\3_L�����źŴ���ϵͳ\0_Data\3_6ChannelData_22M\data2_analytic.mat' );

% >>> ɸѡ��һ������ <<<
startPos = 100;
stepWidth = 26e4;
data = data2_analytic( startPos + 0 * stepWidth + 1 : startPos + 9 * stepWidth );

% % >>> ��ͷ��⣨��ȡ��ͷλ�ã� <<<
preambleTemp = [ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 44) ones(1, 11) zeros(1, 11) ones(1, 11) zeros(1, 66)];

s = length(data);
m = length(preambleTemp);

R = zeros(1, s - m +1);

% ���龯����Ӧ������ȡ��ͷ�����룩
% ���洢 adsb λ����Ϣ������ĵ� 1 ������
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

% ������λ����ɸѡ�����ϵ������
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

disp(['��ѡ���� ', num2str(length(adsbPos))]);

% ���п����Ŵ���ȥ���Ӳ����ţ�

% ����1��˫�����ѡ
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

disp(['��ѡ���� ', num2str(length(adsbPos2))]);

% ����2����ͷ���岨�μ�ƥ��
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

disp(['��ѡ���� ', num2str(length(adsbPos3))]);

% % DF ��֤
% adsbPos3 = [];
% id3 = 0;
% for i = 1 : length(adsbPos2)
%     frame_possible = data(adsbPos2(i) + 176 : adsbPos2(i) + 2640 - 1); 
%     df_bin_frame = zeros( 1 , 5 );
%     % �� DF �ֶ�ת��Ϊ 2 ��������
%     for k = 1 : 5
%         front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % ȡ��ÿ΢���ڵ�����
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
%     % �� DF ��ֵ
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
% disp(['��ѡ���� ', num2str(length(adsbPos3))]);

figure;
subplot(3, 1, 1);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos)
    sigPos = adsbPos(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('��ѡ');
xlabel('����');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % ��ȡ��Ļ�ߴ�
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

subplot(3, 1, 2);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos2)
    sigPos = adsbPos2(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('��ѡ');
xlabel('����');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % ��ȡ��Ļ�ߴ�
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

subplot(3, 1, 3);
plot(1 : length(data), data);
hold on;
for i = 1 : length(adsbPos3)
    sigPos = adsbPos3(i);
    plot(sigPos : sigPos + 2640 - 1, data(sigPos : sigPos + 2640 - 1), 'color', 'r');
end
title('��ѡ');
xlabel('����');
ylabel('Amplitude');
axis([0 length(data) 0 max(data)]);
scrsz = get(0,'ScreenSize'); % ��ȡ��Ļ�ߴ�
set(gcf, 'position', [0, scrsz(4)/1.7, scrsz(3), scrsz(4)/3]);
set(gca, 'box', 'off', 'xtick', linspace(0, length(data), 20), 'ytick', linspace(0, max(data), 5), 'fontsize', 13);

% >>> ���� <<<


% % >>> ���� <<<
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end