function [ VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] =calculate_ground_speed( DATAME_on_BIN )
% ---> �ú������������Ϣ<---
% ---> ����DATAME_on_BIN�����
% VELOCITY��ˮƽ�ٶȣ���λ���ڣ���HEADING��ˮƽ���򣬵�λ���ȣ���
% VERTICAL_RATE����ֱ���ʣ���λ��Ӣ��/���ӣ�����������򲻴����ţ�������½���ǰ������ţ���
% VERTICAL_RATE_SOURCE����ֱ������Դ����һ���ַ�������Ϊ��ѹԴ�ͼ���Դ�� <---

% >>> ����ˮƽ�ٶȼ�����<<<
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

% >>> ���㴹ֱ���ʼ�����<<<
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
    VERTICAL_RATE_SOURCE = '��ѹ�߶ȱ仯��';
elseif ( strcmp( VERTICAL_RATE_SOURCE_on_BIN , '1' ) )
    VERTICAL_RATE_SOURCE = '���θ߶ȱ仯��';
end

end