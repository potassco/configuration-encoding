%%% Configuration model
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

% Partonomy has to be acyclic and rooted
partonomic_path(X,Y) :- part(X,Y,_,_,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

% Unique outgoing port descriptors for a type (this should also hold for cardinalities?)
:- part(S,T1,D,_,_), part(S,T2,D,_,_), T1 < T2.


% attr(travel_bike,total_weight).
% attr(travel_bike,total_bags).
attr(wheel,size).
attr(wheel,weight).
attr(bag,volume).
attr(bag,weight).
attr(bag,material).

% attr(travel_bike,total_weight,0..100).
% attr(travel_bike,total_bags,0..4).
attr(wheel,size,(22;24;27;29)).
attr(wheel,weight,(1800;1900;2100;2200)).
attr(bag,volume,(10;20;50;100)).
attr(bag,weight,(100;250;600;1200)).
attr(bag,material,("Cotton";"Leather";"Polyester")).

% Set of port and attribute descriptors has to be disjoint
descriptor("port",D) :- part(_,_,D,_,_).
desciptor("attribute",D) :- attr(_,D).
:- descriptor("port",D), desciptor("attribute",D).

% constraint(travel_bike,"total_weight","sum").
% path(travel_bike,"total_weight",("wheels","weight")).
% path(travel_bike,"total_weight",("frame","bags","weight")).
% path(travel_bike,"total_weight",("carrier","bags","weight")).

% constraint(travel_bike,total_bags,"count").
% path(travel_bike,total_bags,(frame,bags)).
% path(travel_bike,total_bags,(carrier,bags)).

constraint(wheel,0).
constraint(wheel,0,(size),0,22). constraint(wheel,0,(weight),0,1800).
constraint(wheel,0,(size),1,24). constraint(wheel,0,(weight),1,1900).
constraint(wheel,0,(size),2,27). constraint(wheel,0,(weight),2,2100).
constraint(wheel,0,(size),3,29). constraint(wheel,0,(weight),3,2200).

constraint(bag,0).
constraint(bag,0,(volume),0,10). constraint(bag,0,(weight),0,100).
constraint(bag,0,(volume),1,20). constraint(bag,0,(weight),1,250).
constraint(bag,0,(volume),2,50). constraint(bag,0,(weight),2,600).
constraint(bag,0,(volume),3,100). constraint(bag,0,(weight),3,1200).

%%% Instantiation
% object((travel_bike,0)).
% object((wheel,0)).
% object((wheel,1)).
% object((frame,0)).
% object((carrier,0)).
% object((bag,0)).
% object((bag,1)).
% object((bag,2)).

object(()).
% Min { object(R,(P,D),I : I = 0..N) } Max :- object(R,P,I), part(S,D,T,Min,Max), N = Max-Min.

% object(travel_bike,"front_wheel",0).
% object(travel_bike,"rear_wheel",0).
% object(travel_bike,"frame",0).
% object(travel_bike,"carrier",0).
% object(((travel_bike,"frame"),0),"bags",0).
% object(((travel_bike,"frame"),0),"bags",1).
% object(((travel_bike,"carrier"),0),"bags",0).

object((front_wheel,((),0))).
object((rear_wheel,((),0))).
object((frame,((),0))).
object((carrier,((),0))).
object((bags,((frame,((),0)),0))).
object((bags,((frame,((),0)),1))).
object((bags,((carrier,((),0)),0))).

% Generate associations between objects
association((()), (D,((),I))) :- object((D,((),I))).
association((D1,(P,I1)), (D2,((D1,(P,I1)),I2))) :- object((D2,((D1,(P,I1)),I2))).

% Determine types of objects
objecttype((),T) :- object(()), root(T).
objecttype(O',T) :- association(O,O'), objecttype(O,S), O' = ((D,_)), part(S,T,D,_,_).

% Match associations and parts TODO


% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Assign values to attribute variables
{ val((O,D),V) : attr(T,D,V) } = 1:- object(O), objecttype(O,T), attr(T,D).

% Attribute values have to lie inside range
:- val((O,D),V), objecttype(O,T), not attr(T,D,V).

% Only one value can be assigned for an attribute variable
:- val(X,V1), val(X,V2), V1 < V2.

%%% Table constraints

% Chosen values need to be in the same row (for an object and a corresponding constraint)
row(O,J,K) :- object(O), objecttype(O,T), val((O,D),V), constraint(T,J,(D),K,V).
% unsat((T,I),J) :- object((T,I)), constraint(T,J), not row((T,I),J,_).
unsat(O,J) :- row(O,J,K), row(O,J,K2), K < K2.

:- unsat(O,J).

% Check partonomic cardinalities
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

#show val/2.
