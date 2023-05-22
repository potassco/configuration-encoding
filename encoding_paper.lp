% Simplified encoding that does not support connection ports
% and only supports table constraints
partonomic_path(X,Y) :- part(X,Y,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

object((),T) :- root(T).

{ object((D,(O,I)),T) : I = 0..Max-1 } :- object(O,S), part(S,T,D), Max = #max { N : multiplicity(S,T,D,N)}.
:- object((D,(O,I)),_), not object((D,(O,I-1)),_), I > 0.

:- part(S,T,D), object(O,S), not multiplicity(S,T,D,X), X = #count { I : object((D,(O,I)),T) }.

{ val((O,D),V) : dom(T,D,V) } :- object(O,T), attr(T,D).
:- attr(T,D), object(O,T), not val((O,D),_).
:- val(X,V1), val(X,V2), V1 < V2.

attr(T,D,"atomic") :- attr(T,D).
selector(O,(),O) :- object(O,_).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I)),_).
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D,_).

val((O,D),V) :- object(O,T), attr(T,D,"count"), V = #count { O',P : path(T,D,P), selector(O,P,O') }.
val((O,D),V) :- object(O,T), attr(T,D,"sum"), V = #sum { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
val((O,D),V) :- object(O,T), attr(T,D,"min"), V = #min { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.
val((O,D),V) :- object(O,T), attr(T,D,"max"), V = #max { V',X,P : path(T,D,P), val(X,V'), selector(O,P,X) }.

max_column_index(C,N) :- constraint(C,"table"), N = #max{ Col : column(C,Col,_)}.
var_tuple((O,C),N,((),X)) :- object(O,T), max_column_index((T,C),N), selector(O,P,X), column((T,C),N,P).
var_tuple((O,C),N,(VT,X)) :- object(O,T), var_tuple((O,C),N+1,VT), selector(O,P,X), column((T,C),N,P), N>=0.

sat_row((O,C),VT,(0,Row),VT') :- object(O,T), var_tuple((O,C),0,VT), VT = (VT',X), val(X,V), entry((T,C),(0,Row),V).
sat_row((O,C),VT,(Col,Row),VT'') :- object(O,T), sat_row((O,C),VT,(Col-1,Row),VT'), VT' = (VT'',X), val(X,V), entry((T,C),(Col,Row),V).

:- var_tuple(C,0,VT), not sat_row(C,VT,_,()).

#show object/2.
