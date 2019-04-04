function adsb_possible = pre_detect( detect_threshold , data )
% ���б�ͷ��⣬��ԭʼ�������в�����Ϊ 22 MHz
% ������������� ADSB ���ı����� adsb_possible ���棬ÿһ�б�ʾһ�� ADSB ����������

delta_t = 1/22; % ���ò��������1/�����ʣ�����λ΢��
% x_bot = 0 : delta_t : delta_t * ( length( data ) - 1 ); % ������ת��Ϊʱ��

% ������ͷ���ģ��
u111 = ones( 1 , 11 );
u011 = ones( 1 , 11 );
preamble_template = [ u111 u011 u111 repmat( u011 , 1 , 4 ) u111 u011 u111 repmat( u011 , 1 , 6 ) ];

% ��������
% detect_threshold = 7000;

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
    % plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'b' );
    if r(i) >= detect_threshold
        % disp( [ '��⵽���ܵı�ͷ��' , '�����ϵ�� r=' , num2str( r(i) ) , ', λ�� pos=' , num2str(i) ] );
        % DF ��֤�����ʼ�⼰ת��
        if i + m + 112 * 2 * 11 - 1 <= s % ��������������δ����ԭʼ����ά�ȣ��������ȡ��һ�����������Ʊ��ģ������� DF ��֤
            frame_possible = data( i + m : i + m + 112 * 2 * 11 - 1 );
            is_adsb = power_detect( frame_possible ); % ǰ�ι��ʼ��
            if is_adsb == 1
                [ is_adsb , bin_frame , mean_power , num_upper ] = transcode_and_df_detect( frame_possible );
                if is_adsb == 1
                    % plot( i , r(i) , '.' , 'markersize' , 20 , 'color' , 'r' );
                    rp( n ) = r(i);
                    rp_n( n ) = i;
                    disp( [ '���ϵ��=' , num2str(r(i)) , ' pos=' , num2str(i) , '��DF ��֤ͨ�������� ADS-B ������Ϣ��'] );
                    % i = i + 120 / 1.5 * ( 7 + 6 + 7 ); % �ҵ� ADS-B���ĺ���������ı���
                    % ����֤������ֱ����������ı��ģ���Ϊ����������̫�࣬Hilbert��ԭЧ�����ã�����ʺܸߣ���Ҫ����ļ�⣬���Խ�ȫ������ADS-B������ȡ����
                    adsb_possible( n , : ) = bin_frame; % ��������ADS-B���ģ�ֻ����112������Ϣλ
                    mean_power_tot( n , : ) = mean_power; % ����ƽ������
                    num_upper_tot( n , : ) = num_upper; % ����ÿ΢���ڴ���ĳ����ֵ�ĵ�ĸ���
                    frame_possible_tot( n , : ) = frame_possible; % ����ԭʼ��������
                    n = n + 1;
                    i = i + 1;
                    continue;
                else
                    i = i + 1; % ������ ADS-B ���������ǰ��
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

% % �������
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end

end