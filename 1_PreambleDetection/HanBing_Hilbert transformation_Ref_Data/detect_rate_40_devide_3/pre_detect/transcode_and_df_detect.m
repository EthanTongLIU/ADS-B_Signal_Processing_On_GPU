function [ is_adsb , bin_frame ] = transcode_and_df_detect( frame_possible )
% Author:LiuTong
% 将数字脉冲序列转码为0和1并识别是否为ADSB报文
% 输入 frame_possible 为112微秒的原始数字序列
% 输出 is_adsb 为 0 表示非ADSB报文，为 1 表示是 ADSB 报文
% 输出 bin_frame 为转码后的 2 进制序列

bin_frame = zeros( 1 , 112 );

% 转码为 2 进制序列，需要对位
for k = 1 : 112
    % 对位操作
    switch mod( k , 3 )
        case 1
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % 取商
            front = frame_possible( q * 40 + 1 : q * 40 + 6 ); % 6
            front_mean = mean( front );
            after = frame_possible( q * 40 + 7 : q * 40 + 13 ); % 7
            after_mean = mean( after );
        case 2
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % 取商
            front = frame_possible( q * 40 + 13 + 1 : q * 40 + 13 + 7 ); % 7
            front_mean = mean( front );
            after = frame_possible( q * 40 + 13 + 8 : q * 40 + 13 + 13 ); % 6
            after_mean = mean( after ); 
        case 0
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % 取商
            q = q - 1; % 这种情况下，商的值减一
            front = frame_possible( q * 40 + 26 + 1 : q * 40 + 26 + 7 ); % 7
            front_mean = mean( front );
            after = frame_possible( q * 40 + 26 + 8 : q * 40 + 26 + 14 ); % 7
            after_mean = mean( after );
        otherwise
            disp( 'error' );
            return;
    end

    % 判断0或1
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
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

