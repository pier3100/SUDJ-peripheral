// here I develop a different DJdeck synthdef, which implements the beatjumping in the synthdef, such that we can ensure always running x frames in advance in order to account for the delay imposed by the kernelEncoder
// further more I take account of the fact that the buffer is only single precision: idea

// synthdef itself
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
	jumpToPosition = In.kr(jumpToPositionBus);
	trig = T2A.ar(Changed.kr(jumpToPosition));

	// position
	//# blockPosition, blockReferencePosition = Integrator.kr([rateBended, rate],1-trig);
	//position =  In.kr(positionSetBus) + (blockPosition* s.options.blockSize);
	//referencePosition =  In.kr(positionSetBus) + (blockReferencePosition* s.options.blockSize);

	InRange.kr(in: position, lo: jumpAtFrame, hi: 10e9);

	position = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rateBended));
	referencePosition = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rate));

	// actual soundfile reading
	output = BufRd.ar(2, bufnum, position);
	output = output * Lag.kr(1 - mute, 0.01);
	Out.ar(outputBus, output);

	// for reference
	Out.kr(referenceBus,[position, referencePosition]);
})

(2**24)/44100
b = Buffer.read(s,"C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3",0,10000);
(
SynthDef(\test,{
	Out.ar(0,PlayBuf.ar(2,b,1,loop: 1));
}).add;
)
Stethoscope.new
b.read("C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3",35000,5000,5000);
b.plot
s.boot
s.latency = 0.03
s.bind { Synth(\test) }

t = TempoClock.new
y  =MyTempoClock.new
t.addDependant(y)
t.tempo_(2)
y.tempo
t.dependants.do({|item| item.tempo.postln})
t.release