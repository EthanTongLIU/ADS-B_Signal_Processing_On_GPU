function [ is_adsb ] = power_detect( frame_possible )
% 进行前段的功率检测，主要用于排除前段出现问题的报文

% 统计前 threshold 个大于 120 的点的个数，小于置 0，大于置 1,如果前面从第一个开始出现连续多于 threshold 个 0 则不是报文

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

