function Alt = calculate_altitude( DATAME_on_BIN )
% ---> 该函数计算飞机的高度<---
% ---> 输入DATAME_on_BIN ，输出Alt

ALT_on_BIN_FALSE = DATAME_on_BIN( 9 : 20 );
ALT_ENCODE_WAY = ALT_on_BIN_FALSE( 8 );
if ( ALT_ENCODE_WAY == '0' )
    WEIGHT = 100;
elseif ( ALT_ENCODE_WAY == '1' )
    WEIGHT = 25;
end

ALT_on_BIN = [ ALT_on_BIN_FALSE( 1 : 7 ) , ALT_on_BIN_FALSE( 9 : 12 ) ];
ALT_on_DEC = bin2dec( ALT_on_BIN );
Alt = ALT_on_DEC * WEIGHT - 1000;

end