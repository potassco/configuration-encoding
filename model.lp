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

% attr(travel_bike,total_weight).
attr(travel_bike,total_bags).
attr(wheel,size).
attr(wheel,weight).
attr(bag,volume).
attr(bag,weight).
attr(bag,material).

% attr(travel_bike,total_weight,0..100).
attr(travel_bike,total_bags,0..4).
attr(wheel,size,(22;24;27;29)).
attr(wheel,weight,(1800;1900;2100;2200)).
attr(bag,volume,(10;20;50;100)).
attr(bag,weight,(100;250;600;1200)).
attr(bag,material,("Cotton";"Leather";"Polyester")).


% constraint(travel_bike,"total_weight","sum").
% path(travel_bike,"total_weight",("wheels","weight")).
% path(travel_bike,"total_weight",("frame","bags","weight")).
% path(travel_bike,"total_weight",("carrier","bags","weight")).

constraint(travel_bike,total_bags,"count").
path(travel_bike,total_bags,(bags,(frame,()))).
path(travel_bike,total_bags,(bags,(carrier,()))).

constraint(wheel,0).
constraint(wheel,0,(size,()),0,22). constraint(wheel,0,(weight,()),0,1800).
constraint(wheel,0,(size,()),1,24). constraint(wheel,0,(weight,()),1,1900).
constraint(wheel,0,(size,()),2,27). constraint(wheel,0,(weight,()),2,(2100;4100)).
constraint(wheel,0,(size,()),3,29). constraint(wheel,0,(weight,()),3,2200).


constraint(bag,0).
constraint(bag,0,(volume,()),0,10). constraint(bag,0,(weight,()),0,100).
constraint(bag,0,(volume,()),1,20). constraint(bag,0,(weight,()),1,250).
constraint(bag,0,(volume,()),2,50). constraint(bag,0,(weight,()),2,600).
constraint(bag,0,(volume,()),3,100). constraint(bag,0,(weight,()),3,1200).
