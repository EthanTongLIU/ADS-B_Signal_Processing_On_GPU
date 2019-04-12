function [ is_adsb , bin_frame ] = df_detection( num_unit , frame_possible )

% 参考功率应选择前面几个报头脉冲的最低值，如果后面的112比特数据的平均功率低于报头脉冲的最低值，则取消检测
% preamble_pulse = [ preamble_possible( 1 : num_unit ) , preamble_possible( 2 * num_unit + 1 : 3 * num_unit ) , preamble_possible( 7 * num_unit + 1 : 8 * num_unit ) , preamble_possible( 9 * num_unit + 1 : 10 * num_unit ) ];
% ref_power = min( preamble_pulse );
% disp( ref_power );

bin_frame = zeros( 1 , 112 );

% 转码为 2 进制序列
for k = 1 : length( frame_possible ) / ( 2 * num_unit )
    front = frame_possible( ( k - 1 ) * num_unit + 1 : k * num_unit );
    front_mean = mean( front );
    after = frame_possible( k * num_unit + 1 : ( k + 1 ) * num_unit );
    after_mean = mean( after );
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

