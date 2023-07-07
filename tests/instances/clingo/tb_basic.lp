type(a).
attr(a,b,"discrete").
dom(a,b,("b1";"b2")).
attr(a,c,"discrete").
dom(a,c,("c1";"c2")).

constraint((a,0),"table").
column((a,0),0,(b,())).   column((a,0),1,(c,())).
entry((a,0),(0,0),"b1").  entry((a,0),(1,0),"c1").
entry((a,0),(0,1),"b2").  entry((a,0),(1,1),"c2").
