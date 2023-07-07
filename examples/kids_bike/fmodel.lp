% Types
type(bike).
type(wheel).

% Parts
part(bike,wheel,frontWheel).
multiplicity(bike,wheel,frontWheel,1).

part(bike,wheel,rearWheel).
multiplicity(bike,wheel,rearWheel,1).

%%% Attributes
attr(bike,color,"discrete").
dom(bike,color,(red;green;yellow;blue)).

attr(bike,wheelSupport,"discrete").
dom(bike,wheelSupport,(yes;no)).

attr(wheel,size,"numeric").
dom(wheel,size,0,20).

%%% Constraints
constraint((bike,0),"eq").
    left((bike,0),  (size,(frontWheel,()))).
    right((bike,0), (size,(rearWheel,()))).

constraint((bike,1),"table").
    column((bike,1),0,(wheelSupport,())).   column((bike,1),1,(size,(rearWheel,()))).
    entry((bike,1),(0,0),yes).              entry((bike,1),(1,0),14).
    entry((bike,1),(0,1),yes).              entry((bike,1),(1,1),16).
    entry((bike,1),(0,2),no).               entry((bike,1),(1,2),18).
    entry((bike,1),(0,3),no).               entry((bike,1),(1,3),20).

