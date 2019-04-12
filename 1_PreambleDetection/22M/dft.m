function X_k = dft( x , k )
% ���ö������һ�������ɢ����Ҷ�任
% ���� x Ϊʱ���ϵĲ����ź����У�k Ϊ��Ҫ����ĵڼ���ֵ
% ��� X Ϊ�� k �㾭����ɢ����Ҷ�任�Ժ��ֵ

N = length( x );
X_k_Re = 0;
X_k_Im = 0;
for n = 1 : N
    X_k_Re = X_k_Re + x(n) * cos( 2 * pi / N * k * n );
    X_k_Im = X_k_Im + x(n) * sin( 2 * pi / N * k * n );
end

X_k = X_k_Re - 1i * X_k_Im;

end

