graph(default).
attr(graph,default,compound,true). % <---- Needed for ltail to work

% attr(graph,default,splines,ortho).
attr(graph,default,rankdir,"TB").
% attr(graph,default,nodesep,"0.2").
attr(graph,default,ranksep,"0.02").



%%%%%%%%%%%%%%%%%%
%%% Type and part graph
%%%%%%%%%%%%%%%%%%
graph(model,default).
attr(graph,model,label,"Configuration Model").

% attr(graph,model,fontsize,20).
attr(graph,model,style,invis).
% attr(graph_nodes,model,penwidth,"1.5").
attr(graph_edges,model,arrowhead,empty).
attr(graph_edges,model,style,solid).
% attr(graph_edges,model,penwidth,"1.5").

% Generate nodes
node(T,model)                           :- type(T).

attr(node,T,label,@concat(
                        "{% set attr = attr|default({}) %}",
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD ><B>{{name.capitalize()}} </B></TD></TR>",
                        "<TR><TD ALIGN='left'> {% for key,a in attr|dictsort %} {{a}} {% endfor %} </TD></TR>",
                        "</TABLE>>"))   :- type(T).

attr(node,T,(label,name),T)             :- type(T).
attr(node,T,(label,attr,(0,D)),@format("<B>{0}: {1}</B><br ALIGN='left' />",D,F)) :- attr(T,D,F). % Aggregate attributes
attr(node,T,(label,attr,(1,D)),@format("{0}<br ALIGN='left' />",D)) :- attr(T,D). % Atomic attributes

attr(node, T, shape, rectangle)         :- type(T).
attr(node, T, style, "filled")          :- type(T).
attr(node, T, fillcolor, "#fdfdb4")     :- type(T).
attr(node, T, color, "black")           :- type(T).
attr(node, T, margin, 0)                :- type(T).
attr(node, T, width, 0)                 :- type(T).
attr(node, T, height, 0)                :- type(T).


% Generate edges for parts
edge((S,T,D),model)                             :- part(S,T,D).
attr(edge,(S,T,D),arrowhead,empty)              :- part(S,T,D).
attr(edge,(S,T,D),fontsize,10)                  :- part(S,T,D).
attr(edge,(S,T,D),minlen,1)                     :- part(S,T,D).


attr(edge,(S,T,D),label,@concat("<<TABLE BORDER='0' CELLSPACING='0' CELLPADDING='1'>",
                                    "<TR><TD><FONT>{{name}}</FONT></TD></TR>",
                                    "<TR><TD>{ {{n.values() | list | join(', ')}} }</TD></TR>",
                                    "</TABLE>>")) :- part(S,T,D).

attr(edge,(S,T,D),(label,name),D) :- part(S,T,D).
attr(edge,(S,T,D),(label,n,N),N) :- multiplicity(S,T,D,N).


% % attr(edge,(S,(S,D,"port")),style,normal)    :- part(S,T,D).
% attr(edge,(S,(S,D,"port")),arrowhead,none)  :- part(S,T,D).
% attr(edge,((S,D,"port"),T),arrowhead,empty) :- part(S,T,D).
% attr(node,(S,D,"port"),style,filled)        :- part(S,T,D).
% attr(node,(S,D,"port"),color,white)         :- part(S,T,D).
% attr(node,(S,D,"port"),fontsize,10)         :- part(S,T,D).
% attr(node,(S,D,"port"),height,"0.01")       :- part(S,T,D).
% attr(node,(S,D,"port"),label,D)             :- part(S,T,D).

%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%
graph((constraints,T),default)                      :- constraint((T,_),_).
attr(graph,(constraints,T),style,"filled")          :- constraint((T,_),_).
attr(graph,(constraints,T),fillcolor,"#f4f4f4")     :- constraint((T,_),_).

% One node for each constraints
node((T,I),(constraints,T)) :- constraint((T,I),_).
attr(node, (T,I), shape, rectangle) :- constraint((T,I),_).
attr(node, (T,I), margin, 0)        :- constraint((T,I),_).
attr(node, (T,I), width, 0)         :- constraint((T,I),_).
attr(node, (T,I), height, 0)        :- constraint((T,I),_).

% Connect types with their constraints
edge((T,(T,0))) :- constraint((T,0),_).
attr(edge,(T,(T,0)),lhead,@cluster((constraints,T))) :- constraint((T,0),_).
attr(edge,(T,(T,0)),arrowhead,none)                  :- constraint((T,0),_).

% Sort table constraints
edge(((T,I1),(T,I2))) :- constraint((T,I1),_), constraint((T,I2),_), I2 = I1 +1.
attr(edge,((T,I1),(T,I2)),style,invis) :- constraint((T,I1),_), constraint((T,I2),_), I2 = I1 +1.


