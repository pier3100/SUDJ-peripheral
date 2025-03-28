m = SimpleMIDIFile.read("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.mid")

m.argNames
a= m.asMultiPatternArray
a[0].velocity

b = BufferArray.new(4)
b.loadSliced("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav", 4);
e = b.bufferArray[3]
e.updateInfo
e
e.plot

b.class
q = SoundFile.use("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav", {|sf| f = sf.numFrames})
q.inspect

b.bufferArray[1]
.updateInfo

c = Buffer.read(s,"C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav")
c
c.numFrames_(100)
c.plot
e = Buffer.alloc(s,100)
e.cache
e.allocReadChannel("C:\\Users\\piert\\MakingMusic\\Bitwig Studio\\Projects\\DrumLoops\\CowbellSimple\\CowbellSimple.wav", 1000, 2000, [1])
e.updateInfo
e.query
e
m.timeMode
m.timeMode_(\ticks)
m.division
m.midiEvents
m.tracks
p=m.p
m.midiTrackEvents(0).isEmpty
m.format
m.format_(3)
m.metaEvents
e.get(2000,_.postln)
e.plot
(
var frame;
frame = e.numFrames-1;
w = { |val| if(val.abs < (10**(-4))){ frame = frame - 1000; frame.postln; e.get(frame, w) }{o = frame} };
e.get(frame, w);
" hoi".postln;
frame.postln;
)

frame
o
Server.default.sampleRate * 0.02