function [ is_adsb ] = power_detect( frame_possible )
% ����ǰ�εĹ��ʼ�⣬��Ҫ�����ų�ǰ�γ�������ı���

% ͳ��ǰ threshold ������ 120 �ĵ�ĸ�����С���� 0�������� 1,���ǰ��ӵ�һ����ʼ������������ threshold �� 0 ���Ǳ���

threshold = 6;
temp = zeros( 1 , threshold );

for i = 1 : threshold
    if frame_possible(i) >= 120
        temp(i) = 1;
    end
end

if temp == zeros( 1 , 6 )
    is_adsb = 0;
else
    is_adsb = 1;
end

end

