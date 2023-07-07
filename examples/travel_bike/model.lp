type(travelBike).
type(wheel).
type(frame).
type(carrier).
type(bag).


part(travelBike,wheel,frontWheel).
multiplicity(travelBike,wheel,frontWheel,1).

part(travelBike,wheel,rearWheel).
multiplicity(travelBike,wheel,rearWheel,1).

part(travelBike,frame,frame).
multiplicity(travelBike,frame,frame,1).

part(travelBike,carrier,carrier).
multiplicity(travelBike,carrier,carrier,1).

part(frame,bag,bags).
multiplicity(frame,bag,bags,0).
multiplicity(frame,bag,bags,1).
multiplicity(frame,bag,bags,2).

part(carrier,bag,bags).
multiplicity(carrier,bag,bags,0).
multiplicity(carrier,bag,bags,1).
multiplicity(carrier,bag,bags,2).
multiplicity(carrier,bag,bags,3).

%%% Attributes
attr(travelBike,totalWeight,"sum").
attr(travelBike,totalBags,"count").

attr(wheel,size,"discrete").
dom(wheel,size,(22;24;27;29)).

attr(wheel,weight,"discrete").
dom(wheel,weight,(1800;1900;2100;2200)).

attr(bag,volume,"discrete").
dom(bag,volume,(10;20;50;100)).

attr(bag,weight,"discrete").
dom(bag,weight,(100;250;600;1200)).

attr(bag,material,"discrete").
dom(bag,material,("Cotton";"Leather";"Polyester")).

% Aggregate paths
path(travelBike,totalWeight,(weight,(rearWheel,()))).
path(travelBike,totalWeight,(weight,(frontWheel,()))).
path(travelBike,totalWeight,(weight,(bags,(frame,())))).
path(travelBike,totalWeight,(weight,(bags,(carrier,())))).

path(travelBike,totalBags,(bags,(frame,()))).
path(travelBike,totalBags,(bags,(carrier,()))).

%%% Constraints
constraint((travelBike,0),"lte").
    left((travelBike,0),(totalBags,())).
    right((travelBike,0),constant(4)).

constraint((travelBike,1),"eq").
    left((travelBike,1),(size,(frontWheel,()))).
    right((travelBike,1),(size,(rearWheel,()))).

constraint((travelBike,2),"lte").
    left((travelBike,2),(totalWeight,())).
    right((travelBike,2),constant(5000)).

constraint((wheel,0),"table").
    column((wheel,0),0,(size,())).    column((wheel,0),1,(weight,())).
    entry((wheel,0),(0,0),22).        entry((wheel,0),(1,0),1800).
    entry((wheel,0),(0,1),24).        entry((wheel,0),(1,1),1900).
    entry((wheel,0),(0,2),27).        entry((wheel,0),(1,2),2100).
    entry((wheel,0),(0,3),29).        entry((wheel,0),(1,3),2200).

constraint((bag,0),"table").
    column((bag,0),0,(volume,())). column((bag,0),1,(weight,())).
    entry((bag,0),(0,0),10).       entry((bag,0),(1,0),100).
    entry((bag,0),(0,1),20).       entry((bag,0),(1,1),250).
    entry((bag,0),(0,2),50).       entry((bag,0),(1,2),600).
    entry((bag,0),(0,3),100).      entry((bag,0),(1,3),1200).
