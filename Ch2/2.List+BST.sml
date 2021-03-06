
signature STACK =
sig
    type 'a Stack
    val empty : 'a Stack
    val isEmpty : 'a Stack -> bool
    val cons : 'a * 'a Stack -> 'a Stack
    val head : 'a Stack -> 'a
    val tail : 'a Stack -> 'a Stack
end

structure List: STACK =
struct
type 'a Stack = 'a list
val empty = []
fun isEmpty s = null s
fun cons (x, s) = x :: s
fun head s = hd s
fun tail s = tl s
end

			    
structure CustomStack: STACK =
struct
datatype 'a Stack = NIL | CONS of 'a * 'a Stack
val empty = NIL
fun isEmpty NIL = true 
  | isEmpty _ = false 
fun cons (x, s) = CONS(x, s)
fun head NIL = raise Empty
  | head (CONS (x, s)) = x 
fun tail NIL = raise Empty
  | tail (CONS (x, s)) = s
end


infix ++
fun xs ++ ys = if List.isEmpty xs then ys else List.cons (List.head xs, List.tail xs)
					       
fun update ([], i, y) = raise Subscript
  | update (x :: xs, 0, y) = y :: xs
  | update (x :: xs, i, y) = x :: update(xs, i-1, y)


fun suffixes ([]) = [[]]
  | suffixes (s as x :: xs) = s :: suffixes xs

signature SET =
sig
    type Elem
    type Set

    val empty : Set
    val insert : Elem * Set -> Set
    val member : Elem * Set -> bool
end

signature ORDERED =
sig
    type T

    val eq : T * T -> bool
    val lt : T * T -> bool
    val leq : T * T -> bool
end

functor unbalancedSet (Element: ORDERED): SET =
struct
type Elem = Element.T
datatype Tree = E | T of Tree * Elem * Tree
type Set = Tree
val empty = E

fun member (x, E) = false
  | member (x, T (a, y, b)) =
    if Element.lt (x, y) then member (x, a)
    else if Element.lt (y, x) then member (x, b)
    else true

fun insert (x, E) = T (E, x, E)
  | insert (x, s as T (a, y, b)) =
    if Element.lt (x, y) then T (insert (x, a), y, b)
    else if Element.lt(y, x) then T (a, y, insert (x, b))
    else s
end
					      

signature FINITEMAP =
sig
    type Key
    type 'a Map
	    
    val empty : 'a Map
    val bind : Key * 'a * 'a Map -> 'a Map
    val lookup : Key * 'a Map -> 'a
end
    
