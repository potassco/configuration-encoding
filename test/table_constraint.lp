%%% Model
type(bike). type(bag).
part(bike,bag,bags,0,2).

attr(bike,color).
attr(bike,color,("red";"yellow";"green")).
attr(bag,color).
attr(bag,color,("red";"yellow";"green")).

constraint(bike,0).
constraint(bike,0,(color,()),0,"red"). constraint(bike,0,(color,(bags,())),0,("red";"yellow")).
constraint(bike,0,(color,()),1,"green"). constraint(bike,0,(color,(bags,())),1,("green";"yellow")).
% constraint(bike,0,(color,()),1,"green"). constraint(bike,0,(color,(bag,())),1,"yellow").

%%% Instantiation
object(()).
object((bags,((),0))).
object((bags,((),1))).

val(((),color),"red").
val(((bags,((),0)),color),"red").
val(((bags,((),1)),color),"yellow").


% Cross products
(((),color),((bags,((),0)),color))
(((),color),((bags,((),1)),color))
