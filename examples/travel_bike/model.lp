type(travel_bike).
type(wheel).
type(frame).
type(carrier).
type(bag).

part(travel_bike,wheel,front_wheel,1,1).
part(travel_bike,wheel,rear_wheel,1,1).
part(travel_bike,frame,frame,1,1).
part(travel_bike,carrier,carrier,1,1).
part(frame,bag,bags,0,0).
part(carrier,bag,bags,0,2).

attr(travel_bike,total_weight,"sum").
attr(travel_bike,total_bags,"count").
% attr(wheel,size).
attr(wheel,weight).
% attr(bag,volume).
attr(bag,weight).
% attr(bag,material).

% attr(travel_bike,total_weight,0..100).
dom(wheel,size,(22;24;27;29)).
% dom(wheel,weight,(1800;1900;2100;2200)).
dom(wheel,weight,(1800;2100)).
dom(bag,volume,(10;20;50;100)).
% dom(bag,weight,(100;250;600;1200)).
dom(bag,weight,(250;600)).
dom(bag,material,("Cotton";"Leather";"Polyester")).

path(travel_bike,total_weight,(weight,(rear_wheel,()))).
path(travel_bike,total_weight,(weight,(front_wheel,()))).
path(travel_bike,total_weight,(weight,(bags,(frame,())))).
path(travel_bike,total_weight,(weight,(bags,(carrier,())))).

path(travel_bike,total_bags,(bags,(frame,()))).
path(travel_bike,total_bags,(bags,(carrier,()))).

constraint((travel_bike,0),"table").
column((travel_bike,0),0,(total_bags,())).
entry((travel_bike,0),0,0,0).
entry((travel_bike,0),0,1,1).
entry((travel_bike,0),0,2,2).
entry((travel_bike,0),0,3,3).
entry((travel_bike,0),0,4,4).

% constraint((travel_bike,1),"eq").
% left((travel_bike,1),(size,(front_wheel,()))).
% right((travel_bike,1),(size,(rear_wheel,()))).

% constraint((travel_bike,2),"leq").
% left((travel_bike,2),(total_weight,())).
% right((travel_bike,2),100).


constraint((wheel,0)).
column((wheel,0),0,(size,())).  column((wheel,0),1,(weight,())).
entry((wheel,0),0,0,22).        entry((wheel,0),1,0,1800).
entry((wheel,0),0,1,24).        entry((wheel,0),1,1,1900).
entry((wheel,0),0,2,27).        entry((wheel,0),1,2,2100).
entry((wheel,0),0,3,29).        entry((wheel,0),1,3,2200).

constraint((bag,0)).
column((bag,0),0,(size,())). column((bag,0),1,(weight,())).
entry((bag,0),0,0,10).       entry((bag,0),1,0,100).
entry((bag,0),0,1,20).       entry((bag,0),1,1,250).
entry((bag,0),0,2,50).       entry((bag,0),1,2,600).
entry((bag,0),0,3,100).      entry((bag,0),1,3,1200).
