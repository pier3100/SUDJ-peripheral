
f = SoundFile.new;
f.openRead(p);
f.inspect;
f.close;

Server.killAll;
(//server
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)
~contentDir = "C:\\Users\\piert\\MakingMusic\\SuperCollider\\Content";
~b_horse_spurs = Buffer.read(s, ~contentDir +/+ "Sounds/authentic-spurs-70398.wav");
~b_horse_gallop = Buffer.read(s, ~contentDir +/+ "Sounds/6-horses-gallopwav-14467.wav")

(
SynthDef("bufferPlayer", { arg bus = 0, bufnum;
    Out.ar( bus,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)) //BufRateScale is needed to make sure with different samples rates, the audio is played back at the same rate
    )
}).add;
)


//
t = TempoClock;
t.bar;
t.beats;
b = ~b_horse_gallop;
b.numFrames/b.sampleRate;
Synth("bufferPlayer",[\bufnum, ~b_horse_gallop.bufnum]);

(
~playWithEndSync = {arg buffer, clock; var bufferLength, barLength, bufferLengthInBars, bufferLengthInBarsDecimalPart, nextBar, playTime;
	bufferLength = b.numFrames/b.sampleRate/clock.beatDur;  //[beats]
	barLength = clock.beatsPerBar;  //[beats]
	bufferLengthInBars = bufferLength / barLength;
	bufferLengthInBarsDecimalPart = bufferLengthInBars%(1); //in fraction of bar length
	nextBar = (clock.nextBar-clock.beats)/clock.beatInBar; //in fraction of bar length
	clock.nextBar.postln;
	clock.beats.postln;
	nextBar.postln;
	bufferLengthInBarsDecimalPart.postln;
	playTime = if(bufferLengthInBarsDecimalPart<nextBar,{
		clock.nextBar - (bufferLengthInBarsDecimalPart*clock.beatsPerBar);
	},{
		clock.nextBar + ((1 - bufferLengthInBarsDecimalPart)*clock.beatsPerBar);
	});
	playTime.postln;
	clock.beats.postln;
	clock.schedAbs(playTime,{Synth("bufferPlayer",[\bufnum, buffer.bufnum])});
}
)
~playWithEndSync.value(~b_horse_gallop,t);
t.bar;
t.tempo_(0.5);
t.nextBar;
3.5.mod(1);
3.5%(1);