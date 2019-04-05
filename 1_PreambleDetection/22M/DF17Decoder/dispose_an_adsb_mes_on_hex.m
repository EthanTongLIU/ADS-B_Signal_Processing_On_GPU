function DATAME_on_BIN = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX )
% ---> �ú�������ԭʼ���ģ������Ϊ4 �Σ�����ÿһ��ת��Ϊ2 ���Ʊ�ʾ<---
% ---> ����ADSBMES_on_HEX�����DATAME_on_BIN

% >>>> �����жϱ��ĳ���<<<<
if ( length( ADSBMES_on_HEX ) < 28 )
    disp( '�����������ADS-B ������������������' );
    return;
end

% >>>> ��ԭʼ��Ϣ�ֶ�<<<<
DFandCA_on_HEX = ADSBMES_on_HEX( 1 : 2 );
ICAO24_on_HEX = ADSBMES_on_HEX( 3 : 8 );
DATAME_on_HEX = ADSBMES_on_HEX( 9 : 22 );
PICHECK_on_HEX = ADSBMES_on_HEX( 23 : 28 );

% >>>> ���ֶ�֮�����Ϣת����2 �����ַ���<<<<

% >> ����DF ��CA����16 ����תΪ2 ����<<
DFandCA_on_BIN = dec2bin( hex2dec( DFandCA_on_HEX ) );
if ( length( DFandCA_on_BIN ) < 8 )
    head = num2str( zeros( 1 : 8 - length( DFandCA_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % ʹ���滻ʵ�ֽ�ת������ַ����е����пո�ȥ��
    DFandCA_on_BIN = [ head , DFandCA_on_BIN ];
end
DF_on_BIN = DFandCA_on_BIN( 1 : 5 );
CA_on_BIN = DFandCA_on_BIN( 6 : 8 );

% >> ����DATAME �ֶΣ���16 ����תΪ2 ����<<
DATAME_on_BIN = dec2bin( hex2dec( DATAME_on_HEX ) );
if ( length( DATAME_on_BIN ) < 56 )
    head = num2str( zeros( 1 : 56 - length( DATAME_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % ʹ���滻ʵ�ֽ�ת������ַ����е����пո�ȥ��
    DATAME_on_BIN = [ head , DATAME_on_BIN ];
end

% >> ����PICHECK �ֶΣ���16 ����תΪ2 ����<<
PICHECK_on_BIN = dec2bin( hex2dec( PICHECK_on_HEX ) );
if ( length( PICHECK_on_BIN ) < 24 )
    head = num2str( zeros( 1 : 24 - length( PICHECK_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % ʹ���滻ʵ�ֽ�ת������ַ����е����пո�ȥ��
    PICHECK_on_BIN = [ head , PICHECK_on_BIN ];
end

end











