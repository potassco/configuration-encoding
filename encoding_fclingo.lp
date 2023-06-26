%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configuration model check
%%%%%%%%%%%%%%%%%%%%%%%%%
% Partonomy has to be acyclic and rooted
partonomic_path(X,Y) :- part(X,Y,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

% Unique outgoing port descriptors for a type (this should also hold for cardinalities?)
% :- part(S,T1,D,_,_), part(S,T2,D,_,_), T1 < T2.

% Make attr/3 format uniform
attr(T,D,"atomic") :- attr(T,D).

% For a given type an attribute can only be declared once
:- attr(T,D,E), attr(T,D,E'), E < E'.

% Set of port and attribute descriptors has to be disjoint
descriptor("port",D) :- part(_,_,D).
descriptor("attribute",D) :- attr(_,D,_).
:- descriptor("port",D), descriptor("attribute",D).

% Number of columns/paths and their for a constraint
% max_row_index(C,N) :- constraint(C,"table"), N = #max{ R: entry(C,(_,R),_)}.
max_column_index(C,N) :- constraint(C,"table"), N = #max{ Col : column(C,Col,_)}.

% Constraints are defined uniquely

% Table constraints are well-defined (indices of columns and rows start at 0 and increase by 1)

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% User requirements check
%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Given attribute values have to lie inside range (TODO: Distinguish between user given)
% :- val((O,D),V), attr(T,D), object(O,T), not dom(T,D,V).

% Check that all objects have values assigned (totality)?

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantiation
%%%%%%%%%%%%%%%%%%%%%%%%%

% There needs to be always a root object
object((),T) :- root(T).

% Object generation
minmax(S,T,D,Min,Max) :- part(S,T,D),
                            Min = #min { N : multiplicity(S,T,D,N)},
                            Max = #max { N : multiplicity(S,T,D,N)}.

object((D,(O,0..Min-1)),T) :- object(O,S), part(S,T,D), minmax(S,T,D,Min,_).

{ object((D,(O,I)),T) : I = Min..Max-1 } :- object(O,S), part(S,T,D), minmax(S,T,D,Min,Max). %, Min < Max.
object(O) :- object(O,T).

% Use indices in ascending order
:- object((D,(O,I))), not object((D,(O,I-1))), I > 0.

% Create associations for parts
association(O1,O2,D,"part") :- object(O2), O2 = (D,(O1,_)).

% Assign connection ports
{ association(O1,O2,D,"connection") : object(O2,T) } :- object(O1,S), connection(S,T,D).
connected(O1,O2,D) :- association(O1,O2,D,"connection").

% Check part and connection cardinalities
port(S,T,D,"partonomic") :- part(S,T,D).
port(S,T,D,"connection") :- connection(S,T,D).

% Port multiplicities need to be satisfied for each object
count(O,D,X) :- object(O,S), port(S,T,D,_), X = #count { O' : association(O,O',D,_) }.
:- port(S,T,D,_), object(O,S), count(O,D,X), not multiplicity(S,T,D,X).

% Assign values to attribute variables
{ val((O,D),V) : dom(T,D,V) } :- object(O,T), attr(T,D,"discrete").
&fin{ Min..Max } =: (O,D) :- object(O,T), attr(T,D,"numeric"), dom(T,D,Min,Max).


% Exactly one value has to be assigned for an attribute variable
:- attr(T,D,"discrete"), object(O,T), not val((O,D),_).
:- val(X,V1), val(X,V2), V1 < V2.

%%% Selectors
% An object selector (O,P,O') selects
%   all objects O' which lie on
%   path P relative to object O
selector(O,(),O) :- object(O).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I))).

% An attribute selector (O,P,X) selects
%   all attribute variables X whie lie on
%   path P relative to object O
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D,_).

%%% Aggregates
% Count
% val((O,D),V) :- object(O,T), attr(T,D,"count"), V = #count { O',P : path(T,D,P), selector(O,P,O') }.
&fsum{ 1,O',P : path(T,D,P), selector(O,P,O') } =: (O,D) :- object(O,T), attr(T,D,"count").
% val((O,D),2) :-object(O,T), attr(T,D,"count").

