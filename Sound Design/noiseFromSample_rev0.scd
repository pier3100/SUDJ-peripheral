s.boot;
s.quit;
b = Buffer.read(s, "C:/Users/piert/AppData/Local/Bitwig Studio/installed-packages/5.0/Bitwig/Classic Drum Machines/ASM/Clap ASM 01 A.wav");

(
SynthDef("noise1",{arg spread, pos,cutoffFreq,rate,gain;
	var jumpNoise, jumpNoiseFiltered, posNoise, posNoiseFiltered, output;
	jumpNoise = WhiteNoise.ar(spread);
	posNoise = WhiteNoise.ar(spread);
	jumpNoiseFiltered = BLowPass.ar(jumpNoise,cutoffFreq);
	posNoiseFiltered = BLowPass.ar(posNoise,cutoffFreq);
	output = PlayBuf.ar(2,b,rate,jumpNoiseFiltered,pos+posNoiseFiltered);
	Out.ar(0,output*gain);
}
).add;
)

(
SynthDef("noise2",{arg spread, pos,cutoffFreq,rate;
	var jumpNoise, jumpNoiseFiltered, posNoise, posNoiseFiltered, output;
	jumpNoise = WhiteNoise.ar(spread);
	posNoise = WhiteNoise.ar(spread);
	jumpNoiseFiltered = BLowPass.ar(jumpNoise,cutoffFreq);
	posNoiseFiltered = BLowPass.ar(posNoise,cutoffFreq);
	output = PlayBuf.ar(2,b,rate,jumpNoise,pos+posNoise);
	Out.ar(0,jumpNoise);
}
).add;
)

n = Synth("noise1",[\spread, 1000, \pos, 9000,\cutoffFreq, 10000, \rate, 0.9, \gain,0.5]);
n.free;