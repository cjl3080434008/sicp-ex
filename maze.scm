(begin
	(load "ex2.scm")
	(define (make-maze)
	(define (for-each proc things)
		(cond ((null? things) nil)
			  (else	
				(let ((ret (proc (car things))))
					(if (null? ret) (for-each proc (cdr things)) ret)))))
	;�Թ�
	(define maze  '((1 1 1 1 1 1 1 1 1)
					(1 0 1 0 0 0 1 0 1)
					(1 0 1 0 1 0 1 0 1)
					(1 0 1 0 1 0 1 0 1)
					(1 0 0 0 0 0 0 0 1)
					(1 1 1 1 1 1 1 1 1)))
	(define direction '((0 -1)(0 1)(-1 0)(1 0))) ;��������
	(define (get-x-y array-2d x y)
		(list-ref (list-ref array-2d x) y))
	(define (is-close cur path);�Ƿ��Ѿ��߹���·	
		(= 1 (accumulate 
				(lambda (pos sum) 
				(if (and (= (car pos) (car cur)) (= (cadr pos) (cadr cur))) (+ sum 1) sum)) 
			 0 path)))
	;����Ƿ�Ϸ�·��
	(define (check cur dir path)
		(let ((x (+ (car dir) (car cur)))
			  (y (+ (cadr dir) (cadr cur))))
		 (cond ((is-close (list x y) path) nil)
			   ((= (get-x-y maze x y) 1) nil);�赲
			   (else (list x y)))))   ;������һ���Ϸ�������	
				
	;����һ��·��
	(define (find-path-one start target)
		(define (iter cur-step path)
			(define (move dir)
				(let ((next (check cur-step (list-ref direction dir) path)))
					(cond ((null? next) nil)
						  (else (iter next (cons cur-step path))))))						  
			(if (and (= (car target) (car cur-step))
			         (= (cadr target) (cadr cur-step))) (cons cur-step path)
				(for-each move (enumerate-interval 0 3)))	 
		)
		(reverse (iter start nil))
	)
	;��������·��
	(define (find-path-all start target)	
		(define (iter cur-step path)
			(define (move dir)
				(let ((next (check cur-step (list-ref direction dir) path)))
					(cond ((null? next) nil)
						  (else (iter next (cons cur-step path))))))						  
			(cond ((and (= (car target) (car cur-step)) (= (cadr target) (cadr cur-step))) 
				(list (cons cur-step path))) ;����Ŀ�ĵأ�����·��
				  (else
					  (accumulate (lambda (dir p) (append (move dir) p)) nil (enumerate-interval 0 3))))
		)
		(map reverse (iter start nil))
	)
	(lambda (op start target)
		(cond ((eq? op 'find-path-all) (find-path-all start target))
			  ((eq? op 'find-path-one) (find-path-one start target))
			  (else "bad op"))
	))	
)	