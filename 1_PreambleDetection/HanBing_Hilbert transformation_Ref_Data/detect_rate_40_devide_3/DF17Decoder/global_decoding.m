function [ Lat , Lon ] = global_decoding( DATAME_on_BIN_1 , DATAME_on_BIN_2, T_1 , T_2 )
% ---> �ú�������ȫ����룬ʹ�ñ��뷽ʽ��ͬ��������Ϣ���㾭γ��λ��<---
% ---> ����DATAME_on_BIN_1�� DATAME_on_BIN_2�� T_1 ��T_2������T_1 ��T_2 �� ���Ӧ�������ĵĽ���ʱ�䣬���Lat ��Lon <---
% ---> ע�⣺��������������ڴ���֮ǰ����ȷ�����ǵı��뷽ʽ��ͬ<---

NZ = 15; % γ��������

% >>> �ж��������ĵı��뷽ʽ����������<<<
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

% >>> ����ѹ����γ��λ�ã�Lat_cpr_even��Lon_cpr_even��Lat_cpr_odd��Lon_cpr_odd<<<
[ Lat_cpr_even , Lon_cpr_even ] = calculate_LATandLON_CPR(DATAME_on_BIN_EVEN );
[ Lat_cpr_odd , Lon_cpr_odd ] = calculate_LATandLON_CPR( DATAME_on_BIN_ODD );

% >>> ����γ������j <<<
j = floor( 59 * Lat_cpr_even - 60 * Lat_cpr_odd + 0.5 );

% >>> ����γ��<<<
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

% >>> ���γ������һ���ԣ��ж������������Ƿ����<<<
NL_even = calculate_number_of_lon_zone( Lat_even );
NL_odd = calculate_number_of_lon_zone( Lat_odd );
if ( NL_even ~= NL_odd )
    disp( 'ȫ����벻���У�' );
    return;
end

% >>> ���㾭��<<<
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
