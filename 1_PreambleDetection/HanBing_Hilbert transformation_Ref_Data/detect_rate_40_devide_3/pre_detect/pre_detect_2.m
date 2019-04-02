% Author:LiuTong
% ���б�ͷ��⣬��ԭʼ�������в�����Ϊ40/3MHz
% ������������� ADSB ���ı����� adsb_possible ���棬ÿһ�б�ʾһ�� ADSB ����������
clear, clc;
close all;

% ��������
load( 'source/data1_after_hilbert_transform.mat' );
data = abs( signal_analytic );

delta_t = 0.075; % ���ò��������1/�����ʣ�����λ΢��
% x_bot = 0 : delta_t : delta_t * ( length( data ) - 1 ); % ������ת��Ϊʱ��

figure;
% subplot( 2 , 1 , 1 );
plot( data , '-o' , 'color' , 'b' );

% ������ͷ���ģ��
u17 = ones( 1 , 7 );
u16 = ones( 1 , 6 );
u07 = zeros( 1 , 7 );
u06 = zeros( 1 , 6 );
preamble_template = [ u17 u06 u17 u07 u06 u07 u07 u16 u07 u17 u06 u07 u07 u06 u07 u07 ];

% ��������
detect_threshold = 1700;

s = length( data );
m = length( preamble_template );

r = zeros( 1 , s - m + 1 ); % ����ÿһ�λ����ϵ��

figure;
hold on;
% subplot( 2 , 1 , 2 );
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );

i = 1; n = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'b' );
    if r(i) >= detect_threshold
        disp( [ '��⵽���ܵı�ͷ��' , '�����ϵ�� r=' , num2str( r(i) ) , ', λ�� pos=' , num2str(i) ] );
        % DF ��֤
        if i + m + 74 * ( 7 + 6 + 7 ) + 6 + 7 - 1 <= s % ��������������δ����ԭʼ����ά�ȣ��������ȡ��һ�����������Ʊ��ģ������� DF ��֤
            frame_possible = data( i + m : i + m + 74 * ( 7 + 6 + 7 ) + 6 + 7 - 1 );
            [ is_adsb , bin_frame ] = transcode_and_df_detect( frame_possible );
            if is_adsb == 1
                plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'r' );
                disp( 'DF ��֤ͨ�������� ADS-B ������Ϣ��' );
                % i = i + 120 / 1.5 * ( 7 + 6 + 7 ); % �ҵ� ADS-B���ĺ���������ı���
                % ����֤������ֱ����������ı��ģ���Ϊ����������̫�࣬Hilbert��ԭЧ�����ã�����ʺܸߣ���Ҫ����ļ�⣬���Խ�ȫ������ADS-B������ȡ����
                adsb_possible( n , : ) = bin_frame; n = n + 1; % ���ڱ�������ADS-B���ģ�ֻ����112������Ϣλ
                i = i + 1;
                continue;
            else
                i = i + 1; % ������ ADS-B ���������ǰ��
                continue;
            end
        end
    end
    i = i + 1;
end

standard = repmat( [ 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 ] , 1 , 40 ); % ���ڶ�����
one_frame = data( 188 : 188 + 120 / 1.5 * ( 7 + 6 + 7 ) - 1 ); % ȡ��һ������
x_bot_1 = 0 : delta_t : delta_t * ( length( one_frame ) - 1 ); % ��׼ʱ���

figure;
hold on;
plot( x_bot_1( 1 : 1600 ) , 235 * standard ,'color' , 'r' , 'linewidth' , 1.5 );
plot( x_bot_1 , one_frame , '-' , 'color' , 'b' , 'linewidth' , 1.5 );
xlabel( 'Time [\mus]' );
axis( [ 0 130 0 250 ] );

% �������
[ len_m , len_n ] = size( adsb_possible );
for i = 1 : len_m
    frame_on_hex = bin2hex( adsb_possible( i , : ) );
    disp( frame_on_hex );
    DF17Decoder( frame_on_hex );
end