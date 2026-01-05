MidiHidSystem.remove(0);
MidiHidSystem.post;


// naming
(
~mXone = MidiInOutPair("XoneDX-SuperCollider","SuperCollider-XoneDX");
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
~mLaunchPad = MidiInOutPair("LPMini-SuperCollider","MIDIOUT2 (LPMiniMK3 MIDI)", [240, 0, 32, 41, 2, 13, 14, 1, 247], [45, 21]); // we send the sysex message to change to programmer mode
)
// busses and buffers
(
//b = Buffer.read(s, "C:/Users/piert/MakingMusic/Samples/leaves-crunching-6954-bounce-2.wav");
b = Buffer.read(s, "C:/Users/piert/MakingMusic/Samples/Falling/rocks-6129.mp3");
q = Bus.control(s,4);
~windBus = Bus.audio(s,2);
)

// groups
(
g = Group.new;
)

// server knobs
(
k = SynthDef("knobs",{
	var knob1, knob2, knob3, knob4;
	knob1 = ServerControlLag.kr(\knob1, 0.5);
	knob2 = ServerControlLag.kr(\knob2, 0.5);
	knob3 = ServerControlLag.kr(\knob3, 0.5);
	knob4 = ServerControlLag.kr(\knob4, 0.5);
	Out.kr(q,[knob1, knob2, knob3, knob4]);
}).play(g, addAction: 'addBefore');
)

//sound synthdef
(
SynthDef("wind",{arg buf, rate = 1, pos = 0, pan = 0;
	var env, out, bufLength,knobs;
	knobs = In.kr(q, 4);
	bufLength = BufDur.kr(buf);
	out = PlayBuf.ar(2,buf,rate*knobs[0].linexp(0,1,0.1,1000), loop: 1, startPos: bufLength.rand);
	env = Env(levels: [0,1,0],times: [knobs[2],knobs[3].linlin(0,1,0,3)]);
	Out.ar(~windBus,Pan2.ar(out,pos)*EnvGen.ar(env, doneAction: Done.freeSelf));
}).add;

o = SynthDef("out", {
	Out.ar(0, In.ar(~windBus,2)*ServerControlLag.kr(\volume, 0.5).linlin(0,1,-30,30).dbamp;);
}).play(g,addAction: \addAfter);
)

// sound
(
f = {var par;
	Synth("wind",[\buf, b, \rate, 1+0.2.rand, \pos, 0, \pan, 2.0.rand -1], g);
	par = m.value.linexp(0,1,0.01,5);
	par + par.sqrt.sum3rand;
}
)

// eq
(
e = MultiEQ.new(2, \eq, 600, 0.7, 1.8, \loshelf, 200, 0.1, \eq, 11000, 1.5, 1.5);
e.play(g, ~windBus);
MultiEQGUI.new(e)
)

//comp
(
r = SynthDef("comp", {
	var input, output, tresh, slopeBelow, slopeAbove, clampTime, relaxTime;
	input = In.ar(~windBus,2);
	tresh = ServerControlLag.kr(\tresh, 0.5);
	slopeBelow =ServerControlLag.kr(\slopeBelow, 0.5);
	slopeAbove=ServerControlLag.kr(\slopeAbove, 0.5);
	clampTime=ServerControlLag.kr(\clampTime, 0.5);
	relaxTime=ServerControlLag.kr(\relaxTime, 0.5);
	output = Compander.ar(input, input,tresh, slopeBelow, slopeAbove, clampTime, relaxTime);
	ReplaceOut.ar(~windBus,output);
}).play(g,addAction:\addToTail)
)

// language knob
(
m = Value.new(0.1);
MidiCC([97, 0, ~mBcr], ContinuousLangTarget(m, \value), mode: \absolute);
)

// knob mapping for server knobs
(
MidiCC([89, 0, ~mBcr], ServerTarget(k, \knob1), mode: \absolute);
MidiCC([90, 0, ~mBcr], ServerTarget(k, \knob2), mode: \absolute);
MidiCC([91, 0, ~mBcr], ServerTarget(k, \knob3), mode: \absolute);
MidiCC([92, 0, ~mBcr], ServerTarget(k, \knob4), mode: \absolute);
MidiCC([98, 0, ~mBcr], ServerTarget(o, \volume), mode: \absolute);
MidiCC([100, 0, ~mBcr], ServerTarget(r, \tresh), mode: \absolute);
MidiCC([101, 0, ~mBcr], ServerTarget(r, \slopeBelow), mode: \absolute);
MidiCC([102, 0, ~mBcr], ServerTarget(r, \slopeAbove), mode: \absolute);
MidiCC([103, 0, ~mBcr], ServerTarget(r, \clampTime), mode: \absolute);
MidiCC([104, 0, ~mBcr], ServerTarget(r, \relaxTime), mode: \absolute);
)

// start the sound
(
c = TempoClock.new();
c.sched(1,f);
)


// shit
m.value.linexp(0,1,0.001,5)
s.plotTree;
s.numSynths;
c.stop;