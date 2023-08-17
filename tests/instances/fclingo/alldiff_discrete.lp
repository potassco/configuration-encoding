#const n=2.

type(a).
type(b).

part(a,b,b).
multiplicity(a,b,b,n).

attr(b,c,"discrete").
dom(b,c,1..n).

constraint((a,0),"alldiff").
path((a,0),(c,(b,()))).
