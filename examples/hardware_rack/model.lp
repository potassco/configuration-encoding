type(rack).
type(slot).
type(module).

part(rack,slot,slot).
multiplicity(rack,slot,slot,4).

part(rack,module,single).
multiplicity(rack,module,single,2).
part(rack,module,double).
multiplicity(rack,module,double,1).

connection(module,slot,mounted).
multiplicity(module,slot,mounted,1).
