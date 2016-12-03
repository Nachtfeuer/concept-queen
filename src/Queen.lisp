;;;; @author  Thomas Lehmann
;;;; @file    Queen.lisp
;;;;
;;;; Copyright (c) 2016 Thomas Lehmann
;;;;
;;;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
;;;; documentation files (the "Software"), to deal in the Software without restriction, including without limitation
;;;; the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
;;;; and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
;;;;
;;;; The above copyright notice and this permission notice shall be included in all copies
;;;; or substantial portions of the Software.
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
;;;; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
;;;; DAMAGES OR OTHER LIABILITY,
;;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
(defclass queen ()
    ((width
      :initarg :width
      :initform 8)
    (last-row
      :initform 0)
    (columns
      :initform nil)
    (diagonals1
      :initform nil)
    (diagonals2
      :initform nil)
    (solutions
      :initform ())
    ))

(defmethod get-width ((instance queen))
    (slot-value instance 'width))

(defmethod get-last-row ((instance queen))
    (slot-value instance 'last-row))

(defmethod get-solutions ((instance queen))
    (slot-value instance 'solutions))

(defmethod is-column-occupied ((instance queen) index)
    (>= (nth index (slot-value instance 'columns)) 0))

(defmethod is-diagonals1-occupied ((instance queen) index)
    (> (nth index (slot-value instance 'diagonals1)) 0))

(defmethod is-diagonals2-occupied ((instance queen) index)
    (> (nth index (slot-value instance 'diagonals2)) 0))

(defmethod occupy-column ((instance queen) index row)
    (setf (nth index (slot-value instance 'columns)) row))

(defmethod occupy-diagonals1 ((instance queen) index)
    (setf (nth index (slot-value instance 'diagonals1)) 1))

(defmethod occupy-diagonals2 ((instance queen) index)
    (setf (nth index (slot-value instance 'diagonals2)) 1))

(defmethod free-column ((instance queen) index)
    (setf (nth index (slot-value instance 'columns)) -1))

(defmethod free-diagonals1 ((instance queen) index)
    (setf (nth index (slot-value instance 'diagonals1)) 0))

(defmethod free-diagonals2 ((instance queen) index)
    (setf (nth index (slot-value instance 'diagonals2)) 0))

(defmethod initialize-instance :after ((instance queen) &key)
    (setf (slot-value instance 'last-row) (- (get-width instance) 1))
    (dotimes (column (get-width instance))
        (push -1 (slot-value instance 'columns)))
    (dotimes (column (- (* 2 (get-width instance)) 1))
        (push 0 (slot-value instance 'diagonals1))
        (push 0 (slot-value instance 'diagonals2)))
)

(defmethod run ((instance queen) &key (row 0))
    (dotimes(column (get-width instance))
        (when(not (is-column-occupied instance column))
            (let ((ix-diag-1 (+ row column)))
                (when(not (is-diagonals1-occupied instance ix-diag-1))
                    (let ((ix-diag-2 (+ (- (get-last-row instance) row) column)))
                        (when(not (is-diagonals2-occupied instance ix-diag-2))
                            ;(format t "trying row=~a, column=~a" row column)
                            (occupy-column instance column row)
                            (occupy-diagonals1 instance ix-diag-1)
                            (occupy-diagonals2 instance ix-diag-2)

                            (if (equal row (get-last-row instance))
                                ; then
                                (progn
                                    ;(print (slot-value instance 'columns))
                                    (push (slot-value instance 'columns) (slot-value instance 'solutions))
                                )
                                ; else
                                (run instance :row (+ row 1))
                            )

                            (free-column instance column)
                            (free-diagonals1 instance ix-diag-1)
                            (free-diagonals2 instance ix-diag-2)
                        )
                    )
                )
            )
        )
    )
)

(defvar width 8)
(when(equal (list-length *posix-argv*) 2)
    (setf width (parse-integer (nth 1 *posix-argv*))))

; creates the queen instance
(defvar instance (make-instance 'queen :width width))
; does output the chessboard resolution
(format t "Queen raster (~ax~a)~%" (get-width instance) (get-width instance))
(defvar start (get-internal-real-time))
(run instance)
(format t "...took ~12,10F seconds.~%" (/ (- (get-internal-real-time) start) internal-time-units-per-second))
(format t "...~a solutions found.~%" (list-length (get-solutions instance)))

