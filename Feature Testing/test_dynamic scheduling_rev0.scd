t = TempoClock();

~f1 = {5.postln};
~f2 = {6.postln};
Tdef(\f,~f2);
t.sched(1,Tdef(\f).play);
r = Tdef(\f).play

r = 4;
r.value(3);
w = (r = _)
f = { |val| r = val };
f.value(3)
f.value(4)
r
r.reset
k = r.value
k.class
Integer.browse
r.listVars
Integer.instVarNames
Node.instVarNames

