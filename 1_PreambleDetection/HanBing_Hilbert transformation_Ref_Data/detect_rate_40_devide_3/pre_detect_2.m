% Author:LiuTong
% 进行报头检测，该原始数据序列采样率为40/3MHz
% 检测后的所有疑似 ADSB 报文保存在 adsb_possible 里面，每一行表示一个 ADSB 二进制序列
clear, clc;
close all;

% 加载数据
load( 'data1_after_hilbert_transform.mat' );
data = abs( signal_analytic );

delta_t = 0.075; % 设置采样间隔（1/采样率），单位微秒
% x_bot = 0 : delta_t : delta_t * ( length( data ) - 1 ); % 横坐标转化为时间

subplot( 2 , 1 , 1 );
plot( data , '-o' , 'color' , 'b' );

% 构建报头检测模板
u17 = ones( 1 , 7 );
u16 = ones( 1 , 6 );
u07 = zeros( 1 , 7 );
u06 = zeros( 1 , 6 );
preamble_template = [ u17 u06 u17 u07 u06 u07 u07 u16 u07 u17 u06 u07 u07 u06 u07 u07 ];

% 设置门限
detect_threshold = 1700;

s = length( data );
m = length( preamble_template );

r = zeros( 1 , s - m + 1 ); % 保存每一次互相关系数

subplot( 2 , 1 , 2 );
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );
hold on;

i = 1; n = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    plot( i , r(i) , '.' , 'markersize' , 12 , 'color' , 'b' );
    if r(i) >= detect_threshold
        disp( [ '检测到可能的报头！' , '互相关系数 r=' , num2str( r(i) ) , ', 位置 pos=' , num2str(i) ] );
        % DF 验证
        if i + m + 74 * ( 7 + 6 + 7 ) + 6 + 7 - 1 <= s % 若数组索引长度未超过原始矩阵维度，则可以提取出一串完整的疑似报文，并进行 DF 验证
            frame_possible = data( i + m : i + m + 74 * ( 7 + 6 + 7 ) + 6 + 7 - 1 );
            [ is_adsb , bin_frame ] = transcode_and_df_detect( frame_possible );
            if is_adsb == 1
                plot( i , r(i) , '.' , 'markersize' , 12 , 'color' , 'r' );
                disp( 'DF 验证通过，疑似 ADS-B 报文消息！' );
                % i = i + 120 / 1.5 * ( 7 + 6 + 7 ); % 找到 ADS-B报文后跳过后面的报文
                % 经验证，不能直接跳过后面的报文，因为采样点数据太多，Hilbert还原效果不好，误检率很高，需要另外的检测，所以将全部疑似ADS-B报文提取出来
                adsb_possible( n , : ) = bin_frame; n = n + 1; % 用于保存疑似ADS-B报文，只保留112比特信息位
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

standard = repmat( [ 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 ] , 1 , 40 ); % 用于对齐检测
one_frame = data( 188 : 188 + 120 / 1.5 * ( 7 + 6 + 7 ) - 1 ); % 取出一段序列
x_bot_1 = 0 : delta_t : delta_t * ( length( one_frame ) - 1 ); % 标准时间底

figure;
hold on;
plot( x_bot_1( 1 : 1600 ) , 235 * standard ,'color' , 'r' );
plot( x_bot_1 , one_frame , '-o' , 'color' , 'b' );