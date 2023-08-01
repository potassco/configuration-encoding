#const max_sem=2.

type(plan).
type(semester).

part(plan, semester, (sem,1..max_sem)).
multiplicity(plan, semester, (sem,1..max_sem), 0..1).

connection(semester,semester,previous).
multiplicity(semester,semester,previous,1).

attr(semester,id,"discrete").
dom(semester,id,1..max_sem).

constraint((plan,I),"table")           :- I = 0..max_sem-1.
column((plan,I),0,(id,((sem,I+1),()))) :- I = 0..max_sem-1.
entry((plan,I),(0,0),I+1)              :- I = 0..max_sem-1.

constraint((semester,0),"table").
column((semester,0),0,(id,())).                      column((semester,0),1,(id,(previous,()))).
entry((semester,0),(0,0),1).                         entry((semester,0),(1,0),1).
entry((semester,0),(0,I),I+1) :- I = 1..max_sem-1.   entry((semester,0),(1,I),I) :- I = 1..max_sem-1.
