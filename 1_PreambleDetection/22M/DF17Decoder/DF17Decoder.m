function  DF17Decoder(ADSBMES_on_HEX_1)
    T_1 = 45.6; % ��������,! ��λ����Ϣ
    % ADSBMES_on_HEX_1 = '8D40092760C38037389C0EF0029C'; T_2 = 1; % ����������,! �ɻ�λ��
    NUMBER_of_MES = 1; % -> ����ı�����������ʱ���壬������Ҫ�ĵ�

    % >>> ����16 ���Ʊ��ģ������е�ME �ֶ���2 ������ʽ��ȡ����<<<
    DATAME_on_BIN_1 = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX_1 );
    % DATAME_on_BIN_2 = dispose_an_adsb_mes_on_hex( ADSBMES_on_HEX_2 );

    % >>> ��ME �ֶ��е�ǰ5 ����TC �ֶ���ȡ�������Դ��ж�Ӧ�ý���������Ϣ<<<
    TC_on_BIN = DATAME_on_BIN_1( 1 : 5 );
    TC_on_DEC = bin2dec( TC_on_BIN );

    if ( TC_on_DEC <= 4 && TC_on_DEC >= 1 )
        disp( '������ϢΪ���ɻ�����' );
        CALLSIGN = find_callsign( DATAME_on_BIN_1 );
        disp( [ '�ɻ�����Ϊ��' , CALLSIGN ] );
    elseif ( TC_on_DEC <= 8 && TC_on_DEC >= 5 )
        disp( '������ϢΪ������λ��' );
    elseif ( TC_on_DEC <= 18 && TC_on_DEC >= 9 )
        disp( '������ϢΪ������λ�ã�w/Baro Altitude��' );
        if ( NUMBER_of_MES == 1 )
            [ Lat , Lon ] = local_decoding( DATAME_on_BIN_1 ); % -> ��ֻ��һ����,! �ģ�ִ�б��ؽ���
            Alt = calculate_altitude( DATAME_on_BIN_1 ); % -> ͬʱ����߶�
            disp( [ 'γ��Ϊ��' , num2str( Lat ) , '��' ] );
            disp( [ '����Ϊ��' , num2str( Lon ) , '��' ] );
            disp( [ '�߶�Ϊ��' , num2str( Alt ) , 'ft' ] );
        elseif ( NUMBER_of_MES == 2 )
            % >> ���յ��������ģ����ȼ���������ĵı��뷽ʽ<<
            % >> �����뷽ʽ��ͬ��ѡȡһ�������յ��ı���ִ�б��ؽ���<<
            % >> �����뷽ʽ��ͬ��ִ��ȫ�����<<
            ENCODE_WAY_1 = check_encoding_method( DATAME_on_BIN_1 );
            ENCODE_WAY_2 = check_encoding_method( DATAME_on_BIN_2 );
            if ( ENCODE_WAY_1 == ENCODE_WAY_2 )
                if ( T_1 >= T_2 )
                    [ Lat , Lon ] = local_decoding( DATAME_on_BIN_1 );
                    Alt = calculate_altitude( DATAME_on_BIN_1 );
                    disp( [ 'γ��Ϊ��' , num2str( Lat ) , '��' ] );
                    disp( [ '����Ϊ��' , num2str( Lon ) , '��' ] );
                    disp( [ '�߶�Ϊ��' , num2str( Alt ) , 'ft' ] );
                else
                    [ Lat , Lon ] = local_decoding( DATAME_on_BIN_2 );
                    Alt = calculate_altitude( DATAME_on_BIN_1 );
                    disp( [ 'γ��Ϊ��' , num2str( Lat ) , '��' ] );
                    disp( [ '����Ϊ��' , num2str( Lon ) , '��' ] );
                    disp( [ '�߶�Ϊ��' , num2str( Alt ) , 'ft' ] );
                end
            else
                [ Lat , Lon ] = global_decoding( DATAME_on_BIN_1 , DATAME_on_BIN_2 , T_1 , T_2 );
                Alt = calculate_altitude( DATAME_on_BIN_1 );
                disp( [ 'γ��Ϊ��' , num2str( Lat ) , '��' ] );
                disp( [ '����Ϊ��' , num2str( Lon ) , '��' ] );
                disp( [ '�߶�Ϊ��' , num2str( Alt ) , 'ft' ] );
            end
        end
    elseif ( TC_on_DEC == 19 )
        disp( '������ϢΪ���ɻ��ٶ�' );
        % >> ����ٶ���Ϣ�����ͣ��ж�Ӧ�ý�����ٻ��ǿ���<<
        SUBTYPE_of_SPEED = check_subtype_of_speed( DATAME_on_BIN_1 );
        switch SUBTYPE_of_SPEED
            case 1
                [VELOCITY , HEADING , VERTICAL_RATE , VERTICAL_RATE_SOURCE ] =calculate_ground_speed( DATAME_on_BIN_1);
                disp( '>>> �����ٶ�<<<' );
                disp( [ 'ˮƽ�ٶȣ�' , num2str( VELOCITY ) , ' ��' ] );
                disp( [ 'ˮƽ����' , num2str( HEADING ) , ' ��' ] );
                disp( [ '��ֱ���ʣ�' , num2str( VERTICAL_RATE ) , ' Ӣ��/����' ] );
                disp( [ '��ֱ����Դ��' , VERTICAL_RATE_SOURCE ] );
            case 2
                disp( '�÷ɻ�Ϊ�����ٷɻ���Ŀǰ�޷��������ٶȣ�' );
            case 3
                [ VELOCITY_TYPE , VELOCITY , HEADING , VERTICAL_RATE ,VERTICAL_RATE_SOURCE ] = calculate_air_speed(DATAME_on_BIN_1 );
                disp( [ '>>> ' , VELOCITY_TYPE , ' <<<' ] );
                disp( [ 'ˮƽ�ٶȣ�' , num2str( VELOCITY ) , ' ��' ] );
                disp( [ 'ˮƽ����' , num2str( HEADING ) , ' ��' ] );
                disp( [ '��ֱ���ʣ�' , num2str( VERTICAL_RATE ) , ' Ӣ��/����' ]);
                disp( [ '��ֱ����Դ��' , VERTICAL_RATE_SOURCE ] );
            case 4
                disp( '�÷ɻ�Ϊ�����ٷɻ���Ŀǰ�޷��������ٶȣ�' );
        end
    elseif ( TC_on_DEC <= 22 && TC_on_DEC >= 20 )
        disp( '������ϢΪ������λ�ã�w/GNSS Height��' );
    elseif ( TC_on_DEC <= 31 && TC_on_DEC >= 23 )
        disp( '������ϢΪ��Ԥ����Ϣ' );
    else
        disp( '��Ϣ���ʹ������������룡' );
        return;
    end
end