function continued_adsb_possible = pre_detect( detect_threshold , data )
% ���б�ͷ��⣬��ԭʼ�������в�����Ϊ 22 MHz
% ���� detect_threshold Ϊ����ؼ�����ֵ��data Ϊ��������
% ��� adsb_possible Ϊ����� ADS-B �������У�ÿһ�б�ʾһ�� ADS-B ����������

% >>> ������ͷ���ģ�� <<<
u111 = ones( 1 , 11 );
u011 = ones( 1 , 11 );
preamble_template = [ u111 u011 u111 repmat( u011 , 1 , 4 ) u111 u011 u111 repmat( u011 , 1 , 6 ) ];

s = length( data );
m = length( preamble_template );

% >>> ����ÿһ�λ����ϵ�� <<<
r = zeros( 1 , s - m + 1 );

% >>> ��ⱨͷ <<<
i = 1; n = 1;
while ( i <= s - m + 1 )
    r(i) = preamble_template * data( i : i + m - 1 )';
    if r(i) >= detect_threshold
        if i + m + 112 * 2 * 11 - 1 <= s % ��������������δ����ԭʼ����ά�ȣ��������ȡ��һ�����������Ʊ��ģ������� DF ��֤
            frame = data( i : i + m + 112 * 2 * 11 - 1 );
            is_adsb = df_and_power_detect( frame );
            if is_adsb == 1
                disp( [ '���ϵ��=' , num2str(r(i)) , '��pos=' , num2str(i) , '��DF ��֤ͨ�������� ADS-B ������Ϣ��'] );
                bin_frame = transcode( frame );
                r_possible( n ) = r(i);
                r_possible_pos( n ) = i;
                adsb_possible( n , : ) = bin_frame; % �������� ADS-B ���ģ�ֻ���� 112 ������Ϣλ
                n = n + 1;
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

% >>> ���ƻ���ؼ��ͼ <<< 
figure;
hold on;
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );
plot( r , '.' , 'markersize' , 20 , 'color' , 'b' );
plot( r_possible_pos , r_possible , '.' , 'markersize' , 20 , 'color' , 'r' );

% >>> ��������ͷ�ж���ɸѡ���ϵ������ <<<
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

% >>> �����ų���������ͷ�Ļ���ؼ��ͼ <<< 
figure;
hold on;
plot( [ 0 s ] , [ detect_threshold detect_threshold ] , 'color' , 'm' , 'linewidth' , 3 );
plot( r , '.' , 'markersize' , 20 , 'color' , 'b' );
plot( continued_r_pos , continued_r , '.' , 'markersize' , 20 , 'color' , 'r' );

end