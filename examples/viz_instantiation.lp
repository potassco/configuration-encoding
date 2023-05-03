graph(instantiation).
attr(graph,instantiation,center,true).

attr(graph,instantiation,splines,polyline).
% attr(graph,instantiation,rankdir,"TB").
% attr(graph,instantiation,nodesep,"0.02").
% attr(graph,instantiation,ranksep,"0.02").



%%%%%%%%%%%%%%%%%%
%%% Objects
%%%%%%%%%%%%%%%%%%
attr(graph,instantiation,label,"Configuration instantiation").

% attr(graph,model,fontsize,20).
attr(graph,instantiation,style,invis).
% attr(graph_nodes,model,penwidth,"1.5").
attr(graph_edges,instantiation,style,solid).
% attr(graph_edges,model,penwidth,"1.5").

% Give objects global index
object(O,T,I) :- object(O,T), I = #count{ O': object(O',T), O'<O }.

% Generate nodes
node(O,instantiation)                    :- object(O,T).

attr(node,O,label,@concat(
                        "{% set attr = attr|default({}) %}",
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD ><B>{{name}}{{index}} </B></TD></TR>",
                        % "<TR><TD ALIGN='left'> {% for key,a in attr|dictsort %} {{a}} {% if not loop.last %} <br ALIGN='left' />  {% endif %} {% endfor %} </TD></TR>",
                        "<TR><TD ALIGN='left'> {% for key,a in attr|dictsort %} {{a}} {% endfor %} </TD></TR>",
                        "</TABLE>>"))   :- object(O,T).

attr(node,O,(label,name),T)             :- object(O,T).
attr(node,O,(label,index),I)            :- object(O,T,I).
attr(node,O,(label,attr,D),@format("{0} = {1} <br ALIGN='left' />",D,V)) :- val((O,D),V).

attr(node,O,shape,rectangle)            :- object(O,T).
attr(node,O,style,"filled")             :- object(O,T).
attr(node,O,fillcolor,"#ffdecd")        :- object(O,T).
attr(node,O,color,"black")              :- object(O,T).
attr(node,O,margin,0)                   :- object(O,T).
attr(node,O,width,0)                    :- object(O,T).
attr(node,O,height,0)                   :- object(O,T).

%%%%%%%%%%%%%%%%%%%
%%% Associations
%%%%%%%%%%%%%%%%%%
association((O1,O2))     :- object(O2,T), O2 = (_,(O1,_)).
edge(A,instantiation)    :- association(A).

attr(edge,A,label,D)     :- association(A), A = (_,(D,_)).
attr(edge,A,fontsize,11) :- association(A).



#defined type/1.
#defined part/3.
#defined multiplicity/4.
#defined attr/2.
#defined attr/3.
#defined object/2.
#defined association/2.












