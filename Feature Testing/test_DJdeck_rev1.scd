~contentDir = "C:\\Users\\piert\\MakingMusic\\SuperCollider\\Content";
~b_horse_spurs = Buffer.read(s, ~contentDir +/+ "Sounds/authentic-spurs-70398.wav");
~b_horse_gallop = Buffer.read(s, ~contentDir +/+ "Sounds/6-horses-gallopwav-14467.wav")

(
SynthDef("DJdeck", { arg bus = 0, mute, trig, pos, bufnum;
    Out.ar( bus,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum),trig,pos)
		*
		mute
    )
}).add;
)


b = Synth("bufferPlayer",[\bufnum, ~b_horse_gallop.bufnum]);
b.set(\pos,100000);
b.set(\trig,1);
b.set(\trig,0);