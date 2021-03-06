(begin
	(define nil-node (list 0 0 'black '() '() '()))
	;红黑树节点的定义
	;节点结构如下
	;(key (val (color (parent (left (right nil))))))
	
	(define (make-rb-node key val)
		(list key val 'red '() '() '())
	)
		
	(define (get-key rbnode)
		(car rbnode))
	
	(define (get-val rbnode)
		(cadr rbnode))
	
	(define (set-val! rbnode val)
		(set-car! (cdr rbnode) val))
	
	(define (get-color rbnode)
		(caddr rbnode))
	
	(define (set-color! rbnode color)
		(set-car! (cddr rbnode) color))
		
	(define (get-parent rbnode)
		(cadddr rbnode))	
	
	(define (set-parent! rbnode parent)
		(if (not (equal? rbnode nil-node))
		(set-car! (cdddr rbnode) parent)))
		
	(define (get-left rbnode)
		(car (cddddr rbnode)))
	
	(define (set-left! rbnode left)
		(if (not (equal? rbnode nil-node))
		(set-car! (cddddr rbnode) left)))
		
	(define (get-right rbnode)
		(cadr (cddddr rbnode)))
		
	(define (set-right! rbnode right)
		(if (not (equal? rbnode nil-node))
		(set-car! (cdr (cddddr rbnode)) right)))
	
	(define (color-flip rbnode)
		(if (and (not (null? (get-left rbnode)))
				 (not (null? (get-right rbnode))))
			(begin (set-color! rbnode 'red)
				   (set-color! (get-left rbnode) 'black)
				   (set-color! (get-right rbnode) 'black)
					#t)
		#f)			
	)
	
	
	;红黑树定义
	;(root (size nil))
	(define (make-rbtree comp-function)
		;(let ((rbtree (list nil 0 nil)))
		(let ((root nil-node)(size 0)(cmp-function comp-function))
		
		(define (rbtree-get-root) root)
		
		(define (rbtree-set-root! new-root) (set! root new-root))
		
		(define (rbtree-get-size) size)
					
		(define (rbtree-insert key val)
			(define rbnode (make-rb-node key val))
			(define child_link '())
			(define parent nil-node)
			(define cmp cmp-function)
			(define (iter cur)
				(if (equal? cur nil-node) #t
					(begin
						(set! parent cur)
						(let ((ret (cmp key (get-key cur))))
						(cond ((= 0 ret) #f)
							  (else (if (< ret 0) (begin (set! child_link (cddddr cur))
														 (set! cur (get-left cur)))
												  (begin (set! child_link (cdr (cddddr cur)))
														 (set! cur (get-right cur))))		 
									(iter cur))))
					)))
			(if (not (iter (rbtree-get-root))) #f
				(begin
					(set-left! rbnode nil-node)
					(set-right! rbnode nil-node)
					(set-parent! rbnode parent)
					(if (not (null? child_link)) (set-car! child_link rbnode))
					(set! size (+ 1 size))
					(if (= 1 size)(rbtree-set-root! rbnode))
					(insert-fix-up rbnode)
					#t
				))
		)
		
		(define (rbtree-find-imp key)
			(define (iter node)
				(define cmp cmp-function)
				(if (equal? node nil-node)'()
					(let ((ret (cmp key (get-key node))))
						(cond ((= 0 ret) node)
							  ((= -1 ret) (iter (get-left node)))
							  (else (iter (get-right node)))))))
			(if (= 0 size) '()
				(iter root))
		)
		
		(define (rbtree-find key)
			(define ret (rbtree-find-imp key))
			(if (null? ret) ret (get-val ret))
		)
		
		(define (rbtree-remove key)
			(define rbnode (rbtree-find-imp key))
			(if (null? rbnode)'()
				(rbtree-delete rbnode))
			rbnode	
		)
		
		;获取用于代替将被删除节点的节点
		(define (get-replace-node rbnode)
			(cond ((and (equal? (get-left rbnode) nil-node)
						(equal? (get-right rbnode) nil-node))rbnode)
				  ((not (equal? (get-right rbnode) nil-node)) (minimum (get-right rbnode)))		
				  (else (maxmum (get-left rbnode))))
		)
		
		(define (rbtree-delete rbnode)
			(define x (get-replace-node rbnode));用x替代rbnode的位置
			(define rb-parent (get-parent rbnode));rbnode的父亲
			(define x-parent (get-parent x));x的父亲
			(define x-old-color (get-color x))
			(define fix-node nil-node)
			(if (equal? nil-node (get-left x))(set! fix-node (get-right x))
				(set! fix-node (get-left x)))
			(if (not (equal? x rbnode));如果x与rbnode不是同一个节点
				(begin
					;x的父亲不是rbnode,将x的孩子交给它的父亲
					(if (not (equal? x-parent rbnode))
						(let ((child (if (not (equal? nil-node (get-left x)))(get-left x)
										 (get-right x))))
							 (set-parent! child x-parent)			 
							 (if (equal? x (get-left x-parent)) 
								 (set-left! x-parent child)	
								 (set-right! x-parent child))))
					
					(if (not (equal? nil-node rb-parent))
						;如果rb-parent不为nil让x成为rb-parent的孩子	
						(begin
							(if (equal? rbnode (get-left rb-parent))(set-left! rb-parent x)
								(set-right! rb-parent x))
							(set-parent! x rb-parent)	
						)
						;否则将x父亲设为nil
						(set-parent! x nil-node))
					;将rbnode的孩子移交给x
					(let ((rb-left (get-left rbnode))(rb-right (get-right rbnode)))
						(if (not (equal? nil-node rb-left))
							(begin (set-left! x rb-left)(set-parent! rb-left x)))
						(if (not (equal? nil-node rb-right))
							(begin (set-right! x rb-right)(set-parent! rb-right x))))						
				))
			;将rbnode的所有关系清除	
			(set-left! rbnode nil-node)(set-right! rbnode nil-node)(set-parent! rbnode nil-node)
			(if (equal? root rbnode)
						(rbtree-set-root! x))
			(set! size (- size 1))	
			(if (and (equal? nil-node fix-node) (eq? x-old-color 'black))
				(delete-fix-up fix-node))		
		)
			
		(define (rotate-left rbnode)
			(define parent (get-parent rbnode))
			(define right (get-right rbnode))
			(if (not (equal? nil-node right))
				(begin
					(set-right! rbnode (get-left right))
					(set-parent! (get-left right) rbnode)
					(if (equal? root rbnode) (rbtree-set-root! right)
						(begin
							(if (equal? rbnode (get-left parent))(set-left! parent right)
								(set-right! parent right))))
					(set-parent! right parent)
					(set-parent! rbnode right)
					(set-left! right rbnode)
				#t)
			#f)
		)
		
		(define (rotate-right rbnode)
			(define parent (get-parent rbnode))
			(define left (get-left rbnode))
			(if (not (equal? nil-node left))
				(begin
					(set-left! rbnode (get-right left))
					(set-parent! (get-right left) rbnode)
					(if (equal? root rbnode) (rbtree-set-root! left)
						(begin
							(if (equal? rbnode (get-left parent))(set-left! parent left)
								(set-right! parent left))))
					(set-parent! left parent)
					(set-parent! rbnode left)
					(set-right! left rbnode)
				#t)
			#f)
		)
		
		(define (insert-fix-up rbnode)
			(define (iter n)
				(if (eq? (get-color (get-parent n)) 'black)
					(set-color! root 'black)
					(begin
						(let ((parent (get-parent n))(grand_parent (get-parent (get-parent n))))
						(if (equal? parent (get-left grand_parent))
							(begin
								(let ((ancle (get-right grand_parent)))
								(if (eq? (get-color ancle) 'red)
									(begin (color-flip grand_parent) (set! n grand_parent))
									(begin 
										(if (equal? n (get-right parent))
											(begin (set! n parent)(rotate-left n)))
									 (set-color! (get-parent n) 'black)
									 (set-color! (get-parent (get-parent n)) 'red)
									 (rotate-right (get-parent (get-parent n))))))		
							)
							(begin
								(let ((ancle (get-left grand_parent)))
								(if (eq? (get-color ancle) 'red)
									(begin (color-flip grand_parent) (set! n grand_parent))
									(begin 
										(if (equal? n (get-left parent))
											(begin (set! n parent)(rotate-right n)))
									 (set-color! (get-parent n) 'black)
									 (set-color! (get-parent (get-parent n)) 'red)
									 (rotate-left (get-parent (get-parent n))))))							
							)))
						 (iter n))))
			(iter rbnode)
		)

		(define (delete-fix-up rbnode)
			(define (iter n)
				(if (not (and (not (equal? n root))
							  (not (equal? (get-color n) 'red))))
					(set-color! n 'black)
					(begin
						(let ((parent (get-parent n)))
						(if (equal? n (get-left parent))
							(begin
								(let ((w (get-right parent)))
								(if (eq? 'red (get-color w))
									(begin
										(set-color! w 'black)
										(set-color! parent 'red)
										(rotate-left parent)
										(set! w (get-right parent))))
								(if (and (eq? 'black (get-color (get-left w)))
										 (eq? 'black (get-color (get-right w))))
									(begin (set-color! w 'red)(set! n parent))
									(begin
										(if (eq? (get-color (get-right w)) 'black)
											(begin
												(set-color! (get-left w) 'black)
												(set-color! w 'red)
												(rotate-right w)
												(set! w (get-right parent))
											))
										(set-color! w (get-color parent))
										(set-color! parent 'black)
										(set-color! (get-right w) 'black)
										(rotate-left parent)
										(set! n root)	
									))))
							(begin
								(let ((w (get-left parent)))
								(if (eq? 'red (get-color w))
									(begin
										(set-color! w 'black)
										(set-color! parent 'red)
										(rotate-right parent)
										(set! w (get-left parent))))
								(if (and (eq? 'black (get-color (get-left w)))
										 (eq? 'black (get-color (get-right w))))
									(begin (set-color! w 'red)(set! n parent))
									(begin
										(if (eq? (get-color (get-left w)) 'black)
											(begin
												(set-color! (get-right w) 'black)
												(set-color! w 'red)
												(rotate-left w)
												(set! w (get-left parent))
											))
										(set-color! w (get-color parent))
										(set-color! parent 'black)
										(set-color! (get-left w) 'black)
										(rotate-right parent)
										(set! n root)	
									))))))					
						(iter n))))
			(iter rbnode)
		)
		
		(define (minimum rbnode)
			(define (minimum-imp rbnode)
				(if (equal? (get-left rbnode) nil-node)
					rbnode
					(minimum-imp (get-left rbnode))))
			(minimum-imp rbnode))
			
		(define (maxmum rbnode)
			(define (maxmum-imp rbnode)
				(if (equal? (get-right rbnode) nil-node)
					rbnode
					(maxmum-imp (get-right rbnode))))
			(maxmum-imp rbnode))		
				
		(define (successor rbnode)
			(define (iter parent node)
				(if (and (not (equal? parent nil-node))
						 (equal? (get-right parent) node))
					(iter (get-parent parent) parent)
					parent))
			(if (not (equal? (get-right rbnode) nil-node))
				(minimum (get-right rbnode))
				(iter (get-parent rbnode) rbnode)))	
				
		(define (node-next rbnode)
			(display (get-key rbnode))(newline)
			(if (null? rbnode) '()
				(begin
					(let ((succ (successor rbnode)))
						(if (equal? succ nil-node) '() succ))
				)))	
				
		(define (rbtree->array)
			(define (iter rbnode ret)
				(if (null? rbnode) ret
					(iter (node-next rbnode) (cons (get-val rbnode) ret)))
			)
			(iter (minimum root) '())
		)				
		
		(lambda (op . arg)
		(cond ((eq? op 'find) (rbtree-find  (car arg)))
			  ((eq? op 'remove) (rbtree-remove  (car arg)))
			  ((eq? op 'insert) (rbtree-insert (car arg) (cadr arg)))
			  ((eq? op 'size) size)
			  ((eq? op 'root) (get-key root))
			  ((eq? op 'tree->array-desc) (rbtree->array))
			  ((eq? op 'tree->array-asc) (reverse (rbtree->array)))
			  (else "bad op")))
	))

	(define (default-cmp a b)
		(cond ((= a b) 0)
			  ((< a b) -1)
			  (else 1)))
			  
	(define r (make-rbtree default-cmp))

	(r 'insert 1 1)
	(r 'insert 4 4)
	(r 'insert 5 5)
	(r 'insert 11 11)
	(r 'insert 15 15)
	(r 'insert 8 8)
	(r 'insert 2 2)
	(r 'insert 3 3)
	(r 'insert 6 6)
	(r 'insert 7 7)	

)