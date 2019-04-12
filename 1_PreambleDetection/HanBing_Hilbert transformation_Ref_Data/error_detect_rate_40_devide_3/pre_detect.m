clear, clc;
close all;

load( 'data1_after_hilbert_transform.mat' );

data = abs( signal_analytic );

delta_t = 0.075;
x_bot = 0 : delta_t : delta_t * ( length( data ) - 1 );

figure;
% subplot( 2 , 1 , 1 );
plot( data , '-' , 'color' , 'b' , 'linewidth' , 1.5 );
% plot( x_bot , data , '-o' , 'color' , 'b' );
% xlabel( '时间 [\mus]' );

unit = 7;
pulse_unit = ones( 1 , unit );
zeros_unit_1 = zeros( 1 , unit );
zeros_unit_2 = zeros( 1 , 4 * unit );
zeros_unit_3 = zeros( 1 , 6 * unit );
preamble_template = [ pulse_unit , zeros_unit_1 , pulse_unit , zeros_unit_2 , pulse_unit , zeros_unit_1 , pulse_unit , zeros_unit_3 ];

s = length( data );
m = length( preamble_template );

detect_threshold = 1700;

r = zeros( 1 , s - m + 1 );

figure;
hold on;
% subplot( 2 , 1 , 2 );
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );

i = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'b' );
    if r(i) >= detect_threshold
        disp( [ '检测到可能的报头！' , '互相关系数 r=' , num2str( r(i) ) , ', 位置 pos=' , num2str(i) ] );
        % DF 验证
        if i + m + unit * 2 * 112 - 1 <= s % 若数组索引长度未超过原始矩阵维度，则可以提取出一串完整的疑似报文，并进行 DF 验证
            frame_possible = data( i + m : i + m + unit * 2 * 112 - 1 );
            [ is_adsb , bin_frame ] = df_detection( unit , frame_possible );
            if is_adsb == 1
                plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'r' );
                disp( 'DF 验证通过，疑似 ADS-B 报文消息！' );
                % i = i + unit * 2 * 120; % 找到 ADS-B报文后跳过后面的报文
                % 经验证，不能直接跳过后面的报文，因为采样点数据太多，采样效果不好，误检率很高，需要另外的检测
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

model = repmat( [ pulse_unit zeros_unit_1 ] , 1 , 112 ); % 非标准对齐脉冲

standard = repmat( [ 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 ] , 1 , 40 );

figure;
hold on;
frame = data( 182 : 182 + 120 * unit * 2 - 1 );
x_bot_1 = 0 : delta_t : delta_t * ( length( frame ) - 1 ); % 标准时间底
plot( x_bot_1 , 250 * [ preamble_template model ] , 'color' , 'r' , 'linewidth' , 1.5 );
plot( x_bot_1( 1 : 1600 ) , 235 * standard ,'color' , 'g' , 'linewidth' , 1.5 );
plot( x_bot_1 , frame , '-' , 'color' , 'b' , 'linewidth' , 1.5 );
plot( [120 120] , [0 250] , 'color' , 'k' , 'linewidth' , 2 );
xlabel( 'Time [\mus]' );


% figure;
% x_bot_standard = 0.01 * ones( 1 , 12000 );
% plot( x_bot_standard , 250 * standard , '-.' , 'color' , 'g' );


