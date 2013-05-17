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
	(define (odd? n)
	(= (remainder n 2) 1))
	;��ƽ��
	(define (square x) (* x x))
	;����
	(define (sqrt x)
	  (define (good-enough? guess)
		(< (abs (- (square guess) x)) 0.00000000000001))
	  (define (improve guess)
		(average guess (/ x guess)))
	  (define (sqrt-iter guess)
		(if (good-enough? guess)
			guess
			(sqrt-iter (improve guess))))
	  (sqrt-iter 1.0))
	(define (map proc items)
	  (if (null? items)
		  (list)
		  (cons (proc (car items))
				(map proc (cdr items)))))
	(define nil '())
	(define (accumulate op initial sequence)
	  (if (null? sequence)
		  initial
		  (op (car sequence)
			  (accumulate op initial (cdr sequence)))))
	(define (count-leaves x)
	  (cond ((null? x) 0)
			((not (pair? x)) 1)
			(else (+ (count-leaves (car x))
					 (count-leaves (cdr x))))))			  
)