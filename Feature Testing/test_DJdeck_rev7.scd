s.boot;
Server.killAll;

(
SynthDef("DJdeck", { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 1, positionSetBus, jumpToPositionBus, trackTempo, deckTempoBus, bendEvent, bendIntensity|
	var rate, rateBended, trig, output, position, jumpToPosition;
	var bend;
	var playAlong, reference;
	// pitch bending
	bend = Changed.kr(bendEvent);
	bend = bend * bendIntensity;
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
q = Key.new(Scale.major,1);
w = l.playlists[12].asArray.filterBPM(120,140,4).filterKey(q,120,1);
100.mod(2)
w.rand.title;
[1,2]++[4,8]
100.mod(55)
w.size
Array.browse
w.randomTrack.size
w.rand
p = l.tracks
p.at([5,100]).class
p.class
[1, 500, 3, 400].at([1,3])
l.tracks.class
q.modulate()
w = Key.new(Scale.major,3);
q.compability(w);
)
3.0.neg
3.003.isInteger
t = nil;
g = t ?? 5;
5.0000001.modSolve(5,12)
5.3.moddif(19,12)
a = Scale.major
a.degrees
5.3.mod(1)
a.semitones
a.tuning
Scale.major.semitones
Scale.minor.degreeToRatio(0)

q = Array.new(100).class
2**(1/12)

(0.5.log/2.log)*12
a = Array.rand(100,1,10)
a.next
1.1.asBoolean
0.4.asBoolean
-0.1.asBoolean
true.asInteger
false.asInteger
v = false;
v.value
v.value_(true)
100.7.frac
Library.put(\musicLibrary,l);

Library.at(\musicLibrary)
thisThread.seconds
(
l = MusicLibrary.newFromTraktor("C:\\Users\\PierTabak\\Music\\collection.nml");
t = l.findTitle("Tuvan 1")[0];
t.path = "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3";//overwrite path for now, because at different PC
o = Bus.audio(s,2);
d = DJdeck.new(o,125);
(
d.loadTrack(t);
d.loadAndPlayTrack(t);
d.play;
)
l.playlists.size
l.playlists[10].randomTrack.title
158.rand
2.rand
"C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3"

q = "C:/:Users/:piert/:Music/:ZSpotify Music/:Maybe Set1/:Nikki Nair - step 2 - step 2.mp3"
q.replace("/:","\\")
w = SoundFile.new("C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3");
w.path.class
d.trackBufferReady
d.referenceBufferReady
d.play;

d.userInducedGridOffset;
d.pitchbend(-0.1);
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
b = 4L
b =+ 4
a = [1,2,4356,6,7,3,6];
b = a.selectIndices({|item,i| item < 0});
a[b]
b[0]
a = "hoijoeiwop"
a.findInBetween("hoi","op",5).string;
nil +nil