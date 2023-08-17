type(a).

attr(a,b,"discrete").
dom(a,b,("b1";"b2")).
attr(a,c,"discrete").
dom(a,c,("c1";"c2")).

constraint((a,0),"incompatible").
left((a,0),(b,()),"b1").    right((a,0),(c,()),"c1").

% constraint((bike,0),"table").
% column((bike,0),0,(color,())).  column((bike,0),1,(color,(frame,()))).
% forbid((bike,0),(0,0),"red").   forbid((bike,0),(1,0),"yellow").
