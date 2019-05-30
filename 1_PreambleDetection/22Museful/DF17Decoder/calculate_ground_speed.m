function [ VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] =calculate_ground_speed( DATAME_on_BIN )
% ---> 该函数计算地速信息<---
% ---> 输入DATAME_on_BIN，输出
% VELOCITY（水平速度，单位：节），HEADING（水平航向，单位：度），
% VERTICAL_RATE（垂直速率，单位：英尺/分钟，如果是上升则不带符号，如果是下降则前面带负号），
% VERTICAL_RATE_SOURCE（垂直速率来源，是一个字符串，分为气压源和几何源） <---

% >>> 计算水平速度及航向<<<
SIGN_EW_on_BIN = DATAME_on_BIN( 14 );
VELOCITY_EW_on_BIN = DATAME_on_BIN( 15 : 24 );
SIGN_NS_on_BIN = DATAME_on_BIN( 25 );
VELOCITY_NS_on_BIN = DATAME_on_BIN( 26 : 35 );

VELOCITY_EW = bin2dec( VELOCITY_EW_on_BIN );
VELOCITY_NS = bin2dec( VELOCITY_NS_on_BIN );

if ( strcmp( SIGN_EW_on_BIN , '1' ) )
    VELOCITY_WE = -1 * ( VELOCITY_EW - 1 );
elseif ( strcmp( SIGN_EW_on_BIN , '0' ) )
    VELOCITY_WE = VELOCITY_EW - 1;
end

if ( strcmp( SIGN_NS_on_BIN , '1' ) )
    VELOCITY_SN = -1 * ( VELOCITY_NS - 1 );
elseif ( strcmp( SIGN_NS_on_BIN , '0' ) )
    VELOCITY_SN = VELOCITY_NS - 1;
end

VELOCITY = sqrt( VELOCITY_WE^2 + VELOCITY_SN^2 );
HEADING = atan2( VELOCITY_WE , VELOCITY_SN ) * 360 / ( 2 * pi );
if ( HEADING < 0 )
    HEADING = HEADING + 360;
end

% >>> 计算垂直速率及方向<<<
SIGN_of_VERTICAL_RATE_on_BIN = DATAME_on_BIN( 37 );
VERTICAL_RATE_on_BIN = DATAME_on_BIN( 38 : 46 );
VERTICAL_RATE = 64 * ( bin2dec( VERTICAL_RATE_on_BIN ) - 1 );
if ( strcmp( SIGN_of_VERTICAL_RATE_on_BIN , '0' ) )
    VERTICAL_RATE = +VERTICAL_RATE;
elseif ( strcmp( SIGN_of_VERTICAL_RATE_on_BIN , '1' ) )
    VERTICAL_RATE = -VERTICAL_RATE;
end

VERTICAL_RATE_SOURCE_on_BIN = DATAME_on_BIN( 36 );
if ( strcmp( VERTICAL_RATE_SOURCE_on_BIN , '0' ) )
    VERTICAL_RATE_SOURCE = '气压高度变化率';
elseif ( strcmp( VERTICAL_RATE_SOURCE_on_BIN , '1' ) )
    VERTICAL_RATE_SOURCE = '几何高度变化率';
end

end