(
SynthDef("DJdeck", { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 0, positionSetBus, jumpToPositionBus, trackTempo, deckTempoBus, bendEvent, bendIntensity, pauseBus|
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
	trig = Changed.kr(jumpToPosition);

	// position
	# blockPosition, blockReferencePosition = Integrator.kr([rateBended, rate],1-trig);
	position =  In.kr(positionSetBus) + (blockPosition * s.options.blockSize);
	referencePosition =  In.kr(positionSetBus) + (blockReferencePosition * s.options.blockSize);

	// actual soundfile reading
	output = BufRd.ar(2,bufnum, K2A.ar(position));
	output = output * Lag.kr(1 - mute, 0.01);
	Out.ar(outputBus, output);

	// for reference
	Out.kr(referenceBus,[position, referencePosition]);
}).add;
)

(
SynthDef(\test, { |bufnum, deckTempoBus, trackTempo, reset|
	var rate; //in frames (of buffer) per sample (of server)
	var position; //in frames
	var blockPosition; // in blocks
	var ref;
	var output;
	rate = BufRateScale.kr(bufnum) * (In.kr(deckTempoBus) / trackTempo);

	position = K2A.ar(blockPosition) * s.options.blockSize;
	output = BufRd.ar(2,bufnum,position);
	Out.ar(0,output);
}).add;
)

b = Buffer.read(s,"C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3");
b
t = MyTempoClock.new(2);
t.bus.getSynchronous
q = Synth(\test, [\bufnum, b, \deckTempoBus, t.bus, \trackTempo, 2]);
t.tempo_(1.6)
t.beats
t.tempo
t.beatOfTurning
t.resume
Stethoscope.new

q.trace
s.blockSize
s.options.blockSize
s.sampleRate
s.sampleRateKr