function bin_frame = transcode( frame )
% 将数字脉冲序列转码为 0 和 1
% 输入 frame_possible 为 112 微秒的原始数字序列
% 输出 bin_frame 为转码后的 2 进制序列

frame_possible = frame( 177 : 2640 );
bin_frame = zeros( 1 , 112 );

% >>> 将序列转码 <<<
for k = 1 : 112
    front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % 取出每微秒内的序列
    front = front_and_after( 1 : 11 );
    front_mean = mean( front );
    after = front_and_after( 12 : 22 );
    after_mean = mean( after );    
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end

end

