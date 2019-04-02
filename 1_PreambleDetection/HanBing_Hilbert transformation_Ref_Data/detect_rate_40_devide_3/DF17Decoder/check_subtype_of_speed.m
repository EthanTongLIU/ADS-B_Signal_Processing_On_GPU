
function SUBTYPE_of_SPEED = check_subtype_of_speed( DATAME_on_BIN )

SUBTYPE_of_SPEED_on_BIN = DATAME_on_BIN( 6 : 8 );
SUBTYPE_of_SPEED = bin2dec( SUBTYPE_of_SPEED_on_BIN );

end


function [ ENCODE_WAY ] = check_encoding_method( DATAME_on_BIN )

ENCODE_WAY = str2num( DATAME_on_BIN( 22 ) );

end