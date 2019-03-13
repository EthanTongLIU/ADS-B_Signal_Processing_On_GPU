function r = preamble_detection( sampling_rate , frame_inclu )
% ��ͷ��⺯��
% ͨ�����������ɱ�ͷ���ģ�壬֮��ʹ�û����������б�ͷ���
% ��������ʺ����ֻ����źţ����ǰ������λ��

% ���ݲ��������ɱ�ͷ���ģ�壬ֻ�ܲ��� 2M��4M��8M��10M �Ĳ�����
delta_t = 1.0 / sampling_rate * 10^6; % ��λ��΢��

if delta_t > 0.5
    disp( '�����ʹ��ͣ�' );
    return;
elseif ( delta_t == 0.5 ) 
    num_unit = 1;
elseif ( delta_t == 0.25 )
    num_unit = 2;
elseif ( delta_t == 0.125 )
    num_unit = 4;
elseif ( delta_t == 0.1 )
    num_unit = 5;
else 
    disp( '�����ʲ��ڷ�Χ�ڣ���δʵ�֣�' );
    return;
end

pulse_unit = ones( 1 , num_unit );
delta_unit_1 = zeros( 1 , num_unit );
delta_unit_2 = zeros( 1 , num_unit * 4 );
delta_unit_3 = zeros( 1 , num_unit * 6 );

preamble_template = [ pulse_unit , delta_unit_1 , pulse_unit , delta_unit_2 , pulse_unit , delta_unit_1 , pulse_unit , delta_unit_3 ];

% ������������ڼ�ⱨͷ
preamble_threshold = 4.0; % ���û������ֵ
len_preamble_template = length( preamble_template );

r = zeros( 1 , 1 + length( frame_inclu ) - len_preamble_template );

i = 1;
while ( i <= 1 + length( frame_inclu ) - len_preamble_template )
    rxy = preamble_template * frame_inclu( i : ( i + len_preamble_template - 1 ) );
    r(i) = rxy;
    if rxy >= preamble_threshold
        disp( [ '��⵽���ܵı�ͷ��' , '�����ϵ�� r=' , num2str(rxy) , ', λ�� pos=' , num2str(i) ] );
        % ���� DF ��֤
        frame_possible = frame_inclu( ( i + len_preamble_template ) : ( i + len_preamble_template + 224 * num_unit - 1 ) )';
        % preamble_possible = frame_inclu( i : ( i + len_preamble_template - 1 ) )';
        [ is_adsb , bin_frame ] = df_detection( num_unit , frame_possible );
        % break;
        % disp( is_adsb );
        % ��ͨ�� DF ��֤������������ 112 ΢������ݣ�������������ѭ��������Ѱ���µı�ͷ
        if is_adsb == 1
            disp( '�ҵ� ADS-B ������Ϣ��' );
            i = i + 240 * num_unit;
            continue;
        else
            i = i + 1;
            continue;
        end
        % ���� CRC У��ͽ�����������������Ϣ
        
    end
    i = i + 1;
end

% for i = 1 : 1 + length( frame_inclu ) - len_preamble_template
%     rxy = preamble_template * frame_inclu( i : ( i + len_preamble_template - 1 ) );
%     r(i) = rxy;
%     if rxy >= preamble_threshold
%         disp( [ '��⵽���ܵı�ͷ��' , '�����ϵ�� r=' , num2str(rxy) , ', λ�� pos=' , num2str(i) ] );
%         % ���� DF ��֤
%         frame_possible = frame_inclu( ( i + len_preamble_template ) : ( i + len_preamble_template + 224 * num_unit - 1 ) )';
%         % preamble_possible = frame_inclu( i : ( i + len_preamble_template - 1 ) )';
%         [ is_adsb , bin_frame ] = df_detection( num_unit , frame_possible );
%         % ��ͨ�� DF ��֤������������ 112 ΢������ݣ�������������ѭ��������Ѱ���µı�ͷ
%         if is_adsb == 1
%             disp( '�ҵ� ADS-B ������Ϣ��' );
%             i = i + 240 * num_unit;
%         else
%             continue;
%         end
%         % ���� CRC У��ͽ�����������������Ϣ
%         
%     end
% end

end

