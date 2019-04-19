function [ Lat , Lon ] = local_decoding( DATAME_on_BIN )
% ---> �ú����������Ǳ��ؽ��룬����ME �ֶε�2 ���Ʊ��룬������ɻ��ľ��Ⱥ�γ��<---
% ---> ����DATAME_on_BIN�����Lat ��Lon <---
% ---> ע�⣺��Ҫ����Ķ��ĵط��ǲο���γ��λ��Lat_ref ��Lon_ref ���ֶ�����ģ�Ӧ��ע��Ҫ�����ǽ��ջ�����λ��<---


ENCODE_WAY = check_encoding_method( DATAME_on_BIN ); % �����뷽ʽ
NZ = 15; % γ��������
Lat_ref = 42; Lon_ref = 108; % �����ο���γ��λ��
[ Lat_cpr , Lon_cpr ] = calculate_LATandLON_CPR( DATAME_on_BIN ); % ����ѹ��λ��
NL = calculate_number_of_lon_zone( Lat_ref ); % ����������

% >>> ����dLat <<<
if ( ENCODE_WAY == 0 )
    dLat = 360 / ( 4 * NZ );
elseif ( ENCODE_WAY == 1 )
    dLat = 360 / ( 4 * NZ - 1 );
end

% >>> ����γ������j <<<
j = floor( Lat_ref/dLat ) + floor( mod( Lat_ref , dLat )/dLat - Lat_cpr + 0.5 );

% >>> ����γ��Lat <<<
Lat = dLat * ( j + Lat_cpr );

% >>> ����dLon <<<
if ( NL > 0 )
    dLon = 360 / NL;
elseif ( NL == 0 )
    dLon = 360;
end

% >>> ���㾭������<<<
m = floor( Lon_ref/dLon ) + floor( mod( Lon_ref , dLon )/dLon - Lon_cpr + 0.5 );

% >>> ���㾭��<<<
Lon = dLon * ( m + Lon_cpr );
end
