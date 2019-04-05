
function [ VELOCITY_TYPE , VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] = calculate_air_speed( DATAME_on_BIN )
% ---> �ú�������ɻ��Ŀ��٣�������Ϣ���Ĳ�ͬ��ѡ�����ָʾ���ٻ�����ʵ���٣� <---
% ---> ����DATAME_on_BIN�����
% VELOCITY_TYPE���������ͣ���Ϊָʾ���ٺ���ʵ���٣����ַ��������
% VELOCITY��ˮƽ�ٶȣ���λ���ڣ���
% HEADING��ˮƽ���򣬵�λ���ȣ����ַ����������
% VERTICAL_RATE����ֱ���ʣ���λ��Ӣ��/���ӣ�����������򲻴����ţ�������½���ǰ����� �ţ���
% VERTICAL_RATE_SOURCE����ֱ������Դ����һ���ַ�������Ϊ��ѹԴ�ͼ���Դ�� <---

% >>> ����ˮƽ�ٶȼ�����<<<
SOURCE_of_HEADING = DATAME_on_BIN( 14 );
if ( strcmp( SOURCE_of_HEADING , '0' ) )
    HEADING = '�޷���ú�����Ϣ��';
elseif ( strcmp( SOURCE_of_HEADING , '1' ) )
    HEADING_on_BIN = DATAME_on_BIN( 15 : 24 );
    HEADING = bin2dec( HEADING_on_BIN ) / 1024 * 360;
    HEADING = num2str( HEADING );
end

VELOCITY_TYPE_on_BIN = DATAME_on_BIN( 25 );
if ( strcmp( VELOCITY_TYPE_on_BIN , '0' ) )
    VELOCITY_TYPE = 'ָʾ����(IAS)';
elseif ( strcmp( VELOCITY_TYPE_on_BIN , '1' ) )
    VELOCITY_TYPE = '��ʵ����(TAS)';
end

VELOCITY_on_BIN = DATAME_on_BIN( 26 : 35 );
VELOCITY = bin2dec( VELOCITY_on_BIN );

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