#const type="eq".

type(a).

attr(a,b,"discrete").
dom(a,b,1..2).

attr(a,c,"discrete").
dom(a,c,1..2).

constraint((a,0),type).
    left((a,0),  (b,())).
    right((a,0), (c,())).
