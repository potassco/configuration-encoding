% Configuration model
type(travel_bike).
type(wheel).
type(frame).
type(carrier).
type(bag).

part(travel_bike,wheel,"front_wheel",1,1).
part(travel_bike,wheel,"rear_wheel",1,1).
part(travel_bike,frame,"frame",1,1).
part(travel_bike,carrier,"carrier",1,1).
part(frame,bag,"bags",0,2).
part(carrier,bag,"bags",0,3).

attr(travel_bike,"total_weight").
attr(travel_bike,"total_bags").
attr(wheel,"size").
attr(wheel,"weight").
attr(bag,"volume").
attr(bag,"weight").
attr(bag,"material").

constraint(travel_bike,0).
constraint(travel_bike,0,("total_weight"),N,N) :- N = 0..100.
constraint(travel_bike,1).
constraint(travel_bike,1,("total_bags"),N,N) :- N = 0..4.

% constraint(travel_bike,"total_weight","sum").
% path(travel_bike,"total_weight",("wheels","weight")).
% path(travel_bike,"total_weight",("frame","bags","weight")).
% path(travel_bike,"total_weight",("carrier","bags","weight")).

constraint(travel_bike,"total_bags","count").
path(travel_bike,"total_bags",("frame","bags")).
path(travel_bike,"total_bags",("carrier","bags")).

constraint(wheel,0).
constraint(wheel,0,("size"),0,22). constraint(wheel,0,("weight"),0,1800).
constraint(wheel,0,("size"),1,24). constraint(wheel,0,("weight"),1,1900).
constraint(wheel,0,("size"),2,27). constraint(wheel,0,("weight"),2,2100).
constraint(wheel,0,("size"),3,29). constraint(wheel,0,("weight"),3,2200).

constraint(wheel,1).
constraint(wheel,1,("volume"),0,10). constraint(wheel,1,("weight"),0,100).
constraint(wheel,1,("volume"),1,20). constraint(wheel,1,("weight"),0,250).
constraint(wheel,1,("volume"),2,50). constraint(wheel,1,("weight"),0,600).
constraint(wheel,1,("volume"),2,100). constraint(wheel,1,("weight"),0,1200).

constraint(bag,0).
constraint(bag,0,("material"),0,"Cotton").
constraint(bag,0,("material"),1,"Leather").
constraint(bag,0,("material"),2,"Polyester").

% Instantiation
object((travel_bike,0)).
object((wheel,0)).
object((wheel,1)).
object((frame,0)).
object((carrier,0)).
object((bag,0)).
object((bag,1)).

association((travel_bike,0),(wheel,0),"front_wheel").
association((travel_bike,0),(wheel,1),"rear_wheel").
association((travel_bike,0),(frame,0),"frame").
association((travel_bike,0),(carrier,0),"carrier").
association((frame,0),(bag,0),"bags").
association((frame,0),(bag,1),"bags").

% There cannot be an association without a corresponding part relationship (hard constraint)
:- association((S,_),(T,_),D), not part(S,T,D,_,_).

val(((wheel,0),"size"),27).
val(((wheel,1),"size"),27).
val(((wheel,0),"weight"),2100).
val(((wheel,1),"weight"),2100).

% Check partonomic cardinalities
count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { S,IS,T,IT : association((S,IS),(T,IT),D) }.

% Selectors


% Aggregate constraints
% agg(T,D) :- constraint(T,D,"count"), type(T), attr(T,D), X = #count {association(),path(T,D,)}.




#show agg/2.
