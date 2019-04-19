function x_n = idft( X , n )
% ���ö������һ�������ɢ����Ҷ��任
% ���� X Ϊ���� DFT ֮���Ƶ���ź����У�n Ϊ��Ҫ����ĵ� n ����� IDFT
% ��� x_n �� n ����� IDFT 

N = length( X );
x_n_Re = 0;
x_n_Im = 0;
for k = 1 : N
    x_n_Re = x_n_Re + X(k) * cos( 2 * pi / N * k * n );
    x_n_Im = x_n_Im + X(k) * sin( 2 * pi / N * k * n );
end

x_n = 1 / N * ( x_n_Re + 1i * x_n_Im );

end

