t = TempoClock.new
f = {"hoi".postln};
j = {"doei".postln};
d = DynamicTask.new(f);
d.schedAbs(t,100)
t.beats
d.schedAbs(t,80)

SystemClock.seconds
SystemClock.schedAbs(SystemClock.seconds+10,d)
	SystemClock.sched(5,d)
j.cancel
SystemClock.time
a = AppClock;
a
d.target.awake
d.cancel
d.sched(2,SystemClock)
AppClock.seconds
d.
a.sched(2,f)
5.2>0

List.new(8).size
List.newClear(8).size

Test.new("hoi")
Test.new("doei")
Test.list.[1].text
MidiInOutPair("hoi")
m = MidiSource(MidiInOutPair("hoi"),3,4);
l = MidiCC(m,{"hoi"}, mode: \absolute)
l.writeArchive("C:\\Users\\PierTabak\\Music\\Music\\parameterPreset.txt")
MidiHidSystem.initializedMidiHid
p = Object.readTextArchive("C:\\Users\\PierTabak\\Music\\Music\\parameterPreset.txt")
MidiHidSystem.instanceList
l.midiSource.midiDevice.midiOut==p.midiSource.midiDevice.midiOut
l.midiSource.midiDevice.hash
p.midiSource.midiDevice.hash
a = "worth trying"; b = "worth trying";
a.hash;
b.hash;

(l.midiSource.midiDevice).compareObject(p.midiSource.midiDevice,#[\midiOut, \indexIn, \indexOut])
b = Bus.control
b == l
b.asCompileString

(
SynthDef(\DJdeck, { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 0, positionSetBus, jumpToPositionBus, trackTempo, deckTempoBus, bendEvent, bendIntensity, pauseBus|
	var rate, rateBended, trig, output, position, blockPosition, referencePosition, blockReferencePosition, jumpToPosition;
	var bend;

	// pitch bending
	bend = Changed.kr(bendEvent);
	bend = bend * bendIntensity;
	bend = Lag.kr(bend, 0.4);

	// rate
	rate =  BufRateScale.kr(bufnum) * (In.kr(deckTempoBus) / trackTempo) * (1 - In.kr(pauseBus)); // if it is paused the rate will be zero; paused is to be used only for when the beat is negative, meaning we are before the track, so we need to wait with playing the track untill we arrive at the start of the track
	rateBended = rate + bend;

	// jumping
	jumpToPosition = K2A.ar(In.kr(jumpToPositionBus));
	trig = Changed.ar(jumpToPosition);

	// position
	//# blockPosition, blockReferencePosition = Integrator.kr([rateBended, rate],1-trig);
	//position =  In.kr(positionSetBus) + (blockPosition* s.options.blockSize);
	//referencePosition =  In.kr(positionSetBus) + (blockReferencePosition* s.options.blockSize);

	position = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rateBended));
	referencePosition = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rate));

	// actual soundfile reading
	output = BufRd.ar(2, bufnum, position);
	output = output * Lag.kr(1 - mute, 0.01);
	Out.ar(outputBus, output);

	// for reference
	Out.kr(referenceBus,[position, referencePosition]);
}).add;
)

y = Synth.new(\DJdeck, [\bufnum, 3]);
y.asCompileString
y.instVarSize
y.hash
g = Group.new
u = Synth.head(g,\DJdeck);
u.inspect

MIDIClient.subClass
MIDIClient.destinations[1].device.class

a = [1,3,5]
a.find(3)
a.select({|item| item ==4}).[0]
-1.asBool
-1.asBoolean
1.34.asFraction(100)
1.3.frac
1.roundFractional(1)
(1/4+0.001).roundFractional(32)
0.34375*32

a = [1,2,3];
a.[1] =4
a
p = Pseq(a, inf)
e = p.play
b = p.asStream
b.perform
midiNote
midicps

1024/4
(
var myPath;
myPath = PathName.new("./");
myPath.filesDo{|afile| afile.postln};
)
p = PathName("C:\\Users\\PierTabak\\Music\\Music\\ar.txt")
PathName(p)
"C:\\Users\\PierTabak\\Music\\Music\\ar.txt".asPathName
p.asPathName