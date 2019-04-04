function [ is_adsb , bin_frame , mean_power , num_upper ] = transcode_and_df_detect( frame_possible )
% Author:LiuTong
% ��������������ת��Ϊ0��1��ʶ���Ƿ�ΪADSB����
% ���� frame_possible Ϊ112΢���ԭʼ��������
% ��� is_adsb Ϊ 0 ��ʾ��ADSB���ģ�Ϊ 1 ��ʾ�� ADSB ����
% ��� bin_frame Ϊת���� 2 ��������

bin_frame = zeros( 1 , 112 );
mean_power = zeros( 1 , 112 );
num_upper = zeros( 1 , 112 ); % �洢ÿһ΢���ڴ���ĳ����ֵ�ĵ�ĸ���

% ת��Ϊ 2 �������У���Ҫ��λ
for k = 1 : 112
    front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % ȡ��ÿ΢���ڵ�����
    front = front_and_after( 1 : 11 );
    front_mean = mean( front );
    after = front_and_after( 12 : 22 );
    after_mean = mean( after );
    
    mean_power(k) = mean( front_and_after ); % ��ÿ΢���ƽ�����ʣ���Ҫ���ڿ��ƺ�벿������
    num_upper(k) = sum( front_and_after >= 120 ); % ͳ��ÿ΢���ڴ��� 120 �ĵ�ĸ�������Ҫ���ڿ��ƺ�벿������
    
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end

% ͳ��ÿһ΢���ڴ���ĳ����ֵ�ĵ�ĸ�������Ҫ���ڿ��ƺ�벿�ֵ����룬��ʱ����


% �ж�ǰ��30΢��ƽ������֮���Ҫ���ڿ��ƺ�벿�ֵ�����
mean_power_diff = 10; %ǰ30΢��ͺ�30΢���ƽ������֮��
if abs( mean( mean_power( 1 : 30 ) ) - mean( mean_power( 83 : 112 ) ) ) > mean_power_diff
    is_adsb = 0;
    return;
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

