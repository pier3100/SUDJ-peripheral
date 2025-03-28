// date of test 13/01/2024
// purpose: check wether if two buffers are run in the same synth with same parameter, remain in sync

(
SynthDef("DJdeck", { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 1, pos, jumpToPos, trackTempo, deckTempoBus, bendEventPositive, bendEventNegative|
	var rate, trig, output, position;
	var bendTrigPositive, bendTrigNegative, bend;
	var reference;
	// pitch bending
	bendTrigPositive = Changed.kr(bendEventPositive);
	bendTrigNegative = Changed.kr(bendEventNegative);
	bend = bendTrigPositive - bendTrigNegative;
	bend = Lag.kr(bend, 0.4);

	// actual soundfile reading
	rate =  BufRateScale.kr(bufnum) * In.kr(deckTempoBus) / trackTempo;
	rate = rate + bend;
	trig = Changed.kr(jumpToPos);
	output = PlayBuf.ar(2, bufnum, rate, trig, pos);
	reference = PlayBuf.ar(1, referenceBufnum, rate, trig, pos);
	Out.kr(referenceBus,reference);
	Out.kr(outputBus, output); // added for test
	output = output * mute;
	//Out.ar(outputBus, output); // disabled for test
}).add;
)

(
l = MusicLibrary.newFromTraktor("C:\\Users\\PierTabak\\Music\\collection.nml");
t = l.findTitle("Tuvan 1")[0];
t.path = "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3";//overwrite path for now, because at different PC
o = Bus.audio(s,2);
d = DJdeck.new(o,125);
d.loadTrack(t);
d.testReference; // to set things up for this test, see below for temporary functionality
)
// make sure to c
d.play;

(
d.testBeatsReference.postln;
d.beatsReference.postln;
d.clock.beats.postln;
d.beatsReference - d.clock.beats;
)

d.synth.set(\bendEventPositive,1.0.rand);

// shows that the two buffers keep in perfect sync
// clock and buffers become async, do not why, but dont care too much as its only in this test, EDIT: probably due to buffer numChannels not matching, EDIT, I changed some functions afterwards

// test functions
/*    testReference {
        testBuffer = Buffer.loadCollection(collection: frameTrackerArray[0..track.numFrames]);
        testBus = Bus.control;
        synth.set(\outputBus, testBus, \bufnum, testBuffer);
    }


    testBeatsReference {
        ^this.position2beat(testBus.getSynchronous);
    }*/