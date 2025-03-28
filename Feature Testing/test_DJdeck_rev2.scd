s.boot;
b.free;
b = Buffer.read(s, "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Correndo Nu Escuro.mp3");
b = Buffer.read(s, "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3");




(
SynthDef("DJdeck", { |bus = 0, mute = 1, pos, bufnum, trackTempo, deckTempoBus|
	var rate, trig, output;
	rate =  BufRateScale.kr(bufnum) * In.kr(deckTempoBus) / trackTempo;
	trig = Changed.kr(pos);
	output = PlayBuf.ar(2, bufnum, rate, trig, pos);
	output = output * mute;
	Out.ar(bus, output);
}).add;
)

y = Synth("DJdeck",[\bufnum, b.bufnum, \deckTempoBus, t.bus, \trackTempo, 125]);


//do we hear a click when we jump? do we need to crossfade

b = nil;
b.free;
b = Buffer.alloc(s,100,2);

b.sampleRate

o = Bus.audio(s,2);
d = DJdeck(o);
d.loadTrack;
d.clock.tempo
d.pause
d.play
d.synth.trace
d.beatJump(8);
d.buffer.sampleRate
d.clock.beats;
d.clock.bus.getSynchronous
d.clock.tempo

b.numFrames/b.sampleRate/60

t.beats;
t.stop
t.tempo_(0.1);

t = TempoClock.new();
t.setTempoAtBeat(0,t.beats)
t.tempo

-5.abs
3<=5

s.boot
t = MyTempoClock(3);
t.beats;
t.te
t.tempo_(3)
t.tempo
t.beats

true && true