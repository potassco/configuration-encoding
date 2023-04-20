# Configuration Encoding

## Get started
To get started have a look at kids bike example (`examples/kids_bike/model.lp`).

Run this by
```
clingo encoding.lp examples/kids_bike/model.lp --opt-mode=enum 0
```

The output contains the objects and attribute variables with their values, e.g.
```
Answer: 1
object((),bike)
object((frontWheel,((),0)),wheel)
object((rearWheel,((),0)),wheel)
val(((),color),yellow)
al(((),wheelSupport),no)
val(((frontWheel,((),0)),size),18)
val(((rearWheel,((),0)),size),18)
```

For a bit more involved example you can the bike example (has about 600 stable models)
```
clingo encoding.lp examples/bike/model.lp --opt-mode=enum 0
```
## Clingraph (under development)
Visualize the configuration models with clingraph using e.g.
```
cd examples/bike
clingraph model.lp --viz-encoding ../viz.lp --type=digraph --out=render  --dir="." --name-format=clingraph --format=png
```
## Fact format
### Configuration model

#### Types
There is a type named `T`.
```
type(T).
```
#### Partonomic ports
There is a partonomic part from type `S`
to type `T` with descriptor `D`.
Its possible multiplicities are given by `N1`, `N2`,...
```
part(S,T,D).
multiplicity(S,T,D,N1)
multiplicity(S,T,D,N2)
...
```

#### Connection ports
TODO

#### Attributes
Type `T` has an attribute with descriptor `D`.
An attribute can be
- atomic (default, requires a domain of values)
- calculated (requires an aggregate function and path expressions)
    - sum
    - count
    - max
    - min
```
attr(T,D).
attr(T,D,"count").
attr(T,D,"sum").
attr(T,D,"max").
attr(T,D,"min").
```

For atomic attributes the domain of attribute `D` of type `T` contains value `V`.
```
dom(T,D,V)
```

For calculated attributes `D` of type `T`
the input to the aggregate function are paths `P1`, `P2`,...
```
path(T,D,P1).
path(T,D,P2).
...
```

#### Path expressions
TODO
```
((),bike)
(((),bike),front_wheel)
```

#### Constraints
A constraint is identified by the type `T` it is attached to, an index `I` and the kind of constraint. Possible options are
- Table (`table`)
- Comparison (`eq`,`lt`,`lte`,`gt`,`gte`)

For example
```
constraint((T,I),"table").
constraint((T,I),"eq").
```

##### Table constraints

For table constraints the columns are identified by path expressions.
Columns `Col` of constraint `(T,I)`
point to attributes `P`,
where `P` is a attribute path expressions.
```
column((T,I),Col,P).
```
The entry of table constraint `(T,I)`
has value `V` in column `Col` and row `Row`.
```
entry((T,I),(Col,Row),V).
```
##### Comparison constraints
For comparision constraints a left and right path need to be specified.
Constraint `(T,I)` compares attributes `P1` and `P2`
which are both attribute path expressions.
````
left((T,I),P1).
right((T,I),P2).
```
