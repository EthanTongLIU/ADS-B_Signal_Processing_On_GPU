function [ frame_on_hex ] = bin2hex( frame_on_bin )
% 将二进制序列转化为 16 进制序列
% 输入为报文的二进制序列，输出为报文的十六进制字符串序列

frame_on_hex = '0000000000000000000000000000';

for i = 1 : 28
    frame_on_bin_i = frame_on_bin( 4 * ( i - 1 ) + 1 : 4 * ( i - 1 ) + 1 + 3 );
    frame_on_hex_i_num = 0;
    for j = 1 : 4
        frame_on_hex_i_num = frame_on_hex_i_num + frame_on_bin_i(5-j) * 2^(j-1);
    end
    if frame_on_hex_i_num > 9
        switch frame_on_hex_i_num
            case 10
                frame_on_hex(i) = 'A';
            case 11
                frame_on_hex(i) = 'B';
            case 12
                frame_on_hex(i) = 'C';
            case 13
                frame_on_hex(i) = 'D';
            case 14
                frame_on_hex(i) = 'E';
            case 15
                frame_on_hex(i) = 'F';
            otherwise
                disp( 'error' );
                return;
        end
    else
        frame_on_hex(i) = num2str( frame_on_hex_i_num );
    end
end

end