% Sum
% val((O,D),V) :- object(O,T), attr(T,D,"sum"), V = #sum { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
% &fsum{ V,X,P : path(T,D,P), val(X,V), selector(O,P,X) } =: (O,D) :- object(O,T), attr(T,D,"sum").
&fsum{ X,P : path(T,D,P), selector(O,P,X) } =: (O,D) :- object(O,T), attr(T,D,"sum").

% Min
% val((O,D),V) :- object(O,T), attr(T,D,"min"), V = #min { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
&fmin{ X,P : path(T,D,P), selector(O,P,X) } =: (O,D) :- object(O,T), attr(T,D,"min").

% Max
% val((O,D),V) :- object(O,T), attr(T,D,"max"), V = #max { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
&fmax{ X,P : path(T,D,P), selector(O,P,X) } =: (O,D) :- object(O,T), attr(T,D,"max").

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Table constraints

% Generate valid tuples from tables
% C = (T,Idx) = (Type,Constraint Idx)
row_tuple(C,N,Row,(V,())) :- max_column_index(C,N), entry(C,(N,Row),V).
row_tuple(C,N,Row,(V,VT)) :- row_tuple(C,N+1,Row,VT), entry(C,(N,Row),V), N>=0.
row_tuple(C,VT) :- row_tuple(C,0,_,VT).

% Generate cross product tuples from actual attribute variables
% C = Constraint Idx
var_tuple((O,C),N,(V,())) :- object(O,T), max_column_index((T,C),N), selector(O,P,X), column((T,C),N,P), val(X,V).
var_tuple((O,C),N,(V,VT)) :- object(O,T), var_tuple((O,C),N+1,VT), selector(O,P,X), column((T,C),N,P), val(X,V), N>=0.
var_tuple(OC,VT) :- var_tuple(OC,0,VT).

% A table constraint is not satisfied if some variable tuple is not contained in the constraint relation
unsat((O,C)) :- var_tuple((O,C),VT), not row_tuple((_,C),VT).

%%% Comparison constraints
left_compare((O,C),Op,X) :- object(O,T), constraint((T,C),Op), left((T,C),P), selector(O,P,X).
right_compare((O,C),Op,X) :- object(O,T), constraint((T,C),Op), right((T,C),P), selector(O,P,X).

left_compare((O,C),Op,P) :- object(O,T), constraint((T,C),Op), left((T,C),P), P = constant(N).
right_compare((O,C),Op,P) :- object(O,T), constraint((T,C),Op), right((T,C),P), P = constant(N).

% Auxiliary val atoms for comparison with constants
val(P,N) :- left_compare(_,_,P), P=constant(N).
val(P,N) :- right_compare(_,_,P), P=constant(N).

% TODO: Implement this for discrete attributes as well
% TODO: How to handle constants?

&fsum{X1} = X2 :- left_compare(C,"eq",X1),  right_compare(C,"eq",X2).
&fsum{X1} !=X2 :- left_compare(C,"neq",X1), right_compare(C,"neq",X2).
&fsum{X1} < X2 :- left_compare(C,"lt",X1),  right_compare(C,"lt",X2).
&fsum{X1} <=X2 :- left_compare(C,"lte",X1), right_compare(C,"lte",X2).
&fsum{X1} > X2 :- left_compare(C,"gt",X1),  right_compare(C,"gt",X2).
&fsum{X1} >=X2 :- left_compare(C,"gte",X1), right_compare(C,"gte",X2).

:- unsat(C).
#show test/0.
% Define statements
#defined type/1.
#defined part/3.
#defined multiplicity/4.
#defined connection/3.
#defined attr/2.
#defined attr/3.
#defined dom/3.
#defined path/3.
#defined constraint/2.
#defined column/3.
#defined entry/3.
#defined left/2.
#defined right/2.

#show object/2.
#show val/2.
&show {(O,D) : object(O,T), attr(T,D,_)}.
#show connected/3.
