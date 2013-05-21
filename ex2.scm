(begin
	(load "ex1.scm")
	;(define (make-rat n d) (cons n d))
	(define (numer x) (car x))
	(define (denom x) (cdr x))

	(define (print-rat x)
	  (display (numer x))
	  (display "/")
	  (display (denom x))
	  (newline))
	;ex 2.1	
	(define (positive? x) (> x 0))	
    (define (negative? x) (< x 0))
	(define (make-rat n d)
		(let ((g (gcd n d)))
		(if (positive? (* n d))
			(cons (/ (abs n) g) (/ (abs d) g))
			(cons (/ (- (abs n)) g) (/ (abs d) g)))))
	;ex 2.2
	(define (make-point x y)
		(cons x y))
	(define (x-point p)(car p))
	(define (y-point p)(cdr p))
	
	(define (print-point p)
		(display "x:")
		(display (x-point p))
		(display " y:")
		(display (y-point p))
		(newline)
	)
	(define (make-segment p1 p2) (cons p1 p2))
	(define (start-segment s)(car s))
	(define (end-segment s)(cdr s))
	(define (print-segment s)
		(display "[start:")
		(display (x-point (start-segment s)))
		(display " ")
		(display (y-point (start-segment s)))
		(display "] ")
		(display "[end:")
		(display (x-point (end-segment s)))
		(display " ")
		(display (y-point (end-segment s)))
		(display "]")
		(newline)		
	)
	;�߶γ���
	(define (length-segment s)
		(sqrt (+ (square (- (x-point (start-segment s)) (x-point (end-segment s))))
			 (square (- (y-point (start-segment s)) (y-point (end-segment s)))))))
	;�߶��е�		 
	(define (midpoint-segment s)
		(make-point (average (x-point (start-segment s)) (x-point (end-segment s))) 
		(average (y-point (start-segment s)) (y-point (end-segment s)))))
	;ex 2.3
    ;ʹ��2�˵㶨�����
	(define (make-rectangle t-left b-right)
		(if (= (y-point t-left) (y-point b-right))
			(error "can't make a rectangle");������㹹�ɵ��߶�ƽ����x�����޷����ɾ���
			(cons t-left b-right)))
	(define (top-left r) (car r))
	(define (bottom-right r) (cdr r))
	;������ε��ܳ�		
	(define (perimeter-rectangle r)
		(* 2
		(+ (abs (- (y-point (top-left r)) (y-point (bottom-right r))))
		   (abs (- (x-point (top-left r)) (x-point (bottom-right r)))))))
	;����������
	(define (area-rectangle r)
		(* (abs (- (y-point (top-left r)) (y-point (bottom-right r))))
		   (abs (- (x-point (top-left r)) (x-point (bottom-right r))))))
	;ex 2.4
	(define (cons1 x y)
		(lambda (m) (m x y)))
	(define (car1 z)
		(z (lambda (p q) p)))
	(define (cdr1 z)
		(z (lambda (p q) q)))
	;ex 2.5 ���� 2^2 * 3^3�Ķ����Ʊ�ʾ,ע:��Բ����и���
	(define (cons2 x y) (* (fast-expt 2 x) (fast-expt 3 y)))
	(define (car2 z)
		(define (iter n z)
			(if (= (remainder z 2) 0)
				(iter (+ n 1) (/ z 2))
				 n))
		(iter 0 z))
	(define (cdr2 z)
		(define (iter n z)
			(if (= (remainder z 3) 0)
				(iter (+ n 1) (/ z 3))
				 n))
		(iter 0 z))
	;ex 2.17	
	(define (last-pair p)
		(define (last-pair-imp front back)
			(if (null? back)
				(list front)
				(last-pair-imp (car back) (cdr back))))
		(if (null? p)
			p
			(last-pair-imp (car p) (cdr p))))
	;ex 2.18
	;�ݹ�
	(define (reverse p)
		(define (reverse-pair-imp front back)
			(cond ((null? back) (list front))
				  (else (append (reverse-pair-imp (car back) (cdr back)) (list front)))))
		(if (null? p)
			p
			(reverse-pair-imp (car p) (cdr p))))
	;����
	(define (reverse2 items)
	  (define (iter things answer)
		(if (null? things)
			answer
			(iter (cdr things) 
				  (cons (car things)
						answer))))
	  (iter items nil))			
	;ex 2.19
	(define us-coins (list 50 25 10 5 1))
	(define uk-coins (list 100 50 20 10 5 2 1 0.5))
	;: (cc 100 us-coins)
	(define no-more? null?)
	(define except-first-denomination cdr)
	(define first-denomination car)
	(define (cc amount coin-values)
	  (cond ((= amount 0) 1)
			((or (< amount 0) (no-more? coin-values)) 0)
			(else
			 (+ (cc amount
					(except-first-denomination coin-values))
				(cc (- amount
					   (first-denomination coin-values))
					coin-values)))))			
	;ex 2.20
	(define (same-parity x . y)
		(define (same-parity-imp checker front back)
			(define (process front) (if (checker front)(list front)nil))	
			(if (null? back)(process front)
				(append (process front) (same-parity-imp checker (car back) (cdr back)))))
		(if (even? x) (same-parity-imp even? x y)
			(same-parity-imp odd? x y)))
	;ex 2.21
	(define (square-list1 items)
		(map square items))
	;ex 2.22
	(define (square-list2 items)
	  (define (iter things answer)
		(if (null? things)
			answer
			(iter (cdr things) 
				  (cons (square (car things))
						answer))))
	  (reverse2 (iter items nil)))
	 ;ex 2.23
	(define (for-each proc items)
	  (define (iter things)
		(cond ((null? things))
			(else
				(proc (car things))
				(iter (cdr things)))))
	 (iter items))
	;ex 2.27
	(define (deep-reverse tree)
		(cond ((null? tree) nil)
			  ((not (pair? tree)) tree)
              (else (reverse (map deep-reverse tree)))))		  
	;ex 2.28
	(define (fringe tree)
		(cond ((null? tree) nil)
			  ((not (pair? tree))(list tree))
			  (else (append (fringe (car tree)) (fringe (cdr tree))))))
	;ex 2.30 ʹ��map
	(define (square-tree tree)
			(cond ((null? tree) nil)
			((not (pair? tree)) (square tree))
            (else (map square-tree tree))))
	;ex 2.30ֱ�Ӷ���		
	(define (square-tree2 tree)
		(cond ((null? tree) nil)
			((not (pair? tree)) (square tree))
			(else (cons (square-tree2 (car tree))
						(square-tree2 (cdr tree))))))
	;ex 2.31
	(define (tree-map func tree)
		(define (tree-map-imp tree)
				(cond ((null? tree) nil)
				((not (pair? tree)) (func tree))
				(else (map tree-map-imp tree))))
		(tree-map-imp tree))
	(define (square-tree3 tree) (tree-map square tree))
	;ex 2.32 �����Ӽ��ϵķ�ʽ,������a�ֳ�������(front back)
	;a���Ӽ��� = back���Ӽ��� + ��front���뵽back�������Ӽ����в����ļ��� 
	(define (subsets s)
	  (if (null? s)
		  (list nil)
		  (let ((rest (subsets (cdr s))))
			(display "rest:")(display rest)(newline)
			(append rest (map (lambda (rest) (cons (car s) rest)) rest)))))
	;ex 2.33
	(define (map2 p sequence)
		(accumulate (lambda (x y) (cons (p x) y)) nil sequence))
	(define (append2 seq1 seq2)
		(accumulate cons seq2 seq1))
	(define (length2 sequence)
		(accumulate (lambda (_ counter) (+ 1 counter)) 0 sequence))
	;ex 2.34
	(define (horner-eval x coefficient-sequence)
	  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
	  		  0
	  		  coefficient-sequence))
	;: (horner-eval 2 (list 1 3 0 5 0 1))
	;ex 2.35
	(define (count-leaves2 t)
		(define (cal node count)
			(if (pair? node) (+ (accumulate cal 0 node) count);��ǰ�ڵ��Ҷ����+�����ֵܵ�Ҷ����
				(+ 1 count))
		)
		(accumulate cal 0 t))
	
	;map fringe��((1 11) 10 (2 (3 4 5 (7 8))))) չ���� ((1 11) (10) (2 3 4 5 7 8))
	;�ֱ����ÿ���ӱ��length�ۼӼ���	
	(define (count-leaves3 t)	
		(accumulate (lambda (node counter) (+ (length node) counter)) 0 (map fringe t)))
	;ex 2.36
	(define a_s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))
	(define (accumulate-n op init seqs)
	  (if (null? (car seqs))
		  nil
		  (cons (accumulate op init (map car seqs))
				(accumulate-n op init (map cdr seqs)))))
	;ex 2.37
	(define _mat (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))
	(define (transpose mat) ;����ת��
		(accumulate-n cons nil mat))
	;����������ȥ...
	
	;ex 2.38
	;fold-right��fold-left����Ҫ����
	;fold-right op�����ȱ�Ӧ�õ����ұߵĳ�Ա
	;fold-left  op���ȱ�Ӧ�õ�����ߵĳ�Ա
	;Ҫ��op��fold-right��fold-left���κ��������ж������ͬ�Ľ��,op�������㽻����
	(define fold-right accumulate)
	(define (fold-left op initial sequence)
	  (define (iter result rest)
		(if (null? rest)
			result
			(iter (op result (car rest))
				  (cdr rest))))
	  (iter initial sequence))
	;ex 2.39
	(define (reverse3 sequence)
		(fold-right (lambda (x y) (append y (list x))) nil sequence))
	(define (reverse4 sequence)
		(fold-left (lambda (x y) (cons y x)) nil sequence))
	;ex 2.40
	(define (unique-pairs n)
		(define (process i)
			(map (lambda (j) (list i j)) (enumerate-interval 1 (- i 1)))
		)
	 (accumulate append nil (map process (enumerate-interval 1 n))))
	(define (prime-sum? pair)
		(prime? (+ (car pair) (cadr pair))))

	(define (make-pair-sum pair)
		(list (car pair) (cadr pair) (+ (car pair) (cadr pair))))	 
	(define (prime-sum-pairs n)
		(map make-pair-sum (filter prime-sum? (unique-pairs n))))
	;ex 2.41
	;	(define (m-pairs n m)
	;		(define (iter i j l ret now)
	;			(if (< j 1)
	;				(cons now ret)
	;				(accumulate
	;				 append
	;				 nil
	;				 (map (lambda (x)
	;						(iter (- i x) (- j 1) (- x 1) ret (cons x now)))
	;					  (enumerate-interval 1 l)))))
	;		(iter n m n nil nil))
	;(define (unique-pairs n) (m-pairs n 2))
	
	;����һ���б�,������ȡn�����м���
	;����(a b c d)->((a b c) (a c d) (a b d) (b c d))
	;����򵥵�����������һ���,�Ժ���ʽ���Ի��ǲ��찡
	(define (pick-n seq n)
		;(d-table (1 2 3) 2)->((1 2 3) (1 2))
		;(d-table (1 2 3) 1)->((1 2 3) (1 2) (1))
		;(d-table (1 2 3) 3)->((1 2 3))
		(define (d-table seq n)
			(cond ((= n 0) nil)
				  (else
					(if (<= (length seq) n) (list seq)
						(cons seq (d-table (cdr seq) n ))))))
		
		;(((1 2)(3 4))(5 6))->((1 2)(3 4)(5 6))
		(define (expand seq)
			(define (iter seq ret)
				(cond ((not (pair? seq)) ret)
					  ((pair? (car seq))
						(let ((ret2 (iter (car seq) ret)))
							 (iter (cdr seq) ret2)))	
					  (else (cons seq ret)))		  	
			)
			(iter seq nil)
		)	
		(define (process seq)
			(let ((size (length seq)))
				(cond ((<= n 1) (if (pair? seq) (list (car seq)) seq))
					  ((<= size n) seq)	
					  (else 
						(map (lambda (x)(cons (car seq) x)) (pick-n (cdr seq) (- n 1))))))					  
		)
		(expand (map process (d-table seq n)))
	)

	(define (unique-pairs2 n) (pick-n (enumerate-interval 1 n) 2))
	(define (3-pairs n) (pick-n (enumerate-interval 1 n) 3))
	(define (m-pairs n m) (pick-n (enumerate-interval 1 n) m))
)