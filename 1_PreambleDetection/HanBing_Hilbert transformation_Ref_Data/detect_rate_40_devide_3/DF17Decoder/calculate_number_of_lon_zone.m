
function NL = calculate_number_of_lon_zone( Lat )
% �ú������ڼ���ĳ��γ���϶�Ӧ�ľ�����������

NZ = 15;
NL = floor( 2 * pi / acos( 1 - ( 1 - cos( pi / 2 / NZ ) ) / power( cos( pi * Lat / 180 ) , 2 ) ) );

end