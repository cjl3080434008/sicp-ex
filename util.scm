(begin
	;�������ֵ
	(define (abs x)
	(if (< x 0)
		(- x)
		x))
	;������ƽ��ֵ
	(define (average x y)
		(/ (+ x y) 2))
	;�ж��Ƿ�ż��	
	(define (even? n)
	(= (remainder n 2) 0))		
)