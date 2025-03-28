s.boot;
(
~plc = TempoClock;
~plc.tempo_(1);
)

t = TempoClock;
t.beats;

(
x = 100;
~plc.tempo_(x);
)
~plc.tempo;

(
var a, x;
a = Pfunc({ var rand;
	rand = exprand(0.1, 2.0) + #[1, 2, 3, 6].choose;
	~plc.tempo_(rand);
}, { \reset.postln });
x = a.asStream;
x.nextN(20).postln;
x.next;
x.reset;
)
(
x.next;
~plc.tempo;
)
exprand(0.1, 2.0);

a = Scheduler(SystemClock);
a.play(Routine { 5.do { arg i; i.postln; 1.yield } });
a.advance(0.9);

x = Scheduler(TempoClock.default);
(
t = Task { inf.do { |i|
        ("next " ++ i ++ " in task." + Main.elapsedTime).postln;
        0.5.wait;
    }
};
t.start;
x.play(t);
)
x.seconds;
t;
x.advance(1.1);

~plc.timeToNextBeat;

(
r = Routine {
	~plc.beats.postln;
	~plc.timeToNextBeat.wait;
		~plc.beats.postln;
	0.01.wait;
	~plc.timeToNextBeat.wait;
		~plc.beats.postln;
	0.01.wait;
	~plc.timeToNextBeat.wait;
}
)

r.next;

(
r = Routine {
	inf.do{ |i|
	~plc.timeToNextBeat.wait;

	~plc.beats.postln;
	0.01.wait;
	};
}
)

//plc
(
~fl_plc = FunctionList.new;
~c_plc = TempoClock.new;
~r_plc = Routine{
	inf.do{ |i|
	~c_plc.timeToNextBeat.wait;
	~fl_plc.value;
	0.01.wait;
	};
};

~r_plc.play(~c_plc,quant:1);
~c_plc.tempo_(1000);
)
~c_plc.tempo;
~fl_plc.addFunc({ 800.rand.postln });


//tempo manipulation
t = TempoClock.new;
~tempoIntegrator = ClockedIntegrator(1/~c_plc.tempo);
~tempoIntegrator.value_(TempoClock.tempo);
~tempoIntegrator.value;
~tempoIntegrator.slope_(0.0);
~tempoIntegrator.slope;

t.tempo_(~tempoIntegrator.next);
~fl_plc.addFunc({t.tempo_(~tempoIntegrator.next); });
~fl_plc.addFunc({t.tempo.postln; });
~fl_plc.addFunc({~c_plc.beats.postln; });
t.tempo;


//link to knob
MIDIClient.init;
~m_akai_mpk = MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MPKmini2")};
(
BasicMIDIControl([~m_akai_mpk, \omni], 8, { arg val; ~tempoIntegrator.slope_(val.linlin(0,127,-0.1,0.1 ))});
)
(
BasicMIDIControl([~m_akai_mpk, \omni], 1, { arg val; val.postln});
)
s.boot;