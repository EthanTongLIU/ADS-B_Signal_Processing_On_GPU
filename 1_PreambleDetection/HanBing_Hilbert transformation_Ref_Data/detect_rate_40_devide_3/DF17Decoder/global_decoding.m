function [ Lat , Lon ] = global_decoding( DATAME_on_BIN_1 , DATAME_on_BIN_2, T_1 , T_2 )
% ---> 该函数进行全球解码，使用编码方式不同的两条信息解算经纬度位置<---
% ---> 输入DATAME_on_BIN_1， DATAME_on_BIN_2， T_1 和T_2，其中T_1 和T_2 分 别对应两条报文的接收时间，输出Lat 和Lon <---
% ---> 注意：传入的两条报文在传入之前必须确保它们的编码方式不同<---

NZ = 15; % 纬度区数量

% >>> 判断两条报文的编码方式，将其区分<<<
if ( check_encoding_method( DATAME_on_BIN_1 ) == 0 )
    DATAME_on_BIN_EVEN = DATAME_on_BIN_1;
    DATAME_on_BIN_ODD = DATAME_on_BIN_2;
    T_even = T_1;
    T_odd = T_2;
else
    DATAME_on_BIN_EVEN = DATAME_on_BIN_2;
    DATAME_on_BIN_ODD = DATAME_on_BIN_1;
    T_even = T_2;
    T_odd = T_1;
end

% >>> 计算压缩经纬度位置，Lat_cpr_even、Lon_cpr_even、Lat_cpr_odd、Lon_cpr_odd<<<
[ Lat_cpr_even , Lon_cpr_even ] = calculate_LATandLON_CPR(DATAME_on_BIN_EVEN );
[ Lat_cpr_odd , Lon_cpr_odd ] = calculate_LATandLON_CPR( DATAME_on_BIN_ODD );

% >>> 计算纬度索引j <<<
j = floor( 59 * Lat_cpr_even - 60 * Lat_cpr_odd + 0.5 );

% >>> 计算纬度<<<
dLat_even = 360 / ( 4 * NZ );
dLat_odd = 360 / ( 4 * NZ - 1 );
Lat_even = dLat_even * ( mod( j , 60 ) + Lat_cpr_even );
Lat_odd = dLat_odd * ( mod( j , 59 ) + Lat_cpr_odd );

if ( Lat_even >= 270 )
    Lat_even = Lat_even - 360;
end

if ( Lat_odd >= 270 )
    Lat_odd = Lat_odd - 360;
end

if ( T_even >= T_odd )
    Lat = Lat_even;
else
    Lat = Lat_odd;
end

% >>> 检查纬度区的一致性，判断上述解码结果是否可用<<<
NL_even = calculate_number_of_lon_zone( Lat_even );
NL_odd = calculate_number_of_lon_zone( Lat_odd );
if ( NL_even ~= NL_odd )
    disp( '全球解码不可行！' );
    return;
end

% >>> 计算经度<<<
if ( T_even >= T_odd )
    ni = max( NL_even , 1 );
    dLon = 360 / ni;
    m = floor( Lon_cpr_even * ( NL_even - 1 ) - Lon_cpr_odd * NL_even + 0.5 );
    Lon = dLon * ( mod( m , ni ) + Lon_cpr_even );
elseif ( T_even < T_odd )
    ni = max( NL_odd , 1 );
    dLon = 360 / ni;
    m = floor( Lon_cpr_even * ( NL_odd - 1 ) - Lon_cpr_odd * NL_odd + 0.5 );
    Lon = dLon * ( mod( m , ni ) + Lon_cpr_odd );
end

if ( Lon >= 180 )
    Lon = Lon - 360;
end

end
