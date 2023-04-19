graph(default).
graph(model,default).
attr(graph,model,label,"Configuration Model").
% attr(graph,model,style,invis).

graph(instantiation,default).
attr(graph,instantiation,label,"(Partial) instantiation").
% attr(graph,instantiation,style,invis).

%%% Model
% Generate nodes
node(T,model)                           :- type(T).
attr(node,T,label,"<<b>{{name.capitalize()}}</b>>")  :- type(T).
attr(node,T,(label,name),T)             :- type(T).


% Generate edges and nodes for parts
edge((S,T,D),model)                             :- part(S,T,D).
attr(edge,(S,T,D),arrowhead,empty)              :- part(S,T,D).
attr(edge,(S,T,D),label,D)                      :- part(S,T,D).
attr(edge,(S,T,D),fontsize,10)                  :- part(S,T,D).



% edge((S,(S,D,"port")),model)   :- part(S,T,D).
% node((S,D,"port"),model)       :- part(S,T,D).
% edge(((S,D,"port"),T),model)   :- part(S,T,D).

% % attr(edge,(S,(S,D,"port")),style,normal)    :- part(S,T,D).
% attr(edge,(S,(S,D,"port")),arrowhead,none)  :- part(S,T,D).
% attr(edge,((S,D,"port"),T),arrowhead,empty) :- part(S,T,D).
% attr(node,(S,D,"port"),style,filled)        :- part(S,T,D).
% attr(node,(S,D,"port"),color,white)         :- part(S,T,D).
% attr(node,(S,D,"port"),fontsize,10)         :- part(S,T,D).
% attr(node,(S,D,"port"),height,"0.01")       :- part(S,T,D).
% attr(node,(S,D,"port"),label,D)             :- part(S,T,D).

% Instantiation
node(O,instantiation) :- object(O,_).

% Generate edges and nodes for associations
edge((S,(D,"assoc")),instantiation)            :- association(S,(D,_)).
node((D,"assoc"),instantiation)       :- association(_,(D,_)).
edge(((D,"assoc"),T),instantiation)   :- association(_,T), T = (D,_).


attr(edge,(S,(D,"assoc")),arrowhead,none)   :- association(S,(D,_)).
% attr(edge,(D,T),arrowhead,normal)           :- association(S,(D,_)).
attr(node,(D,"assoc"),label,"")             :- association(_,(D,_)).
attr(node,(D,"assoc"),style,invis)          :- association(S,(D,_)).
attr(node,(D,"assoc"),fontsize,0)           :- association(S,(D,_)).
attr(node,(D,"assoc"),height,"0.02")        :- association(S,(D,_)).

% Mappings
edge((T,O)) :- object(O,T).
attr(edge,(T,O),color,blue) :- object(O,T).
attr(edge,(T,O),penwidth,"1.8") :- object(O,T).

edge(((S,D,"port"),(D,"assoc"))) :- part(S,_,D), association(_,(D,_)).
attr(edge,((S,D,"port"),(D,"assoc")),color,red) :- part(S,_,D), association(_,(D,_)).
attr(edge,((S,D,"port"),(D,"assoc")),penwidth,"1.8") :- part(S,_,D), association(_,(D,_)).



%%% Attributes
% Model
attr(graph_nodes,model,penwidth,"1.5").
attr(graph_edges,model,arrowhead,empty).
attr(graph_edges,model,style,bold).
attr(graph_edges,model,penwidth,"1.5").

% Instantiation
attr(graph_edges,instantiation,arrowhead,normal).
attr(graph_edges,instantiation,style,solid).

% Mappings
attr(graph_edges,default,arrowhead,none).
attr(graph_edges,default,style,dotted).

#defined type/1.
#defined part/3.
#defined object/2.
#defined association/2.
