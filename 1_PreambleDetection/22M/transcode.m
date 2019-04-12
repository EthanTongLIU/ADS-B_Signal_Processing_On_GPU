function bin_frame = transcode( frame )
% ��������������ת��Ϊ 0 �� 1
% ���� frame_possible Ϊ 112 ΢���ԭʼ��������
% ��� bin_frame Ϊת���� 2 ��������

frame_possible = frame( 177 : 2640 );
bin_frame = zeros( 1 , 112 );

% >>> ������ת�� <<<
for k = 1 : 112
    front_and_after = frame_possible( ( k - 1 ) * 22 + 1 : k * 22 ); % ȡ��ÿ΢���ڵ�����
    front = front_and_after( 1 : 11 );
    front_mean = mean( front );
    after = front_and_after( 12 : 22 );
    after_mean = mean( after );    
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end

end

