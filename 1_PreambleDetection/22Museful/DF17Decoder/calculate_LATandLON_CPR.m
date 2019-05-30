
function [ Lat_cpr , Lon_cpr ] = calculate_LATandLON_CPR( DATAME_on_BIN )

LAT_CPR_on_BIN = DATAME_on_BIN( 23 : 39 );
LON_CPR_on_BIN = DATAME_on_BIN( 40 : 56 );

Lat_cpr = bin2dec( LAT_CPR_on_BIN ) / 131072;
Lon_cpr = bin2dec( LON_CPR_on_BIN ) / 131072;

end
