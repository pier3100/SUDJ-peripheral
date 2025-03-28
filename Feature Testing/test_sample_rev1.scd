t = TempoClock.new;
t.argNames
t.tempo_(2)
s.volume.volume_(0)
w = Sampler.new(4,16,t);
w.asCompileString
w.loadAllPatternsAndMultiSamples("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\Collection")
w.patternDictionary.at(\CowbellSimple)
w.patterns
p = "C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\Collection\\CowbellSimple.mid".asPathName.fullPath;
w.patternAllreadyAdded.includesEqual(p)
w.patternAllreadyAdded[0]==p
w.patternAllreadyAdded[0].class
p.class

l = List.new(3);
l.add(3);
l.add(6)
l.includes(6)
l.add(p)
l
l.includes(p)
w = nil
w.multiSamplePaths
r = "C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav".asPathName;
r.pathOnly++r.fileNameWithoutExtension++".mid"
(
var bufferArray;
bufferArray = BufferArray.new(4);
f ={ |i| SinglePatternDefinition.new(16, Pbind(\instrument, \samplePlayer, \bus, 0, \buffer, bufferArray.bufferArray[i])) }
)

(
var bufferArray;
bufferArray = BufferArray.new(4);
a = Array.fill(4, { |i| SinglePatternDefinition.new(16, Pbind(\instrument, \samplePlayer, \bus, 0, \buffer, bufferArray.bufferArray[i]))})
)
f.value(1)
w.selectedPatternIndex
w.nextPattern(false)

w.isActive
w.play
w.pause
w.loadLoop("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav")
"C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav".exists
u = nil;
u !? {5.postln};
"C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\Collection".asPathName.filesDo({ |path| path.extension.postln });
"C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\Collection".asPathName.fullPath

k = "C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav".asPathName.fileNameWithoutExtension.asSymbol
w.patternDictionary.at(k)

e = EventPatternProxy.default
e= EventPatternProxy.new
e.source_(p);
e.source
p = Pbind(\x, [1,2,3])

i = Pbind(p,o)
a = p.asStream
a.play
a.n
Stethoscope.new
s.plotTree
(
SynthDef(\samplePlayer, { |bus, buffer, velocity, rate, envelop|
// we need to make some design choices, do we include a panner here (a panner per sample); or de want a panner per slot, or do we only need a panner for the entire sampler
	var env, output;
	env = Env.new;
    output = PlayBuf.ar(1, buffer, rate) * velocity;
    output = output * EnvGen.ar(env);
    Out.ar(bus, output);
}).add; // write it to standard location, server will load it on boat
)

o = Pbind(\nharms, Pseq([4, 10, 40], inf))
# o.patternpairs
(
Pbind(

    \dur,                Pseq([1, 1, 2, 1]/10, inf),
	\instrument,        \default,
	*o.patternpairs
).play;
)

false.asInteger

v = [1,2,-0.5];
h = v.abs;
h[h.maxIndex]