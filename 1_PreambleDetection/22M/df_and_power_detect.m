function is_adsb = df_and_power_detect( frame )
% 进行前段的功率检测，主要用于排除前段出现问题的报文
% 统计前 threshold 个大于 120 的点的个数，小于置 0，大于置 1,如果前面从第一个开始出现连续多于 threshold 个 0 则不是报文

% frame_possible = frame( 177 : 2640 );

% >>> 前段功率检测 <<<
threshold = 6;
temp = zeros( 1 , threshold );
for i = 1 : threshold
    if frame(i) >= 120
        temp(i) = 1;
    end
end
if temp == zeros( 1 , 6 )
    is_adsb = 0;
    return;
else
    % >>> DF 检测 <<<
    frame_possible = frame( 177 : 2640 ); 
    df_bin_frame = zeros( 1 , 5 );
    % 将 DF 字段转码为 2 进制序列
    for k = 1 : 5
        front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % 取出每微秒内的序列
        front = front_and_after( 1 : 11 );
        front_mean = mean( front );
        after = front_and_after( 12 : 22 );
        after_mean = mean( after );    
        if front_mean > after_mean
            df_bin_frame(k) = 1;
        else
            df_bin_frame(k) = 0;
        end
    end
    % 求 DF 的值
    df_format = 0;
    for k = 1 : 5
        df_format = df_format + df_bin_frame(k) * 2^(5-k);
    end
    if ( df_format == 17 || df_format == 18 )
        % >>> 后段功率检测 <<<
        mean_power = zeros( 1 , 112 );
        % 求每微秒的平均功率
        for k = 1 : 112
            front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % 取出每微秒内的序列
            mean_power(k) = mean( front_and_after ); % 求每微秒的平均功率，主要用于控制后半部分误码
        end
        % 判断前后 30 微秒平均功率之差，主要用于控制后半部分的误码
        mean_power_diff = 10; % 前 30 微秒和后 30 微秒的平均功率之差
        if abs( mean( mean_power( 1 : 30 ) ) - mean( mean_power( 83 : 112 ) ) ) > mean_power_diff
            is_adsb = 0;
            return;
        else
            is_adsb = 1;
        end
    else
        is_adsb = 0;
        return;
    end
end

end

