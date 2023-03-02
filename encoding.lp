#include "model.lp".

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configuration model check
%%%%%%%%%%%%%%%%%%%%%%%%%
% Partonomy has to be acyclic and rooted
partonomic_path(X,Y) :- part(X,Y,_,_,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

% Unique outgoing port descriptors for a type (this should also hold for cardinalities?)
:- part(S,T1,D,_,_), part(S,T2,D,_,_), T1 < T2.

% Set of port and attribute descriptors has to be disjoint
descriptor("port",D) :- part(_,_,D,_,_).
desciptor("attribute",D) :- attr(_,D).
:- descriptor("port",D), desciptor("attribute",D).


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantiation
%%%%%%%%%%%%%%%%%%%%%%%%%

% Object generation
% Min { object(R,(P,D),I : I = 0..N) } Max :- object(R,P,I), part(S,D,T,Min,Max), N = Max-Min.

object(()).
object((front_wheel,((),0))).
object((rear_wheel,((),0))).
object((frame,((),0))).
object((carrier,((),0))).
object((bags,((frame,((),0)),0))).
object((bags,((frame,((),0)),1))).
object((bags,((carrier,((),0)),0))).
% object((bags,((carrier,((),0)),1))).

% Generate associations between objects
association((()), (D,((),I))) :- object((D,((),I))).
association((D1,(P,I1)), (D2,((D1,(P,I1)),I2))) :- object((D2,((D1,(P,I1)),I2))).

% Determine types of objects
object((),T) :- object(()), root(T).
object(O',T) :- association(O,O'), object(O,S), O' = ((D,_)), part(S,T,D,_,_).

val(((front_wheel,((),0)),size),27).
val(((rear_wheel,((),0)),size),27).
val(((front_wheel,((),0)),weight),2200).
val(((rear_wheel,((),0)),weight),2100).

% Match associations and parts TODO


% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Assign values to attribute variables
% { val((O,D),V) : attr(T,D,V) } = 1:- object(O,T), attr(T,D).

% Attribute values have to lie inside range
:- val((O,D),V), object(O,T), not attr(T,D,V).

% Only one value can be assigned for an attribute variable
:- val(X,V1), val(X,V2), V1 < V2.

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Selectors
% object selector, selector(O,P,O)
selector(O,(),O) :- object(O).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I))).
% attribute selector, selector(O,P,X)
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D).

%%% Table constraints
% Chosen values need to be in the same row (for an object and a corresponding constraint)
row(O,J,K) :- object(O,T), selector(O,P,X), val(X,V), constraint(T,J,P,K,V).
#show row/3.

% unsat((T,I),J) :- object((T,I)), constraint(T,J), not row((T,I),J,_).
unsat(O,J) :- row(O,J,K), row(O,J,K2), K < K2.

% :- unsat(O,J).

% Check partonomic cardinalities
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

%%% Aggregate constraints
agg((O,D),P,V) :- object(O,T), constraint(T,D,"count"), path(T,D,P), V = #count { O' : selector(O,P,O') }.
% agg(O,D,P,V) :- object(O,T), constraint(T,D,"sum"), path(T,D,P), V = #count { O' : selector(O,P,O') }.
val((O,D),V) :- object(O,T), constraint(T,D,_), V = #sum { V',P : agg((O,D),P,V') }.
% val(X,V) :- agg(X,V).


% #show agg/2.
% #show val/2.
