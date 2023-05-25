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
val(((),wheelSupport),no)
val(((frontWheel,((),0)),size),18)
val(((rearWheel,((),0)),size),18)
```

For a bit more involved example you can the bike example (has about 600 stable models)
```
clingo encoding.lp examples/bike/model.lp --opt-mode=enum 0
```
## Clingraph

### Visualizing the configuration model
Visualize the configuration models with clingraph using the provided script
```
./make_plots.sh
```
The plots will be created in the respective folders with filename `clingraph.png`.

### Visualizing instantiations
Visualize the (partial) instantiations with the file `examples/viz_instantiation.lp`.
You can pipe the stable models to clingraph for this, e.g.

```
clingo encoding.lp examples/bike/model.lp --outf=2 | clingraph --viz-encoding examples/viz_instantiation.lp  --out=render
```

## Fact format
### Configuration model

#### Types
There is a type named `T`.
```
type(T).
```
#### Partonomic and connection ports
There is a partonomic/connection part from type `S`
to type `T` with descriptor `D`.
Its possible multiplicities are given by `N1`, `N2`,...
```
part(S,T,D).
multiplicity(S,T,D,N1)
multiplicity(S,T,D,N2)

connection(S,T,D).
...
```

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
the input to the aggregate function are path expressions `P1`, `P2`,... (see below)
```
path(T,D,P1).
path(T,D,P2).
...
```

#### Path expressions
Path expressions are encoded as nested tuple with the first descriptor being the innnermost,
e.g., the path `(frontWheel,size)` is encoded as `(size,(frontWheel,())`.


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
```
left((T,I),P1).
right((T,I),P2).
```

### Instantiation
#### Objects
There is an object with name `N` and type `T`.
```
object(N,T)
```

The name has a nested tuple structure with indices built up from the partonomic port descriptors of the object.
The root is always named `()`.
For example `object((frontWheel,((),0)),wheel)`
describes the first `frontWheel` of the root type `wheel`.

#### Valuations
The value of an attribute variable `A` is `V`.
```
val(A,V)
```
Attribute variables are tuples `(O,D)` with the object `O` and the attribute descriptor `D`.
