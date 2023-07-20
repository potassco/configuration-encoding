type(bike). type(frame).
part(bike,frame,frame).
multiplicity(bike,frame,frame,1).

attr(bike,color,"discrete").
dom(bike,color,("red";"yellow")).
attr(frame,color,"discrete").
dom(frame,color,("red";"yellow")).

constraint((bike,0),"incompatible").
left((bike,0),(color,()),"red").    right((bike,0),(color,(frame,())),"yellow").

% constraint((bike,0),"table").
% column((bike,0),0,(color,())).  column((bike,0),1,(color,(frame,()))).
% forbid((bike,0),(0,0),"red").   forbid((bike,0),(1,0),"yellow").
