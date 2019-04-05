function continued_adsb_possible = pre_detect( detect_threshold , data )
% 进行报头检测，该原始数据序列采样率为 22 MHz
% 输入 detect_threshold 为互相关检测的阈值，data 为数据序列
% 输出 adsb_possible 为检测后的 ADS-B 报文序列，每一行表示一个 ADS-B 二进制序列

% >>> 构建报头检测模板 <<<
u111 = ones( 1 , 11 );
u011 = ones( 1 , 11 );
preamble_template = [ u111 u011 u111 repmat( u011 , 1 , 4 ) u111 u011 u111 repmat( u011 , 1 , 6 ) ];

s = length( data );
m = length( preamble_template );

% >>> 保存每一次互相关系数 <<<
r = zeros( 1 , s - m + 1 );

% >>> 检测报头 <<<
i = 1; n = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    if r(i) >= detect_threshold
        if i + m + 112 * 2 * 11 - 1 <= s % 若数组索引长度未超过原始矩阵维度，则可以提取出一串完整的疑似报文，并进行 DF 验证
            frame = data( i : i + m + 112 * 2 * 11 - 1 );
            is_adsb = df_and_power_detect( frame );
            if is_adsb == 1
                disp( [ '相关系数=' , num2str(r(i)) , '，pos=' , num2str(i) , '，DF 验证通过，疑似 ADS-B 报文消息！'] );
                bin_frame = transcode( frame );
                r_possible( n ) = r(i);
                r_possible_pos( n ) = i;
                adsb_possible( n , : ) = bin_frame; % 保存疑似 ADS-B 报文，只保留 112 比特信息位
                n = n + 1;
                i = i + 1;
                continue;
            else
                i = i + 1; % 若不是 ADS-B 报文则继续前进
                continue;
            end
        end
    end
    i = i + 1;
end

% >>> 绘制互相关检测图 <<< 
figure;
hold on;
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );
plot( r , '.' , 'markersize' , 20 , 'color' , 'b' );
plot( r_possible_pos , r_possible , '.' , 'markersize' , 20 , 'color' , 'r' );

% >>> 在连续报头中二次筛选相关系数最大的 <<<
m = 1;
for i = 1 : length( r_possible_pos ) - 1
    if r_possible_pos(i+1) - r_possible_pos(i) == 1
        diff_continued_r = r_possible(i+1) - r_possible(i);
        if diff_continued_r >= 0
            continued_r_pos(m) = r_possible_pos(i+1);
            continued_r(m) = r_possible(i+1);
            continued_adsb_possible(m,1:112) = adsb_possible(i+1,:);
        else
            continued_r_pos(m) = r_possible_pos(i);
            continued_r(m) = r_possible(i);
            continued_adsb_possible(m,1:112) = adsb_possible(i,:);
        end
    else
        m = m + 1;
    end
end

% >>> 绘制排除了连续包头的互相关检测图 <<< 
figure;
hold on;
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );
plot( r , '.' , 'markersize' , 20 , 'color' , 'b' );
plot( continued_r_pos , continued_r , '.' , 'markersize' , 20 , 'color' , 'r' );

end