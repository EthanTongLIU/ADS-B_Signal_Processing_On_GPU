function CALLSIGN = find_callsign( DATAME_on_BIN )
% ---> 该函数用于解算飞机的呼号<---
% ---> 输入DATAME_on_BIN，输出CALLSIGN <---

DECODE_SEQUENCE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#####_###############0123456789######';

EC_on_BIN = DATAME_on_BIN( 6 : 8 ); % -> EC 是航空器种类
EC_on_DEC = bin2dec( EC_on_BIN );
if ( EC_on_DEC == 0 )
    AIRCRAFT_TYPE = 'NOT AVAIABLE';
end

CALLSIGN = '00000000';
for k = 1 : 8
    INDEX_on_DEC = bin2dec( DATAME_on_BIN( (9+(k-1)*6) : (9+(k-1)*6+5) ) );
    CALLSIGN( k ) = DECODE_SEQUENCE( INDEX_on_DEC );
end

end
