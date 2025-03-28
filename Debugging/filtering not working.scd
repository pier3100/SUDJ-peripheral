~musicLibrary.tracks.selectIndices({|item, i| item.bpm.isNumber.not})
~musicLibrary.tracks[3341].bpm
Scale.minor.name


// developing knobs resetting
t= ServerTarget(~sChannel3, \pan);
t.parameterValue;
t.parameterValue_(0.3).parameterValue;
MidiHidSystem.instanceList.do({ |item|  item.targetOut !? { item.feedback } });
m = MidiCC([98, 0, ~mBcr], ServerTarget(~sChannel2, \gain), mode: \absolute);
m.resetInitial
t=m.target
t.parameterValue
t.initialValue
t.parameterValue_(t.initialValue)
t.resetInitialValue
(false).if{ "hoi".postln }
3.class.superclasses.includes(SimpleNumber)
SimpleNumber.allSubclasses
MidiHidSystem.findByTarget(~sChannel1,\gain)

(
var item, key_, object_;
key_ = \gain;
object_ = ~sChannel2;
item = MidiCC([98, 0, ~mBcr], ServerTarget(~sChannel2, \gain), mode: \absolute);
item.target.class.superclasses.includes(AbstractTarget).if{ ((item.target.object==object_)&&(item.target.key==key_)) };
)
MidiHidSystem.instanceList.detect({|item| item.target.class.superclasses.includes(AbstractTarget).if{ ((item.target.object==~sChannel2)&&(item.target.key==\gain)) }{ false }}).resetInitial
MidiHidSystem.findByTarget(~sChannel1,\gain)

MidiHidSystem.findByTarget(~sChannel1, \gain).resetInitial

//
~libraryConsole.activeTrackArrayFiltered[0].loadBuffer
~libraryConsole.activeTrackArrayFiltered.size>=2
~libraryConsole.bufferArray[2]
~deck1.clock.paused
{ Blip.ar(Latch.ar(WhiteNoise.ar, Impulse.ar(9)) * 400 + 500, 4, 0.2) }.play;

(
{
    var sig = LFNoise1.kr(2); // Random values
    sig.plot(5); // Plot over 5 seconds
}.fork;
)
(
var sig = LFNoise1.kr(2); // Generate control-rate noise
sig.plot(5); // Plot over 5 seconds
)

(
var buf = Buffer.alloc(s, 500, 1); // 500 samples buffer

// Create a Synth that records LFNoise1.kr into the buffer
{
    var sig = LFNoise1.kr(2);
    BufWr.kr(sig, buf, Phasor.kr(0, 1, 0, 500)); // Write to buffer
}.play;

s.sync; // Wait for the buffer to fill
buf.plot; // Plot the buffer contents
)

(
q = {
	In.ar(bus:64);
}.play;
)
q.trace
"C:\Users\piert\MakingMusic\SuperCollider\Data Analysis\data.csv".standardizePath
w = File("C:/Users/piert/MakingMusic/SuperCollider/Data Analysis/data.csv","w")
w.write("hoi");
w.close
"%.6f".format(10183012938)
Date.localtime.stamp
Date.localtime.asSortableString
h = [1,2,3,4];
h[0..2]
s.options.numOutputBusChannels
Array.series((s.options.numOutputBusChannels-2).clip(2,6)).size;