% Table constraints
attr(node,(T,I),label,@concat(
                        "{% set num_col=header|length %}",
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD COLSPAN='{{num_col}}'><B>({{name.capitalize()}},{{index}})</B></TD></TR>",
                        "<TR>{% for key,p in header|dictsort %}<TD ALIGN='left'> {{p}} </TD>{% endfor %}</TR>",
                        "{% for r in rows.values() %} <TR>",
                            "{% for c in cols.values() %} <TD>",
                                "{{ entry[(r|int,c|int)] }}",
                            "</TD> {% endfor %}",
                        "</TR> {% endfor %}",
                        "</TABLE>>"))       :- constraint((T,I),"table").


attr(node,(T,I),(label,name),T)             :- constraint((T,I),_).
attr(node,(T,I),(label,index),I)            :- constraint((T,I),_).


attr(node,(T,I),(label,header,Col),     @format("{0}",@dis(P)))
                                                            :- constraint((T,I),"table"), column((T,I),Col,P).
attr(node,(T,I),(label,entry,(Row,Col)),@format("{0}",V))   :- constraint((T,I),"table"), entry((T,I),(Col,Row),V).
attr(node,(T,I),(label,cols,Col),       @format("{0}",Col)) :- constraint((T,I),"table"),  entry((T,I),(Col,_),_).
attr(node,(T,I),(label,rows,Row),       @format("{0}",Row)) :- constraint((T,I),"table"), entry((T,I),(_,Row),_).

% Comparison constraints
attr(node,(T,I),label,@concat(
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD ><B>({{name.capitalize()}},{{index}})</B></TD></TR>",
                        "<TR><TD >{{expr|e}}</TD></TR>",
                        "</TABLE>>"))                        :- constraint((T,I),Kind), Kind != "table".

attr(node,(T,I),(label,expr),@format("{0} {2} {1}",@dis(P1),@dis(P2),S))
                                            :- constraint((T,I),Kind), symbol(Kind,S), left((T,I),P1), right((T,I),P2).

symbol("eq","==").
symbol("lt","<").
symbol("lte","<=").
symbol("gt",">").
symbol("gte",">=").



#script (python)
from clingo.symbol import String

def dis(path):
    if str(path.name) == 'constant':
        return path
    disentangled = disentangle(path,[])
    return String(f'({",".join(disentangled)})')

def disentangle(input,output):
    output.insert(0,str(input.arguments[0]))

    if str(input.arguments[1]) != "()":
        output = disentangle(input.arguments[1],output)
    return output

def cluster(s):
    """
    Returns the cluster name for a graph
    Args:
        s: The identifier of the graph
    Returns:
        (clingo.Symbol.String) The string with the cluster name
    """
    val = str(s).strip('"')
    return String("cluster_"+val)
#end.

#defined type/1.
#defined part/3.
#defined multiplicity/4.
#defined attr/2.
#defined attr/3.
#defined object/2.
#defined association/2.


% attr(graph_nodes, const, shape, rectangle).
% attr(graph_nodes, const, style, "filled").
% attr(graph_nodes, const, fillcolor, "#FFFFFF").
% attr(graph_nodes, const, color, "black").
% attr(graph_nodes, const, margin, 0).
% attr(graph_nodes, const, width, 0).
% attr(graph_nodes, const, height, 0).


% % Instantiation
% graph(instantiation,default).
% attr(graph,instantiation,label,"(Partial) instantiation").
% attr(graph,instantiation,style,invis).
% node(O,instantiation) :- object(O,_).

% % Generate edges and nodes for associations
% edge((S,(D,"assoc")),instantiation)            :- association(S,(D,_)).
% node((D,"assoc"),instantiation)       :- association(_,(D,_)).
% edge(((D,"assoc"),T),instantiation)   :- association(_,T), T = (D,_).


% attr(edge,(S,(D,"assoc")),arrowhead,none)   :- association(S,(D,_)).
% % attr(edge,(D,T),arrowhead,normal)           :- association(S,(D,_)).
% attr(node,(D,"assoc"),label,"")             :- association(_,(D,_)).
% attr(node,(D,"assoc"),style,invis)          :- association(S,(D,_)).
% attr(node,(D,"assoc"),fontsize,0)           :- association(S,(D,_)).
% attr(node,(D,"assoc"),height,"0.02")        :- association(S,(D,_)).

% % Mappings
% edge((T,O)) :- object(O,T).
% attr(edge,(T,O),color,blue) :- object(O,T).
% attr(edge,(T,O),penwidth,"1.8") :- object(O,T).

% edge(((S,D,"port"),(D,"assoc"))) :- part(S,_,D), association(_,(D,_)).
% attr(edge,((S,D,"port"),(D,"assoc")),color,red) :- part(S,_,D), association(_,(D,_)).
% attr(edge,((S,D,"port"),(D,"assoc")),penwidth,"1.8") :- part(S,_,D), association(_,(D,_)).



% %%% Attributes
% % Model

% % Instantiation
% attr(graph_edges,instantiation,arrowhead,normal).
% attr(graph_edges,instantiation,style,solid).

% % Mappings
% attr(graph_edges,default,arrowhead,none).
% attr(graph_edges,default,style,dotted).

