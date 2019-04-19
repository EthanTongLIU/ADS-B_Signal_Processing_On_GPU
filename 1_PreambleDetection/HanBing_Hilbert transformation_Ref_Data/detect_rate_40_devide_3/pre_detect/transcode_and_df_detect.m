function [ is_adsb , bin_frame ] = transcode_and_df_detect( frame_possible )
% Author:LiuTong
% ��������������ת��Ϊ0��1��ʶ���Ƿ�ΪADSB����
% ���� frame_possible Ϊ112΢���ԭʼ��������
% ��� is_adsb Ϊ 0 ��ʾ��ADSB���ģ�Ϊ 1 ��ʾ�� ADSB ����
% ��� bin_frame Ϊת���� 2 ��������

bin_frame = zeros( 1 , 112 );

% ת��Ϊ 2 �������У���Ҫ��λ
for k = 1 : 112
    % ��λ����
    switch mod( k , 3 )
        case 1
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % ȡ��
            front = frame_possible( q * 40 + 1 : q * 40 + 6 ); % 6
            front_mean = mean( front );
            after = frame_possible( q * 40 + 7 : q * 40 + 13 ); % 7
            after_mean = mean( after );
        case 2
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % ȡ��
            front = frame_possible( q * 40 + 13 + 1 : q * 40 + 13 + 7 ); % 7
            front_mean = mean( front );
            after = frame_possible( q * 40 + 13 + 8 : q * 40 + 13 + 13 ); % 6
            after_mean = mean( after ); 
        case 0
            % q = fix( k / 3 );
            q = ( k - mod( k , 3 ) ) / 3; % ȡ��
            q = q - 1; % ��������£��̵�ֵ��һ
            front = frame_possible( q * 40 + 26 + 1 : q * 40 + 26 + 7 ); % 7
            front_mean = mean( front );
            after = frame_possible( q * 40 + 26 + 8 : q * 40 + 26 + 14 ); % 7
            after_mean = mean( after );
        otherwise
            disp( 'error' );
            return;
    end

    % �ж�0��1
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end

% �� df ��ֵ
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

