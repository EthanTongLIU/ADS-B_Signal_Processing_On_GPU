function  DF17Decoder(ADSBMES_on_HEX_1)
    T_1 = 45.6; % 该条报文,! 是位置信息
    % ADSBMES_on_HEX_1 = '8D40092760C38037389C0EF0029C'; T_2 = 1; % 该条报文是,! 飞机位置
    NUMBER_of_MES = 1; % -> 读入的报文数量，临时定义，后续需要改掉

    % >>> 处理16 进制报文，将其中的ME 字段以2 进制形式提取出来<<<
    DATAME_on_BIN_1 = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX_1 );
    % DATAME_on_BIN_2 = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX_2 );

    % >>> 将ME 字段中的前5 比特TC 字段提取出来，以此判断应该解码哪类信息<<<
    TC_on_BIN = DATAME_on_BIN_1( 1 : 5 );
    TC_on_DEC = bin2dec( TC_on_BIN );

    if ( TC_on_DEC <= 4 && TC_on_DEC >= 1 )
        disp( '报文信息为：飞机呼号' );
        CALLSIGN = find_callsign( DATAME_on_BIN_1 );
        disp( [ '飞机呼号为：' , CALLSIGN ] );
    elseif ( TC_on_DEC <= 8 && TC_on_DEC >= 5 )
        disp( '报文信息为：地面位置' );
    elseif ( TC_on_DEC <= 18 && TC_on_DEC >= 9 )
        disp( '报文信息为：空中位置（w/Baro Altitude）' );
        if ( NUMBER_of_MES == 1 )
            [ Lat , Lon ] = local_decoding( DATAME_on_BIN_1 ); % -> 若只有一条报,! 文，执行本地解码
            Alt = calculate_altitude( DATAME_on_BIN_1 ); % -> 同时解算高度
            disp( [ '纬度为：' , num2str( Lat ) , '度' ] );
            disp( [ '经度为：' , num2str( Lon ) , '度' ] );
            disp( [ '高度为：' , num2str( Alt ) , 'ft' ] );
        elseif ( NUMBER_of_MES == 2 )
            % >> 若收到两条报文，首先检查两条报文的编码方式<<
            % >> 若编码方式相同，选取一条最新收到的报文执行本地解码<<
            % >> 若编码方式不同，执行全球解码<<
            ENCODE_WAY_1 = check_encoding_method( DATAME_on_BIN_1 );
            ENCODE_WAY_2 = check_encoding_method( DATAME_on_BIN_2 );
            if ( ENCODE_WAY_1 == ENCODE_WAY_2 )
                if ( T_1 >= T_2 )
                    [ Lat , Lon ] = local_decoding( DATAME_on_BIN_1 );
                    Alt = calculate_altitude( DATAME_on_BIN_1 );
                    disp( [ '纬度为：' , num2str( Lat ) , '度' ] );
                    disp( [ '经度为：' , num2str( Lon ) , '度' ] );
                    disp( [ '高度为：' , num2str( Alt ) , 'ft' ] );
                else
                    [ Lat , Lon ] = local_decoding( DATAME_on_BIN_2 );
                    Alt = calculate_altitude( DATAME_on_BIN_1 );
                    disp( [ '纬度为：' , num2str( Lat ) , '度' ] );
                    disp( [ '经度为：' , num2str( Lon ) , '度' ] );
                    disp( [ '高度为：' , num2str( Alt ) , 'ft' ] );
                end
            else
                [ Lat , Lon ] = global_decoding( DATAME_on_BIN_1 , DATAME_on_BIN_2 , T_1 , T_2 );
                Alt = calculate_altitude( DATAME_on_BIN_1 );
                disp( [ '纬度为：' , num2str( Lat ) , '度' ] );
                disp( [ '经度为：' , num2str( Lon ) , '度' ] );
                disp( [ '高度为：' , num2str( Alt ) , 'ft' ] );
            end
        end
    elseif ( TC_on_DEC == 19 )
        disp( '报文信息为：飞机速度' );
        % >> 检测速度信息子类型，判断应该解码地速还是空速<<
        SUBTYPE_of_SPEED = check_subtype_of_speed( DATAME_on_BIN_1 );
        switch SUBTYPE_of_SPEED
            case 1
                [VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] =calculate_ground_speed( DATAME_on_BIN_1);
                disp( '>>> 地面速度<<<' );
                disp( [ '水平速度：' , num2str( VELOCITY ) , ' 节' ] );
                disp( [ '水平航向：' , num2str( HEADING ) , ' 度' ] );
                disp( [ '垂直速率：' , num2str( VERTICAL_RATE ) , ' 英尺/分钟' ] );
                disp( [ '垂直速率源：' , VERTICAL_RATE_SOURCE ] );
            case 2
                disp( '该飞机为超音速飞机，目前无法解码其速度！' );
            case 3
                [ VELOCITY_TYPE , VELOCITY , HEADING , VERTICAL_RATE ,VERTICAL_RATE_SOURCE ] = calculate_air_speed(DATAME_on_BIN_1 );
                disp( [ '>>> ' , VELOCITY_TYPE , ' <<<' ] );
                disp( [ '水平速度：' , num2str( VELOCITY ) , ' 节' ] );
                disp( [ '水平航向：' , num2str( HEADING ) , ' 度' ] );
                disp( [ '垂直速率：' , num2str( VERTICAL_RATE ) , ' 英尺/分钟' ]);
                disp( [ '垂直速率源：' , VERTICAL_RATE_SOURCE ] );
            case 4
                disp( '该飞机为超音速飞机，目前无法解码其速度！' );
        end
    elseif ( TC_on_DEC <= 22 && TC_on_DEC >= 20 )
        disp( '报文信息为：空中位置（w/GNSS Height）' );
    elseif ( TC_on_DEC <= 31 && TC_on_DEC >= 23 )
        disp( '报文信息为：预留信息' );
    else
        disp( '信息类型错误，请重新输入！' );
        return;
    end
end