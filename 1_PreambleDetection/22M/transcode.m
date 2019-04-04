function [hex_frame ] = transcode( frame_possible )
bin_frame = zeros( 1 , 120 );
% 转码为 2 进制序列，需要对位
for k = 1 : 120
    front = frame_possible( (k-1)*22+1: (k-1)*22+11); 
    front_mean = mean( front );
    after = frame_possible( (k-1)*22+12: k*22); 
    after_mean = mean( after );
        % 判断0或1
    if front_mean > after_mean
        bin_frame(k) = 1;
    else
        bin_frame(k) = 0;
    end
end
hex_frame = '';
for k = 9:4:120
    sum_bin = sum(bin_frame(k:k+3).*[8,4,2,1]);
    switch sum_bin-9
        case 1  
            to_add = 'A';
        case 2  
            to_add = 'B';
        case 3  
            to_add = 'C';
        case 4  
            to_add = 'D';
        case 5  
            to_add = 'E';
        case 6  
            to_add = 'F';
        otherwise
            to_add = num2str(sum_bin);
    end
    hex_frame = strcat(hex_frame,to_add);
end
