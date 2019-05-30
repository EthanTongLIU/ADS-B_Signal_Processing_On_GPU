clear, clc;
close all;

load('testdata.mat');

figure;
subplot(311);
hold on;
stem(linspace(0, 120, 2640), testdata);

% 进行波形匹配，仅提取4个报头脉冲的脉冲中点
preFrt = [testdata(6) testdata(6 + 11) testdata(6 + 22) testdata(6 + 33) testdata(6 + 66) testdata(6 + 77) testdata(6 + 88) testdata(6 + 99)];
preAft = zeros(1, 4);

for i = 1 : 4
    if preFrt(2 * (i - 1) + 1) > preFrt(2 * (i - 1) + 2)
        preAft(i) = 1;
    end
end

subplot(312);
hold on;
stem(preAft);

% 多点波形匹配
s1_pre = sum(testdata(  1 :  11));
s1_aft = sum(testdata( 12 :  22));

s2_pre = sum(testdata( 23 :  33));
s2_aft = sum(testdata( 34 :  44));

s3 = sum(testdata( 45 :  66));

s4_pre = sum(testdata( 67 :  77));
s4_aft = sum(testdata( 78 :  88));

s5_pre = sum(testdata( 89 :  99));
s5_aft = sum(testdata(100 : 110));

s6 = sum(testdata(111 : 132));

s7 = sum(testdata(133 : 154));

s8 = sum(testdata(155 : 176));

meanPulse = mean([s1_pre, s2_pre, s4_aft, s5_aft]);

if (s1_pre > s1_aft) && (s2_pre > s2_aft) && (s4_pre < s4_aft) && (s5_pre < s5_aft) && (2 * meanPulse > s3) && (2 * meanPulse > s6) && (2 * meanPulse > s7) && (2 * meanPulse > s8)
    disp('ok');
end

% 多点译码
frameBit = zeros(1, 112);
for i = 1 : 112
    currentBit = testdata(177 + (i-1) * 22 : 177 + i * 22 - 1);
    pre = sum(currentBit( 1 : 11));
    aft = sum(currentBit(12 : 22));
    if pre >= aft
        frameBit(i) = 1;
    end
end

subplot(313);
stem([zeros(1, 8), frameBit]);