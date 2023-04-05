type(travel_bike).
type(wheel).
type(frame).
type(carrier).
type(bag).

part(travel_bike,wheel,front_wheel,1,1).
part(travel_bike,wheel,rear_wheel,1,1).
part(travel_bike,frame,frame,1,1).
part(travel_bike,carrier,carrier,1,1).
part(frame,bag,bags,0,2).
part(carrier,bag,bags,0,3).

%%% Attributes
attr(travel_bike,total_weight,"sum").
attr(travel_bike,total_bags,"count").
attr(wheel,size).
attr(wheel,weight).
attr(bag,volume).
attr(bag,weight).
attr(bag,material).

dom(wheel,size,(22;24;27;29)).
dom(wheel,weight,(1800;1900;2100;2200)).
dom(bag,volume,(10;20;50;100)).
dom(bag,weight,(100;250;600;1200)).
dom(bag,material,("Cotton";"Leather";"Polyester")).

% Aggregate paths
path(travel_bike,total_weight,(weight,(rear_wheel,()))).
path(travel_bike,total_weight,(weight,(front_wheel,()))).
path(travel_bike,total_weight,(weight,(bags,(frame,())))).
path(travel_bike,total_weight,(weight,(bags,(carrier,())))).

path(travel_bike,total_bags,(bags,(frame,()))).
path(travel_bike,total_bags,(bags,(carrier,()))).

%%% Constraints
constraint((travel_bike,0),"lte").
left((travel_bike,0),(total_bags,())).
right((travel_bike,0),constant(4)).

constraint((travel_bike,1),"eq").
left((travel_bike,1),(size,(front_wheel,()))).
right((travel_bike,1),(size,(rear_wheel,()))).

constraint((travel_bike,2),"lte").
left((travel_bike,2),(total_weight,())).
right((travel_bike,2),constant(5000)).

constraint((wheel,0),"table").
column((wheel,0),0,(size,())).  column((wheel,0),1,(weight,())).
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
