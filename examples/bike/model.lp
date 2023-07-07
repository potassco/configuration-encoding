% Types
type(bike).
type(wheel).
type(frame).
type(bag).

% Parts
part(bike,wheel,frontWheel).
multiplicity(bike,wheel,frontWheel,1).

part(bike,wheel,rearWheel).
multiplicity(bike,wheel,rearWheel,1).

part(bike,frame,frame).
multiplicity(bike,frame,frame,1).

part(frame,bag,bag).
multiplicity(frame,bag,bag,0).
multiplicity(frame,bag,bag,1).
multiplicity(frame,bag,bag,2).

part(wheel,bag,bag).
multiplicity(wheel,bag,bag,0).
multiplicity(wheel,bag,bag,2).

%%% Attributes
attr(bike,totalWeight,"sum").
attr(bike,stowage,"sum").

attr(bike,maxWeight,"discrete").
dom(bike,maxWeight,5000).

attr(bike,minStowage,"discrete").
dom(bike,minStowage,30).

attr(wheel,size,"discrete").
dom(wheel,size,(22;24;27;29)).

attr(wheel,weight,"discrete").
dom(wheel,weight,(1800;1900;2100;2200)).

attr(bag,volume,"discrete").
dom(bag,volume,(10;20;50;100)).

attr(bag,weight,"discrete").
dom(bag,weight,(100;250;600;1200)).

% Aggregate paths
path(bike,totalWeight,(weight,(frontWheel,()))).
path(bike,totalWeight,(weight,(rearWheel,()))).
path(bike,totalWeight,(weight,(bag,(frontWheel,())))).
path(bike,totalWeight,(weight,(bag,(rearWheel,())))).
path(bike,totalWeight,(weight,(bag,(frame,())))).

path(bike,stowage,(volume,(bag,(frontWheel,())))).
path(bike,stowage,(volume,(bag,(rearWheel,())))).
path(bike,stowage,(volume,(bag,(frame,())))).

%%% Constraints
constraint((bike,0),"eq").
    left((bike,0),  (size,(frontWheel,()))).
    right((bike,0), (size,(rearWheel,()))).

constraint((bike,1),"lte").
    left((bike,1),  (totalWeight,())).
    right((bike,1), (maxWeight,())).

constraint((bike,2),"gte").
    left((bike,2),  (stowage,())).
    right((bike,2), (minStowage,())).

constraint((wheel,0),"table").
    column((wheel,0),0,(size,())).    column((wheel,0),1,(weight,())).
    entry((wheel,0),(0,0),22).        entry((wheel,0),(1,0),1800).
    entry((wheel,0),(0,1),24).        entry((wheel,0),(1,1),1900).
    entry((wheel,0),(0,2),27).        entry((wheel,0),(1,2),2100).
    entry((wheel,0),(0,3),29).        entry((wheel,0),(1,3),2200).

constraint((wheel,1),"table").
    column((wheel,1),0,(volume,(bag,()))).
    entry((wheel,1),(0,0),10).
    entry((wheel,1),(0,1),20).

constraint((bag,0),"table").
    column((bag,0),0,(volume,())). column((bag,0),1,(weight,())).
    entry((bag,0),(0,0),10).       entry((bag,0),(1,0),100).
    entry((bag,0),(0,1),20).       entry((bag,0),(1,1),250).
    entry((bag,0),(0,2),50).       entry((bag,0),(1,2),600).
    entry((bag,0),(0,3),100).      entry((bag,0),(1,3),1200).
