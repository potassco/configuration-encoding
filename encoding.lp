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

% Set of port and attribute descriptors has to be disjoint
descriptor("port",D) :- part(_,_,D,_,_).
desciptor("attribute",D) :- attr(_,D,_).
:- descriptor("port",D), desciptor("attribute",D).

% For a given type an attribute can only be declared once
attr(T,D,"atomic") :- attr(T,D).
:- attr(T,D,E), attr(T,D,E'), E < E'.

% Number of columns/paths and their for a constraint
max_row_index(C,N) :- constraint(C), N = #max{ R: entry(C,_,R,_)}.
max_column_index(C,N) :- constraint(C), N = #max{ P : column(C,P,_)}.

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% User requirements check
%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Given attribute values have to lie inside range
:- val((O,D),V), attr(T,D), object(O,T), not dom(T,D,V).

% Check that all objects have values assigned (totality)?

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantiation
%%%%%%%%%%%%%%%%%%%%%%%%%

% There needs to be always a root object
object(()).

% Object generation
Min { object((D,(P,I))) : I = 0..Max } Max :- object(P,S), part(S,T,D,Min,Max).

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
{ val((O,D),V) : dom(T,D,V) } :- object(O,T), attr(T,D).

% Exactly one value has to be assigned for an attribute variable
:- attr(T,D), object(O,T), not val((O,D),_).
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
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D).

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
%%% Table constraints
%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate cross products for each object and corresponding constraint
var_tuple((O,C),N,X) :- object(O,T), max_column_index((T,C),N), selector(O,P,X), column((T,C),N,P).
var_tuple((O,C),N,(VT,X)) :- object(O,T), var_tuple((O,C),N+1,VT), selector(O,P,X), column((T,C),N,P), N>=0.
var_tuple((O,C),VT) :- var_tuple((O,C),0,VT).

% num_tuples((O,C),N) :- object(O,T), constraint((T,C)), N = #count{ VT : var_tuple((O,C),VT) }.
tuple_order((O,C),VT,I) :- object(O,T), constraint((T,C)), var_tuple((O,C),VT), I = #count{ VT': var_tuple((O,C),VT'), VT'<VT }.

disentangle((O,C),I,N+1,VT) :- object(O,T), var_tuple((O,C),VT), tuple_order((O,C),VT,I), max_column_index((T,C),N).
disentangle((O,C),I,N,VT') :- disentangle((O,C),I,N+1,VT), VT = (VT',E), N>0.
cross((O,C),I,X) :- disentangle((O,C),I,N,(VT,X)), N > 1.
cross((O,C),I,X) :- disentangle((O,C),I,1,X).


% A row is satisfied if all entries
% unsat((O,C),I,R) :- object(O,T), cross((O,C),I,X), entry((T,C),_,R,V), not val(X,V).
% sat((O,C),I) :- object(O,T), constraint((T,C)), max_row_index(C,N), tuple_order((O,C),_,I), R=0..N, not unsat((O,C),I,R).
% #show disentangle/4.

% % A tuple is valid, if all its values correspond to one of the rows
row((O,C),P,I,R) :- object(O,T), cross((O,C),I,X), selector(O,P,X), val(X,V), column((T,C),PI,P), entry((T,C),PI,R,V).
% row((O,C),I) :- object(O,T), cross((O,C),I,X), selector(O,P,X). %, val(X,V), column((T,C),PI,P), entry((T,C),PI,R,V).

sat((O,C),I,R) :- object(O,T), constraint((T,C)), tuple_order((O,C),_,I), max_column_index((T,C),N-1), max_row_index((T,C),NR), R = 0..NR, N = #count { P: row((O,C),P,I,R)}.
unsat((O,C)) :- object(O,T), constraint((T,C)), tuple_order((O,C),_,I), not sat((O,C),I,_).
:- unsat(C).

#show val/2.

% Check partonomic cardinalities
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

