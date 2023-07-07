type(a). type(b).
part(a,b,b).
multiplicity(a,b,b,0..1).

attr(a,c,"discrete"). dom(a,c,1..2).
attr(b,d,"discrete"). dom(b,d,1..2).

constraint((a,0),"table").
column((a,0),0,(d,(b,()))).   column((a,0),1,(c,())).
entry((a,0),(0,0),1).  entry((a,0),(1,0),1).
entry((a,0),(0,1),2).  entry((a,0),(1,1),2).
