function r = preamble_detection( sampling_rate , frame_inclu )
% 报头检测函数
% 通过采样率生成报头检测模板，之后使用互相关运算进行报头检测
% 输入采样率和数字基带信号，输出前导脉冲位置

% 根据采样率生成报头检测模板，只能采用 2M、4M、8M、10M 的采样率
delta_t = 1.0 / sampling_rate * 10^6; % 单位：微秒

if delta_t > 0.5
    disp( '采样率过低！' );
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
    disp( '采样率不在范围内，仍未实现！' );
    return;
end

pulse_unit = ones( 1 , num_unit );
delta_unit_1 = zeros( 1 , num_unit );
delta_unit_2 = zeros( 1 , num_unit * 4 );
delta_unit_3 = zeros( 1 , num_unit * 6 );

preamble_template = [ pulse_unit , delta_unit_1 , pulse_unit , delta_unit_2 , pulse_unit , delta_unit_1 , pulse_unit , delta_unit_3 ];

% 互相关运算用于检测报头
preamble_threshold = 4.0; % 设置互相关阈值
len_preamble_template = length( preamble_template );

r = zeros( 1 , 1 + length( frame_inclu ) - len_preamble_template );

i = 1;
while ( i <= 1 + length( frame_inclu ) - len_preamble_template )
    rxy = preamble_template * frame_inclu( i : ( i + len_preamble_template - 1 ) );
    r(i) = rxy;
    if rxy >= preamble_threshold
        disp( [ '检测到可能的报头！' , '互相关系数 r=' , num2str(rxy) , ', 位置 pos=' , num2str(i) ] );
        % 进行 DF 验证
        frame_possible = frame_inclu( ( i + len_preamble_template ) : ( i + len_preamble_template + 224 * num_unit - 1 ) )';
        % preamble_possible = frame_inclu( i : ( i + len_preamble_template - 1 ) )';
        [ is_adsb , bin_frame ] = df_detection( num_unit , frame_possible );
        % break;
        % disp( is_adsb );
        % 若通过 DF 验证，将跳过后面 112 微秒的数据，否则跳出本次循环，继续寻找新的报头
        if is_adsb == 1
            disp( '找到 ADS-B 报文消息！' );
            i = i + 240 * num_unit;
            continue;
        else
            i = i + 1;
            continue;
        end
        % 进行 CRC 校验和解码操作，输出报文消息
        
    end
    i = i + 1;
end

% for i = 1 : 1 + length( frame_inclu ) - len_preamble_template
%     rxy = preamble_template * frame_inclu( i : ( i + len_preamble_template - 1 ) );
%     r(i) = rxy;
%     if rxy >= preamble_threshold
%         disp( [ '检测到可能的报头！' , '互相关系数 r=' , num2str(rxy) , ', 位置 pos=' , num2str(i) ] );
%         % 进行 DF 验证
%         frame_possible = frame_inclu( ( i + len_preamble_template ) : ( i + len_preamble_template + 224 * num_unit - 1 ) )';
%         % preamble_possible = frame_inclu( i : ( i + len_preamble_template - 1 ) )';
%         [ is_adsb , bin_frame ] = df_detection( num_unit , frame_possible );
%         % 若通过 DF 验证，将跳过后面 112 微秒的数据，否则跳出本次循环，继续寻找新的报头
%         if is_adsb == 1
%             disp( '找到 ADS-B 报文消息！' );
%             i = i + 240 * num_unit;
%         else
%             continue;
%         end
%         % 进行 CRC 校验和解码操作，输出报文消息
%         
%     end
% end

end

