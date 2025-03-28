s.boot;
Server.killAll;

(
SynthDef("DJdeck", { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 1, positionSetBus, jumpToPositionBus, trackTempo, deckTempoBus, bendEventPositive, bendEventNegative|
	var rate, rateBended, trig, output, position, jumpToPosition;
	var bendTrigPositive, bendTrigNegative, bend;
	var playAlong, reference;
	// pitch bending
	bendTrigPositive = Changed.kr(bendEventPositive);
	bendTrigNegative = Changed.kr(bendEventNegative);
	bend = bendTrigPositive - bendTrigNegative;
	bend = Lag.kr(bend, 0.4);

	// actual soundfile reading
	position = In.kr(positionSetBus);
	jumpToPosition = In.kr(jumpToPositionBus);
	rate =  BufRateScale.kr(bufnum) * In.kr(deckTempoBus) / trackTempo;
	rateBended = rate + bend;
	trig = Changed.kr(jumpToPosition);
	output = PlayBuf.ar(2, bufnum, rateBended, trig, position);
	playAlong = PlayBuf.ar(1, referenceBufnum, rateBended, trig, position);
	reference = PlayBuf.ar(1, referenceBufnum, rate, trig, position);
	Out.kr(referenceBus,[playAlong, reference]);
	output = output * mute;
	Out.ar(outputBus, output);
}).add;
)

(
l = MusicLibrary.newFromTraktor("C:\\Users\\PierTabak\\Music\\collection.nml");
t = l.findTitle("Tuvan 1")[0];
t.path = "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3";//overwrite path for now, because at different PC
o = Bus.audio(s,2);
d = DJdeck.new(o,125);
d.loadTrack(t);
)

d.trackBufferReady
d.referenceBufferReady
d.play;

d.userInducedGridOffset;
d.userInducedGridOffsetStatic

d.synth.set(\bendEventNegative,1.0.rand);
(
d.beatsReference.postln;
d.clock.beats.postln;
d.beatsReference - d.clock.beats;
)
d.clock.tempo = d.clock.tempo/4;
(
d.beatJump(-4);
d.clock.beats;
)
d.clock.tempo =125/60
d.loop=true
d.jumpToBeat(100);
d.jumpToBeat(200);
d.positionSetBus.setSynchronous(80);
d.positionSetBus.getSynchronous
d.synth.get(\pos,_.postln)
d.synth.set(\pos, 200)
d.synth.map(\pos,d.positionSetBus)
(
SynthDef(\pitchBend,{ |bus, bendEventPositive, bendEventNegative|
	var trigPositive, trigNegative, trig, output;
	trigPositive = Changed.kr(bendEventPositive);
	trigNegative = Changed.kr(bendEventNegative);
	trig = trigPositive - trigNegative;
	output = Lag.kr(trig, 2);
	Out.kr(bus, output);
}).add;
)

b = Bus.control;

y = Synth(\pitchBend,[\bus,b]);
y.set(\bendEventNegative, 1.0.rand);
b.scope;
t.sampleRate
t.numFrames
(t.numFrames/2).floor.asInteger
c = Array.series(t.numFrames,1,1);
v = c[0..(t.numFrames/2).floor.asInteger];
n = Buffer.loadCollection(s,c);
c.size
x = v++v;
x.size;
#a,b =[3,4]
a
b = 4
b =+ 4