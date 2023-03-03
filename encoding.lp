% #include "model.lp".
% #include "instantiation.lp".

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
desciptor("attribute",D) :- attr(_,D).
:- descriptor("port",D), desciptor("attribute",D).

% Number of columns/paths and their for a constraint
num_rows(T,C,N) :- constraint(T,C), N = #max{ R: constraint(T,C,_,R,_)}.
num_paths(T,C,N) :- constraint(T,C), N = #count{ P : constraint(T,C,P,_,_)}.
order(T,C,P,I) :- constraint(T,C), constraint(T,C,P,_,_), I = #count{ P': constraint(T,C,P',_,_), P'<=P }.

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantiation
%%%%%%%%%%%%%%%%%%%%%%%%%

% Object generation
% Min { object(R,(P,D),I : I = 0..N) } Max :- object(R,P,I), part(S,D,T,Min,Max), N = Max-Min.

% Generate associations between objects
association((()), (D,((),I))) :- object((D,((),I))).
association((D1,(P,I1)), (D2,((D1,(P,I1)),I2))) :- object((D2,((D1,(P,I1)),I2))).

% Determine types of objects
object((),T) :- object(()), root(T).
object(O',T) :- association(O,O'), object(O,S), O' = ((D,_)), part(S,T,D,_,_).

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
% object selector: (O,P,O)
selector(O,(),O) :- object(O).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I))).
% attribute selector: (O,P,X)
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D).


%%% Table constraints
% Generate cross products for each object and corresponding constraint
var_tuple((O,C),N,X) :- object(O,T), num_paths(T,C,N), selector(O,P,X), order(T,C,P,N).
var_tuple((O,C),N,(VT,X)) :- object(O,T), var_tuple((O,C),N+1,VT), selector(O,P,X), order(T,C,P,N), N>0.
var_tuple((O,C),VT) :- var_tuple((O,C),1,VT).

num_tuples((O,C),N) :- object(O,T), constraint(T,C), N = #count{ VT : var_tuple((O,C),VT) }.
tuple_order((O,C),VT,I) :- object(O,T), constraint(T,C), var_tuple((O,C),VT), I = #count{ VT': var_tuple((O,C),VT'), VT'<VT }.

disentangle((O,C),I,N,VT) :- object(O,T), var_tuple((O,C),VT), tuple_order((O,C),VT,I), num_tuples((O,C),N).
disentangle((O,C),I,N,VT') :- disentangle((O,C),I,N+1,VT), VT = (VT',E), N>0.
cross((O,C),I,X) :- disentangle((O,C),I,N,(VT,X)), N > 1.
cross((O,C),I,X) :- disentangle((O,C),I,1,X).

% A tuple is valid, if all its values correspond to one of the rows
row((O,C),P,I,R) :- object(O,T), cross((O,C),I,X), selector(O,P,X), val(X,V), constraint(T,C,P,R,V).
sat((O,C),I,R) :- object(O,T), constraint(T,C), tuple_order((O,C),_,I), num_paths(T,C,N), num_rows(T,C,NR), R = 0..NR, N = #count { P: row((O,C),P,I,R)}.
unsat((O,C)) :- object(O,T), constraint(T,C), tuple_order((O,C),_,I), not sat((O,C),I,_).
:- unsat(C).

% Check partonomic cardinalities
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

%%% Aggregate constraints
agg((O,D),P,V) :- object(O,T), constraint(T,D,"count"), path(T,D,P), V = #count { O' : selector(O,P,O') }.
% agg(O,D,P,V) :- object(O,T), constraint(T,D,"sum"), path(T,D,P), V = #count { O' : selector(O,P,O') }.
val((O,D),V) :- object(O,T), constraint(T,D,_), V = #sum { V',P : agg((O,D),P,V') }.
% val(X,V) :- agg(X,V).


% #show agg/2.
% #show val/2.
