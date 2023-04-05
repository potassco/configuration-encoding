# Configuration Encoding

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
Its min and max cardinality are `Min` and `Max`.
```
part(S,T,D,Min,Max).
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
A constraint is identified by the type `T` it is attached to and an index `I`.
```
constraint((T,I)).
```

For table constraints the columns are identified by path expressions.
Columns `Col` of constraint `(T,I)`
point to attributes `P`,
where `P` is a (attribute) path expressions.
```
column((T,I),Col,P).
```
Table constraint `(T,I)`
has value `V` in column `Col` and row `Row`.
```
entry((T,I),Col,Row,V).
```

TODO: Other types of constraints (smaller, equal, larger,...)
