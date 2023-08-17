type(a).
type(b).

part(a, b, ((b, 0..1))).
multiplicity(a, b, ((b, 0..1)), 0..1).

connection(b,b,previous).
multiplicity(b,b,previous,1).

attr(b,id,"discrete").
dom(b,id,0..1).

constraint((a,I),"table")       :- I = 0..1.
column((a,I),0,(id,((b,I),()))) :- I = 0..1.
entry((a,I),(0,0),I)            :- I = 0..1.

constraint((b,0),"table").
column((b,0),0,(id,())). column((b,0),1,(id,(previous,()))).
entry((b,0),(0,0),0). entry((b,0),(1,0),0).
entry((b,0),(0,1),1). entry((b,0),(1,1),0).

