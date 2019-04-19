function [ signal_analytic ] = hilbert_transform( data )

% �����������е���ɢ����Ҷ�任������ѡ���������еĳ���
N = length( data );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( data , k );
end

% ����弤��Ӧ���е���ɢ����Ҷ�任������ѡ���������еĳ���
Y = [ 1i * ones( 1 , ( N - 1 ) / 2 ) , -1i , - 1i * ones( 1 , ( N - 1 ) / 2 ) ];

% Ƶ�����
H = X .* Y;

% ʹ�� IDFT ����������У��õ�ԭʼ�źŵ� Hilbert �任���������źŵ��鲿
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

% ���������źţ��� Hilbert �任���������Ϊ�鲿
signal_analytic = data + 1i * real( h ); % �鲿��΢С�Ŷ���ȥ��ֻ����ʵ��

signal_analytic = abs( signal_analytic );

end

