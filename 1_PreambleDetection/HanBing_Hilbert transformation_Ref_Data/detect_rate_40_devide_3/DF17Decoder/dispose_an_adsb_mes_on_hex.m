function DATAME_on_BIN = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX )
% ---> 该函数处理原始报文，将其分为4 段，并将每一段转换为2 进制表示<---
% ---> 输入ADSBMES_on_HEX，输出DATAME_on_BIN

% >>>> 初步判断报文长度<<<<
if ( length( ADSBMES_on_HEX ) < 28 )
    disp( '错诶！传入的ADS-B 报文有误，请重新输入' );
    return;
end

% >>>> 将原始信息分段<<<<
DFandCA_on_HEX = ADSBMES_on_HEX( 1 : 2 );
ICAO24_on_HEX = ADSBMES_on_HEX( 3 : 8 );
DATAME_on_HEX = ADSBMES_on_HEX( 9 : 22 );
PICHECK_on_HEX = ADSBMES_on_HEX( 23 : 28 );

% >>>> 将分段之后的信息转化成2 进制字符串<<<<

% >> 解算DF 和CA，将16 进制转为2 进制<<
DFandCA_on_BIN = dec2bin( hex2dec( DFandCA_on_HEX ) );
if ( length( DFandCA_on_BIN ) < 8 )
    head = num2str( zeros( 1 : 8 - length( DFandCA_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % 使用替换实现将转化后的字符串中的所有空格去掉
    DFandCA_on_BIN = [ head , DFandCA_on_BIN ];
end
DF_on_BIN = DFandCA_on_BIN( 1 : 5 );
CA_on_BIN = DFandCA_on_BIN( 6 : 8 );

% >> 处理DATAME 字段，将16 进制转为2 进制<<
DATAME_on_BIN = dec2bin( hex2dec( DATAME_on_HEX ) );
if ( length( DATAME_on_BIN ) < 56 )
    head = num2str( zeros( 1 : 56 - length( DATAME_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % 使用替换实现将转化后的字符串中的所有空格去掉
    DATAME_on_BIN = [ head , DATAME_on_BIN ];
end

% >> 处理PICHECK 字段，将16 进制转为2 进制<<
PICHECK_on_BIN = dec2bin( hex2dec( PICHECK_on_HEX ) );
if ( length( PICHECK_on_BIN ) < 24 )
    head = num2str( zeros( 1 : 24 - length( PICHECK_on_BIN ) ) );
    head = strrep( head , ' ' , '' ); % 使用替换实现将转化后的字符串中的所有空格去掉
    PICHECK_on_BIN = [ head , PICHECK_on_BIN ];
end

end











