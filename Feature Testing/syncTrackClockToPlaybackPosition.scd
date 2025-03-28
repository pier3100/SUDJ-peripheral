(
SynthDef("help-SendTrig",{ |trigIt|
	var dust, out, sw;
	sw = Sweep.kr(Changed.kr(trigIt));
	//dust = Changed.kr(Dust.kr(100)>0.5);
	out = Latch.ar(sw,T2A.ar(sw>=1));
	ReplaceOut.ar(~bScopeAr,out);
}).add;
)
(
// register to receive this message
o = OSCFunc({ arg msg, time;
    [time, msg].postln;
},'/tr', s.addr);
)

a = Synth("help-SendTrig");
a.set(\trigIt,2);
a.trace
a.free
o.free;

s.options.blockSize

~deck1.synth.nodeID

1/(Server.default.sampleRate / Server.default.options.blockSize)

~bScopeKr = Bus.control(s,1);
~bScopeAr= Bus.audio(s,1);
b = Bus.audio(s,2);
d = Bus.control(s);
(
SynthDef("testK2A",{
	var in, out;
	in = In.kr(d);
	out = Latch.ar(in,T2A.ar(Changed.kr(in)));
	Out.ar(b.index,[K2A.ar(in),out]);
}).add;
)
a = Synth("testK2A");
~timeTrace = TimeTrace.new(b, "C:/Users/piert/MakingMusic/SuperCollider/Data Analysis", 6);
d.setSynchronous(2)
a.trace
a.free
~bScopeAr.index

b= Bus.control(s,2);
~timeTrace = TimeTrace.new(b, "C:/Users/piert/MakingMusic/SuperCollider/Data Analysis", 3);
(
y = SynthDef("testSweep", {
	var in;
	in = Sweep.ar();
	Out.kr(b,[in,A2K.kr(in+ (Slope.ar(in) * 1 / ControlRate.ir / 2) )]);//
	//Out.kr(b,[in,A2Kcentered.kr(in)]);//
}).play;
)
y.trace
s.defaultGroup.freeAll;