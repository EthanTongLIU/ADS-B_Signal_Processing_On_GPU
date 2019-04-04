function adsb_possible = pre_detect( detect_threshold , data )
% 进行报头检测，该原始数据序列采样率为 22 MHz
% 检测后的所有疑似 ADSB 报文保存在 adsb_possible 里面，每一行表示一个 ADSB 二进制序列

delta_t = 1/22; % 设置采样间隔（1/采样率），单位微秒
% x_bot = 0 : delta_t : delta_t * ( length( data ) - 1 ); % 横坐标转化为时间

% 构建报头检测模板
u111 = ones( 1 , 11 );
u011 = ones( 1 , 11 );
preamble_template = [ u111 u011 u111 repmat( u011 , 1 , 4 ) u111 u011 u111 repmat( u011 , 1 , 6 ) ];

% 设置门限
% detect_threshold = 7000;

s = length( data );
m = length( preamble_template );

r = zeros( 1 , s - m + 1 ); % 保存每一次互相关系数

figure;
hold on;
% subplot( 2 , 1 , 2 );
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );

i = 1; n = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    % plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'b' );
    if r(i) >= detect_threshold
        % disp( [ '检测到可能的报头！' , '互相关系数 r=' , num2str( r(i) ) , ', 位置 pos=' , num2str(i) ] );
        % DF 验证，功率检测及转码
        if i + m + 112 * 2 * 11 - 1 <= s % 若数组索引长度未超过原始矩阵维度，则可以提取出一串完整的疑似报文，并进行 DF 验证
            frame_possible = data( i + m : i + m + 112 * 2 * 11 - 1 );
            is_adsb = power_detect( frame_possible ); % 前段功率检测
            if is_adsb == 1
                [ is_adsb , bin_frame , mean_power , num_upper ] = transcode_and_df_detect( frame_possible );
                if is_adsb == 1
                    % plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'r' );
                    rp( n ) = r(i);
                    rp_n( n ) = i;
                    disp( [ '相关系数=' , num2str(r(i)) , ' pos=' , num2str(i) , '，DF 验证通过，疑似 ADS-B 报文消息！'] );
                    % i = i + 120 / 1.5 * ( 7 + 6 + 7 ); % 找到 ADS-B报文后跳过后面的报文
                    % 经验证，不能直接跳过后面的报文，因为采样点数据太多，Hilbert还原效果不好，误检率很高，需要另外的检测，所以将全部疑似ADS-B报文提取出来
                    adsb_possible( n , : ) = bin_frame; % 保存疑似ADS-B报文，只保留112比特信息位
                    mean_power_tot( n , : ) = mean_power; % 保存平均功率
                    num_upper_tot( n , : ) = num_upper; % 保存每微秒内大于某个阈值的点的个数
                    frame_possible_tot( n , : ) = frame_possible; % 保存原始报文序列
                    n = n + 1;
                    i = i + 1;
                    continue;
                else
                    i = i + 1; % 若不是 ADS-B 报文则继续前进
                    continue;
                end
            end
        end
    end
    i = i + 1;
end

plot( r , '.' , 'markersize' , 20 , 'color' , 'b' );
plot( rp_n , rp , '.' , 'markersize' , 20 , 'color' , 'r' ); 

% [ len_m , len_n ] = size( mean_power_tot );
% 
% figure;
% hold on;
% plot( frame_possible_tot( 1 , : ) , '-o' , 'linewidth' , 2 );
% k = 2;
% plot( frame_possible_tot( 1 , 1 : ( k + 1 ) * 11 ) , '-.' , 'linewidth' , 2 , 'color' , 'r' );
% plot( frame_possible_tot( 1 , 1 : ( k - 1 ) * 11 ) , '-.' , 'linewidth' , 2 , 'color' , 'g' );
% plot( [0 2500] , [120 120] , 'linewidth' , 2 );

% figure;
% num_upper_tot( 12 , : );
% plot( num_upper_tot( 10 , : ) , '-o' , 'linewidth' , 2 );
% plot( mean_power_tot( 71 , : ) , '-o' , 'linewidth' , 2 ); 
% hold on;
% plot( mean( mean_power_tot( 71 , 1 : 30 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'g' );
% plot( mean( mean_power_tot( 71 , 83 : 112 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'r' );
% axis( [0 120 0 130] );

% figure;
% plot( mean_power_tot( 72 , : ) , '-o' , 'linewidth' , 2 ); 
% hold on;
% plot( mean( mean_power_tot( 72 , 1 : 30 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'g' );
% plot( mean( mean_power_tot( 72 , 83 : 112 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'r' );
% axis( [0 120 0 130] );
% 
% figure;
% plot( mean_power_tot( 73 , : ) , '-o' ,  'linewidth' , 2 ); 
% hold on;
% plot( mean( mean_power_tot( 73 , 1 : 30 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'g' );
% plot( mean( mean_power_tot( 73 , 83 : 112 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'r' );
% axis( [0 120 0 130] );
% 
% figure;
% plot( mean_power_tot( 74 , : ) , '-o' ,  'linewidth' , 2 );
% hold on;
% plot( mean( mean_power_tot( 74 , 1 : 30 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'g' );
% plot( mean( mean_power_tot( 74 , 83 : 112 ) ) * ones( 1 , 112 ) , 'linewidth' , 3 , 'color' , 'r' );
% axis( [0 120 0 130] );

% % 解码操作
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end

end