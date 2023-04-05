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
% :- part(S,T1,D,_,_), part(S,T2,D,_,_), T1 < T2.

% Make attr/3 format uniform
attr(T,D,"atomic") :- attr(T,D).

% For a given type an attribute can only be declared once
:- attr(T,D,E), attr(T,D,E'), E < E'.

% Set of port and attribute descriptors has to be disjoint
descriptor("port",D) :- part(_,_,D,_,_).
descriptor("attribute",D) :- attr(_,D,_).
:- descriptor("port",D), descriptor("attribute",D).

% Number of columns/paths and their for a constraint
max_row_index(C,N) :- constraint(C,"table"), N = #max{ R: entry(C,_,R,_)}.
max_column_index(C,N) :- constraint(C,"table"), N = #max{ Col : column(C,Col,_)}.

% Constraints are defined uniquely

% Table constraints are well-defined (indices of columns and rows start at 0 and increase by 1)

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% User requirements check
%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Given attribute values have to lie inside range (TODO: Distinguish between user given)
:- val((O,D),V), attr(T,D), object(O,T), not dom(T,D,V).

% Check that all objects have values assigned (totality)?

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantiation
%%%%%%%%%%%%%%%%%%%%%%%%%

% There needs to be always a root object
object(()).

% Object generation
Min { object((D,(P,I))) : I = 0..Max } Max :- object(P,S), part(S,T,D,Min,Max).
% Check partonomic cardinalities, still needed?
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

% Use indices in ascending order
:- object((D,(P,I))), not object((D,(P,I-1))), I > 0.

% Generate associations between objects
association((()), (D,((),I))) :- object((D,((),I))).
association((D1,(P,I1)), (D2,((D1,(P,I1)),I2))) :- object((D2,((D1,(P,I1)),I2))).

% Determine types of objects and reverse
object((),T) :- object(()), root(T).
object(O',T) :- association(O,O'), object(O,S), O' = ((D,_)), part(S,T,D,_,_).
object(O) :- object(O,T).


% Match associations and parts TODO


% Assign values to attribute variables
{ val((O,D),V) : dom(T,D,V) } :- object(O,T), attr(T,D,"atomic").

% Exactly one value has to be assigned for an attribute variable
:- attr(T,D,"atomic"), object(O,T), not val((O,D),_).
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
val((O,D),V) :- object(O,T), attr(T,D,"count"), V = #count { O',P : path(T,D,P), selector(O,P,O') }.
% Sum
val((O,D),V) :- object(O,T), attr(T,D,"sum"), V = #sum { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
% Min
val((O,D),V) :- object(O,T), attr(T,D,"min"), V = #min { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
% Max
val((O,D),V) :- object(O,T), attr(T,D,"max"), V = #max { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Table constraints

% Generate cross product tuples for each object and corresponding constraint
var_tuple((O,C),N,((),X)) :- object(O,T), max_column_index((T,C),N), selector(O,P,X), column((T,C),N,P).
var_tuple((O,C),N,(VT,X)) :- object(O,T), var_tuple((O,C),N+1,VT), selector(O,P,X), column((T,C),N,P), N>=0.
% var_tuple((O,C),VT) :- var_tuple((O,C),0,VT).

% For each tuple check that it satisfies some row
% by unpacking the nested tuples and checking the columns from left to right
sat_row((O,C),VT,0,Row,VT') :- object(O,T), var_tuple((O,C),0,VT), VT = (VT',X), val(X,V), entry((T,C),0,Row,V).
sat_row((O,C),VT,Col,Row,VT'') :- object(O,T), sat_row((O,C),VT,Col-1,Row,VT'), VT' = (VT'',X), val(X,V), entry((T,C),Col,Row,V).

% A table constraint is not satisfied if some tuple does not satisfy all values in a row
unsat(C) :- var_tuple(C,0,VT), not sat_row(C,VT,_,_,()).
:- unsat(C).


%%% Comparison constraints
left_compare((O,C),Op,X) :- object(O,T), constraint((T,C),Op), left((T,C),P), selector(O,P,X).
right_compare((O,C),Op,X) :- object(O,T), constraint((T,C),Op), right((T,C),P), selector(O,P,X).

sat(C,"eq") :- left_compare(C,"eq",X1), right_compare(C,"eq",X2), val(X1,V1), val(X2,V2), V1 = V2.
sat(C,"neq") :- left_compare(C,"neq",X1), right_compare(C,"neq",X2), val(X1,V1), val(X2,V2), V1 != V2.
sat(C,"lt") :- left_compare(C,"lt",X1), right_compare(C,"lt",X2), val(X1,V1), val(X2,V2), V1 < V2.
sat(C,"lte") :- left_compare(C,"lte",X1), right_compare(C,"lte",X2), val(X1,V1), val(X2,V2), V1 <= V2.
sat(C,"gt") :- left_compare(C,"gt",X1), right_compare(C,"gt",X2), val(X1,V1), val(X2,V2), V1 > V2.
sat(C,"gte") :- left_compare(C,"gte",X1), right_compare(C,"gte",X2), val(X1,V1), val(X2,V2), V1 >= V2.
unsat((O,C)) :- object(O,T), constraint((T,C),Op), not sat((O,C),Op), Op != "table".

#show val/2.
