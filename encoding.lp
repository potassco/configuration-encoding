%%% Configuration model
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

% attr(travel_bike,"total_weight").
% attr(travel_bike,"total_bags").
attr(wheel,"size").
attr(wheel,"weight").
attr(bag,"volume").
attr(bag,"weight").
attr(bag,"material").

attr(travel_bike,"total_weight",0..100).
attr(travel_bike,"total_bags",0..4).
attr(wheel,"size",(22;24;27;29)).
attr(wheel,"weight",(1800;1900;2100;2200)).
attr(bag,"volume",(10;20;50;100)).
attr(bag,"weight",(100;250;600;1200)).
attr(bag,"material",("Cotton";"Leather";"Polyester")).


% constraint(travel_bike,"total_weight","sum").
% path(travel_bike,"total_weight",("wheels","weight")).
% path(travel_bike,"total_weight",("frame","bags","weight")).
% path(travel_bike,"total_weight",("carrier","bags","weight")).

% constraint(travel_bike,"total_bags","count").
% path(travel_bike,"total_bags",("frame","bags")).
% path(travel_bike,"total_bags",("carrier","bags")).

constraint(wheel,0).
constraint(wheel,0,("size"),0,22). constraint(wheel,0,("weight"),0,1800).
constraint(wheel,0,("size"),1,24). constraint(wheel,0,("weight"),1,1900).
constraint(wheel,0,("size"),2,27). constraint(wheel,0,("weight"),2,2100).
constraint(wheel,0,("size"),3,29). constraint(wheel,0,("weight"),3,2200).

constraint(bag,0).
constraint(bag,0,("volume"),0,10). constraint(bag,0,("weight"),0,100).
constraint(bag,0,("volume"),1,20). constraint(bag,0,("weight"),1,250).
constraint(bag,0,("volume"),2,50). constraint(bag,0,("weight"),2,600).
constraint(bag,0,("volume"),3,100). constraint(bag,0,("weight"),3,1200).

%%% Instantiation
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

val(((bag,0),"volume"),20).
val(((bag,0),"material"),"Cotton").
val(((bag,1),"material"),"Leather").


% Assign values to attribute variables
{ val(((T,I),D),V) : attr(T,D,V) } = 1:- object((T,I)), attr(T,D).

% Attribute values have to lie inside range
:- val(((T,_),D),V), not attr(T,D,V).

% :- val(X,D,V1), val(X,D,V2), V1 < V2.

%%% Table constraints

% Chosen values need to be in the same row (for an object and a corresponding constraint)
row((T,I),J,K) :- object((T,I)), val(((T,I),D),V), constraint(T,J,(D),K,V).
% unsat((T,I),J) :- object((T,I)), constraint(T,J), not row((T,I),J,_).
unsat(O,J) :- row(O,J,K), row(O,J,K2), K < K2.

:- unsat(O,J).

% Check partonomic cardinalities
count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

% Selectors
% path

% Aggregate constraints
% agg(T,D) :- constraint(T,D,"count"), type(T), attr(T,D), X = #count {association(),path(T,D,)}.



% #show attr/3.
#show val/2.
% #show unsat/4.
