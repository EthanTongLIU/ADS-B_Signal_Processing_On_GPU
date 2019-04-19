function is_adsb = df_and_power_detect( frame )
% ����ǰ�εĹ��ʼ�⣬��Ҫ�����ų�ǰ�γ�������ı���
% ͳ��ǰ threshold ������ 120 �ĵ�ĸ�����С���� 0�������� 1,���ǰ��ӵ�һ����ʼ������������ threshold �� 0 ���Ǳ���

% frame_possible = frame( 177 : 2640 );

% >>> ǰ�ι��ʼ�� <<<
threshold = 6;
temp = zeros( 1 , threshold );
for i = 1 : threshold
    if frame(i) >= 120
        temp(i) = 1;
    end
end
if temp == zeros( 1 , 6 )
    is_adsb = 0;
    return;
else
    % >>> DF ��� <<<
    frame_possible = frame( 177 : 2640 ); 
    df_bin_frame = zeros( 1 , 5 );
    % �� DF �ֶ�ת��Ϊ 2 ��������
    for k = 1 : 5
        front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % ȡ��ÿ΢���ڵ�����
        front = front_and_after( 1 : 11 );
        front_mean = mean( front );
        after = front_and_after( 12 : 22 );
        after_mean = mean( after );    
        if front_mean > after_mean
            df_bin_frame(k) = 1;
        else
            df_bin_frame(k) = 0;
        end
    end
    % �� DF ��ֵ
    df_format = 0;
    for k = 1 : 5
        df_format = df_format + df_bin_frame(k) * 2^(5-k);
    end
    if ( df_format == 17 || df_format == 18 )
        % >>> ��ι��ʼ�� <<<
        mean_power = zeros( 1 , 112 );
        % ��ÿ΢���ƽ������
        for k = 1 : 112
            front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % ȡ��ÿ΢���ڵ�����
            mean_power(k) = mean( front_and_after ); % ��ÿ΢���ƽ�����ʣ���Ҫ���ڿ��ƺ�벿������
        end
        % �ж�ǰ�� 30 ΢��ƽ������֮���Ҫ���ڿ��ƺ�벿�ֵ�����
        mean_power_diff = 10; % ǰ 30 ΢��ͺ� 30 ΢���ƽ������֮��
        if abs( mean( mean_power( 1 : 30 ) ) - mean( mean_power( 83 : 112 ) ) ) > mean_power_diff
            is_adsb = 0;
            return;
        else
            is_adsb = 1;
        end
    else
        is_adsb = 0;
        return;
    end
end

end

