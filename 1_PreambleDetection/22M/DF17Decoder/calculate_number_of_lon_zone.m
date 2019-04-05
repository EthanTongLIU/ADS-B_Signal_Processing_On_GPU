
function NL = calculate_number_of_lon_zone( Lat )
% 该函数用于计算某个纬度上对应的经度区的数量

NZ = 15;
NL = floor( 2 * pi / acos( 1 - ( 1 - cos( pi / 2 / NZ ) ) / power( cos( pi * Lat / 180 ) , 2 ) ) );

end