
function [ VELOCITY_TYPE , VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] = calculate_air_speed( DATAME_on_BIN )
% ---> 该函数解码飞机的空速（根据信息类别的不同，选择输出指示空速或者真实空速） <---
% ---> 输入DATAME_on_BIN，输出
% VELOCITY_TYPE（空速类型，分为指示空速和真实空速，以字符串输出）
% VELOCITY（水平速度，单位：节），
% HEADING（水平航向，单位：度，以字符串输出），
% VERTICAL_RATE（垂直速率，单位：英尺/分钟，如果是上升则不带符号，如果是下降则前面带负 号），
% VERTICAL_RATE_SOURCE（垂直速率来源，是一个字符串，分为气压源和几何源） <---

% >>> 计算水平速度及航向<<<
SOURCE_of_HEADING = DATAME_on_BIN( 14 );
if ( strcmp( SOURCE_of_HEADING , '0' ) )
    HEADING = '无法获得航向信息！';
elseif ( strcmp( SOURCE_of_HEADING , '1' ) )
    HEADING_on_BIN = DATAME_on_BIN( 15 : 24 );
    HEADING = bin2dec( HEADING_on_BIN ) / 1024 * 360;
    HEADING = num2str( HEADING );
end

VELOCITY_TYPE_on_BIN = DATAME_on_BIN( 25 );
if ( strcmp( VELOCITY_TYPE_on_BIN , '0' ) )
    VELOCITY_TYPE = '指示空速(IAS)';
elseif ( strcmp( VELOCITY_TYPE_on_BIN , '1' ) )
    VELOCITY_TYPE = '真实空速(TAS)';
end

VELOCITY_on_BIN = DATAME_on_BIN( 26 : 35 );
VELOCITY = bin2dec( VELOCITY_on_BIN );

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