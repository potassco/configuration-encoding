graph(default).
graph(model,default).
attr(graph,model,label,"Configuration Model").
% attr(graph,model,splines,ortho).
attr(graph,model,nodesep,"5").
attr(graph,model,rankdir,"TB").
% attr(graph,model,fontsize,20).
attr(graph,model,style,invis).
% attr(graph_nodes,model,penwidth,"1.5").
attr(graph_edges,model,arrowhead,empty).
attr(graph_edges,model,style,solid).
% attr(graph_edges,model,penwidth,"1.5").


%%% Model
% Generate nodes
node(T,model)                           :- type(T).
% attr(node,T,label,"<<b>{{name.capitalize()}}</b>>")  :- type(T).



attr(node,T,label,@concat(
                        % "{% set aggr = aggr|default({}) %}",
                        "{% set attr = attr|default({}) %}",
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD ><B>{{name.capitalize()}} </B></TD></TR>",
                        % "<TR><TD ALIGN='left'> {% for a in aggr.values() %} {{a}} {% endfor %} </TD></TR>",
                        "<TR><TD ALIGN='left'> {% for a in attr.values() %} {{a}} {% endfor %} </TD></TR>",
                        "</TABLE>>")) :- type(T).

attr(node,T,(label,name),T)             :- type(T).
attr(node,T,(label,attr,D),@format("<B>{0}: {1}</B><br ALIGN='left' />",D,F)) :- attr(T,D,F).
attr(node,T,(label,attr,D),@format("{0}<br ALIGN='left' />",D)) :- attr(T,D).

attr(graph_nodes, model, shape, rectangle).
attr(graph_nodes, model, style, "filled").
attr(graph_nodes, model, fillcolor, "#FFFFCE").
attr(graph_nodes, model, color, "black").
attr(graph_nodes, model, margin, 0).
attr(graph_nodes, model, width, 0).
attr(graph_nodes, model, hight, 0).

% Generate edges and nodes for parts
edge((S,T,D),model)                             :- part(S,T,D).
attr(edge,(S,T,D),arrowhead,empty)              :- part(S,T,D).
% attr(edge,(S,T,D),label,D)                      :- part(S,T,D).
attr(edge,(S,T,D),fontsize,10)                  :- part(S,T,D).

% attr(edge,(S,T,D),headlabel,"{ {% for x in n.values() %} {{x}} {% endfor %} }") :- part(S,T,D).

attr(edge,(S,T,D),headlabel,@concat("<<TABLE BORDER='0' CELLSPACING='0' CELLPADDING='1'>",
                                    "<TR><TD><FONT>{{name}}</FONT></TD></TR>",
                                    % "<TR><TD>{ {% for x in n.values() %} {{x}}, {% endfor %} }</TD></TR>",
                                    "<TR><TD>{ {{n.values() | list | join(', ')}} }</TD></TR>",
                                    "</TABLE>>")) :- part(S,T,D).

attr(edge,(S,T,D),(headlabel,name),D) :- part(S,T,D).
attr(edge,(S,T,D),(headlabel,n,N),N) :- multiplicity(S,T,D,N).

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


%%% Constraints
graph(const,default).
attr(graph,const,label,"Constraints").
% attr(graph,const,style,invis).
% edge((T,(T,I))) :- constraint((T,I),_).
node((T,I),const) :- constraint((T,I),_).

attr(node,(T,I),label,@concat(
                        "<<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0' CELLPADDING='1'>",
                        "<TR><TD ><B>({{name.capitalize()}},{{index}})</B></TD></TR>",
                        "<TR><TD >{{expr|e}}</TD></TR>",
                        "</TABLE>>"))                        :- constraint((T,I),Kind), Kind != "table".
attr(node,(T,I),label,@concat(
                        % "{% set header = header|default({}) %}",
                        % "{% set entry = entry|default({}) %}",
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
attr(node,(T,I),(label,expr),@format("{0} {2} {1}",@dis(P1),@dis(P2),S))
                                            :- constraint((T,I),Kind), symbol(Kind,S), left((T,I),P1), right((T,I),P2).

attr(node,(T,I),(label,header,Col),@format("{0}",@dis(P)))
                                            :- constraint((T,I),"table"), column((T,I),Col,P).
attr(node,(T,I),(label,entry,(Row,Col)),@format("{0}",V))    :- constraint((T,I),"table"), entry((T,I),(Col,Row),V).
attr(node,(T,I),(label,cols,Col),@format("{0}",Col))         :- constraint((T,I),"table"),  entry((T,I),(Col,_),_).
attr(node,(T,I),(label,rows,Row),@format("{0}",Row))         :- constraint((T,I),"table"), entry((T,I),(_,Row),_).

#script (python)
from clingo.symbol import String

def dis(path):
    disentangled = disentangle(path,[])
    return String(f'({",".join(disentangled)})')

def disentangle(input,output):
    output.insert(0,str(input.arguments[0]))

    if str(input.arguments[1]) != "()":
        output = disentangle(input.arguments[1],output)
    return output
#end.

symbol("eq","==").
symbol("lt","<").
symbol("lte","<=").
symbol("gt",">").
symbol("gte",">=").


column((wheel,0),1,(weight,())).

attr(graph_nodes, const, shape, rectangle).
attr(graph_nodes, const, style, "filled").
attr(graph_nodes, const, fillcolor, "#FFFFFF").
attr(graph_nodes, const, color, "black").
attr(graph_nodes, const, margin, 0).
attr(graph_nodes, const, width, 0).
attr(graph_nodes, const, hight, 0).


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

#defined type/1.
#defined part/3.
#defined object/2.
#defined association/2.
