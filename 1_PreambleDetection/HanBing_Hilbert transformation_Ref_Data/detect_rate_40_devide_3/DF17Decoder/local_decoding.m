function [ Lat , Lon ] = local_decoding( DATAME_on_BIN )
% ---> 该函数的作用是本地解码，输入ME 字段的2 进制编码，解算出飞机的经度和纬度<---
% ---> 输入DATAME_on_BIN，输出Lat 和Lon <---
% ---> 注意：需要留意改动的地方是参考经纬度位置Lat_ref 和Lon_ref 是手动输入的，应该注意要留的是接收机本地位置<---


ENCODE_WAY = check_encoding_method( DATAME_on_BIN ); % 检查编码方式
NZ = 15; % 纬度区数量
Lat_ref = 42; Lon_ref = 108; % 给定参考经纬度位置
[ Lat_cpr , Lon_cpr ] = calculate_LATandLON_CPR( DATAME_on_BIN ); % 计算压缩位置
NL = calculate_number_of_lon_zone( Lat_ref ); % 经度区数量

% >>> 计算dLat <<<
if ( ENCODE_WAY == 0 )
    dLat = 360 / ( 4 * NZ );
elseif ( ENCODE_WAY == 1 )
    dLat = 360 / ( 4 * NZ - 1 );
end

% >>> 计算纬度索引j <<<
j = floor( Lat_ref/dLat ) + floor( mod( Lat_ref , dLat )/dLat - Lat_cpr + 0.5 );

% >>> 计算纬度Lat <<<
Lat = dLat * ( j + Lat_cpr );

% >>> 计算dLon <<<
if ( NL > 0 )
    dLon = 360 / NL;
elseif ( NL == 0 )
    dLon = 360;
end

% >>> 计算经度索引<<<
m = floor( Lon_ref/dLon ) + floor( mod( Lon_ref , dLon )/dLon - Lon_cpr + 0.5 );

% >>> 计算经度<<<
Lon = dLon * ( m + Lon_cpr );
end
