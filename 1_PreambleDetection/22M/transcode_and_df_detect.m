function [ is_adsb , bin_frame , mean_power , num_upper ] = transcode_and_df_detect( frame_possible )
% Author:LiuTong
% 将数字脉冲序列转码为0和1并识别是否为ADSB报文
% 输入 frame_possible 为112微秒的原始数字序列
% 输出 is_adsb 为 0 表示非ADSB报文，为 1 表示是 ADSB 报文
% 输出 bin_frame 为转码后的 2 进制序列

bin_frame = zeros( 1 , 112 );
mean_power = zeros( 1 , 112 );
num_upper = zeros( 1 , 112 ); % 存储每一微秒内大于某个阈值的点的个数

% 转码为 2 进制序列，需要对位
for k = 1 : 112
    front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % 取出每微秒内的序列
    front = front_and_after( 1 : 11 );
    front_mean = mean( front );
    after = front_and_after( 12 : 22 );
    after_mean = mean( after );
    
    mean_power(k) = mean( front_and_after ); % 求每微秒的平均功率，主要用于控制后半部分误码
    num_upper(k) = sum( front_and_after >= 120 ); % 统计每微秒内大于 120 的点的个数，主要用于控制后半部分误码
    
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end

% 统计每一微秒内大于某个阈值的点的个数，主要用于控制后半部分的误码，暂时不用


% 判断前后30微秒平均功率之差，主要用于控制后半部分的误码
mean_power_diff = 10; %前30微秒和后30微秒的平均功率之差
if abs( mean( mean_power( 1 : 30 ) ) - mean( mean_power( 83 : 112 ) ) ) > mean_power_diff
    is_adsb = 0;
    return;
end

% 求 df 的值
df_format = 0;
for k = 1 : 5
    df_format = df_format + bin_frame(k) * 2^(5-k);
end

% disp( df_format );

if ( df_format == 17 || df_format == 18 )
    is_adsb = 1;
else
    is_adsb = 0;
end

end

