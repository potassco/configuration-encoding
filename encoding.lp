% Partonomy has to be acyclic and rooted
partonomic_path(X,Y) :- part(X,Y,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

% Generate maximal object tree
object((),T) :- root(T).
object((D,(O,0..Max-1)),T) :- object(O,S), part(S,T,D), Max = #max { N : multiplicity(S,T,D,N)}.
object(O) :- object(O,T).

% Select subtree (root has to be selected)
selected((),T) :- root(T).
{ selected(O,T) : object(O,T) }.
selected(O) :- selected(O,_).

% You can only select an object if its "parent object" is selected as well
:- selected(O1), O1 = (_,(O2,_)), not selected(O2).

% Select such that indices are in ascending order
:- selected((D,(O,I))), not selected((D,(O,I-1))), I > 0.

% Select at least minimal number of required objects
selected((D,(O,0..Min-1)),T) :- selected(O,S), part(S,T,D), Min = #min { N : multiplicity(S,T,D,N)}.

% Check part multiplicities
:- part(S,T,D), not multiplicity(S,T,D,X), selected(O,S), X = #count { I : selected((D,(O,I)),T) }.

% Create all possible connection ports and select
association(O1,O2,D,"connection") :- connection(S,T,D), object(O1,S), object(O2,T).
{ connected(O1,O2,D) : association(O1,O2,D,"connection") }.

:- connected(O1,O2,_), not selected(O1).
:- connected(O1,O2,_), not selected(O2).

% :- connected(O,O,_). % Should this be allowed or not?

% Check connection multiplicities
:- connection(S,T,D), not multiplicity(S,T,D,X),
   selected(O1,S), X = #count { O2 : connected(O1,O2,D) }.

% Assign values to attribute variables
{ val((O,D),V) : dom(T,D,V) } :- selected(O,T), attr(T,D,"discrete").
% Exactly one value has to be assigned for an attribute variable
:- attr(T,D,"discrete"), selected(O,T), not val((O,D),_).
:- val(X,V1), val(X,V2), V1 < V2.

%%% Selectors
% An object selector (O,P,O') selects
%   all objects O' which lie on
%   path P relative to object O
selector(O,(),O) :- object(O).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I))).

% An attribute selector (O,P,X) selects
%   all attribute variables X which lie on
%   path P relative to object O
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D,_).

%%% Aggregates
% Count
val((O,D),V) :- selected(O,T), attr(T,D,"count"), V = #count { O',P : path(T,D,P), selector(O,P,O'), selected(O') }.
% Sum
val((O,D),V) :- selected(O,T), attr(T,D,"sum"), V = #sum { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
% Min
val((O,D),V) :- selected(O,T), attr(T,D,"min"), V = #min { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
% Max
val((O,D),V) :- selected(O,T), attr(T,D,"max"), V = #max { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Table constraints

% Generate valid tuples from tables
% C = (T,Idx) = (Type,Constraint Idx)
row_tuple(C,(Col,Row),(V,())) :- column(C,Col,_), entry(C,(Col,Row),V), not column(C,Col+1,_).
row_tuple(C,(Col,Row),(V,RT)) :- row_tuple(C,(Col+1,Row),RT), entry(C,(Col,Row),V), Col>=0.
row_tuple(C,RT) :- row_tuple(C,(0,_),RT).

% Generate cross product tuples from actual attribute variables
% C = Constraint Idx
var_tuple((O,C),Col,(V,())) :- column((T,C),Col,P), object(O,T), selector(O,P,X), not column((T,C),Col+1,_), val(X,V).
var_tuple((O,C),Col,(V,VT)) :- column((T,C),Col,P), object(O,T), selector(O,P,X), var_tuple((O,C),Col+1,VT), val(X,V), Col>=0.
var_tuple(OC,VT) :- var_tuple(OC,0,VT).

% A table constraint is not satisfied if some variable tuple is not contained in the constraint relation
unsat((O,C)) :- var_tuple((O,C),VT), not row_tuple((_,C),VT).

%%% Comparison constraints
left_compare((O,C),Op,X)  :- constraint((T,C),Op), left((T,C),P), object(O,T), selector(O,P,X).
right_compare((O,C),Op,X) :- constraint((T,C),Op), right((T,C),P),object(O,T), selector(O,P,X).

left_compare((O,C),Op,P)  :- constraint((T,C),Op), left((T,C),P), object(O,T), P = constant(N).
right_compare((O,C),Op,P) :- constraint((T,C),Op), right((T,C),P),object(O,T), P = constant(N).

% Auxiliary val atoms for comparison with constants
val(P,N) :- left_compare(_,_,P), P=constant(N).
val(P,N) :- right_compare(_,_,P), P=constant(N).

sat_pair(C,X1,X2) :- left_compare(C,"eq",X1), right_compare(C,"eq",X2), val(X1,V1), val(X2,V2), V1 = V2.
sat_pair(C,X1,X2) :- left_compare(C,"neq",X1), right_compare(C,"neq",X2), val(X1,V1), val(X2,V2), V1 != V2.
sat_pair(C,X1,X2) :- left_compare(C,"lt",X1), right_compare(C,"lt",X2), val(X1,V1), val(X2,V2), V1 < V2.
sat_pair(C,X1,X2) :- left_compare(C,"lte",X1), right_compare(C,"lte",X2), val(X1,V1), val(X2,V2), V1 <= V2.
sat_pair(C,X1,X2) :- left_compare(C,"gt",X1), right_compare(C,"gt",X2), val(X1,V1), val(X2,V2), V1 > V2.
sat_pair(C,X1,X2) :- left_compare(C,"gte",X1), right_compare(C,"gte",X2), val(X1,V1), val(X2,V2), V1 >= V2.

% A comparison constraint is not satisfied if some pair of attribute variables does not satisfy it
unsat(C) :- left_compare(C,Op,X1), right_compare(C,Op,X2), not sat_pair(C,X1,X2), Op != "table".

:- unsat(C).

% Define statements
#defined type/1.
#defined part/3.
#defined multiplicity/4.
#defined connection/3.
#defined connected/2.
#defined connected/3.
#defined attr/2.
#defined attr/3.
#defined dom/3.
#defined path/3.
#defined constraint/2.
#defined column/3.
#defined entry/3.
#defined left/2.
#defined right/2.

#show selected/2.
#show val/2.
#show connected/3.
