% Types
type(bike).
type(wheel).

% Parts
part(bike,wheel,frontWheel).
multiplicity(bike,wheel,frontWheel,1).

part(bike,wheel,rearWheel).
multiplicity(bike,wheel,rearWheel,1).

%%% Attributes
% attr(bike,color).
% attr(bike,wheelSupport).
% attr(wheel,size).
attr(bike,color,"discrete").
attr(bike,wheelSupport,"discrete").
attr(wheel,size,"numeric").

dom(bike,color,(red;green;yellow;blue)).
dom(bike,wheelSupport,(yes;no)).
dom(wheel,size,14,20).

%%% Constraints
constraint((bike,0),"eq").
    left((bike,0),  (size,(frontWheel,()))).
    right((bike,0), (size,(rearWheel,()))).

% constraint((bike,0),"table").
%     column((bike,0),0,(size,(frontWheel,()))).   column((bike,0),1,(size,(rearWheel,()))).
%     entry((bike,0),(0,0),14).              entry((bike,0),(1,0),14).
%     entry((bike,0),(0,1),16).              entry((bike,0),(1,1),16).
%     entry((bike,0),(0,2),18).               entry((bike,0),(1,2),18).
%     entry((bike,0),(0,3),20).               entry((bike,0),(1,3),20).

% constraint((bike,1),"table").
    column((bike,1),0,(wheelSupport,())).   column((bike,1),1,(size,(rearWheel,()))).
    entry((bike,1),(0,0),yes).              entry((bike,1),(1,0),14).
    entry((bike,1),(0,1),yes).              entry((bike,1),(1,1),16).
    entry((bike,1),(0,2),no).               entry((bike,1),(1,2),18).
    entry((bike,1),(0,3),no).               entry((bike,1),(1,3),20).

