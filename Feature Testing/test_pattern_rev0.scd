t = MyTempoClock.new;
y = MyTempoClock.new;
u = MyObject.new;
u.addDependant(y);
u.num_(4);
u.num

(
p = {
	t.beats.postln;
	t.beats.mod(0.1).postln;
	0.10;
};
)

t.play(p,1);

t.addDependant(y);
t.dependants;
y.dependants;
t.tempo
t.tempo_(2);
y.tempo
t.changed