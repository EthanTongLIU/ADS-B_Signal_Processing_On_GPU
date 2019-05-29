load('testdata.mat');

figure;
subplot(211);
hold on;
stem(linspace(0, 120, 2640), testdata);

% 进行波形匹配，提取脉冲中点

preFrt = [testdata(6) testdata(6 + 11) testdata(6 + 22) testdata(6 + 33) testdata(6 + 66) testdata(6 + 77) testdata(6 + 88) testdata(6 + 99)];
preAft = zeros(1, 4);

for i = 1 : 4
    if preFrt(2 * (i - 1) + 1) > preFrt(2 * (i - 1) + 2)
        preAft(i) = 1;
    end
end

subplot(212);
hold on;
stem(preAft);
% plot(linspace(0, 120, 2640), testdata);
% axis([0, 120, 0, max(testdata)]);