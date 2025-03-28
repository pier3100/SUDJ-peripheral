(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Headphones (Px7 S2)");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)
b = Bus.audio(s,2);
(
SynthDef(\string,{ |freqs, sustain, pan,level|
	var output,env,envFM;
	envFM = Env.new([0.9, 1,0, 0.7, 0.3, 0], [0.1,sustain,20,10]);
	output = SinOsc.ar(freqs);
	output = SinOsc.ar(freqs+(EnvGen.kr(envFM)*sustain*output));
	output = Mix.ar(output);
	env = Env.new([0,1,0.7,0], [10,sustain,8]);
	output = output * EnvGen.kr(env,doneAction: Done.freeSelf);
	output = Pan2.ar(output,pan,level);
	Out.ar(b,output);
}).add;
)

(
SynthDef(\out,{|gain|
	var output;
	output = In.ar(b,2);
	output = FreeVerb.ar(output);
	output = MoogLadder.ar(output,420,0.1);
	output = output * gain;
	Out.ar(0,output);
}).add;
)

o = Synth(\out);
o.set(\gain,7);

(
var pan;
var mainFreq = ([400,600,900][[0.5,0.3,0.3].windex])*(2**(3.rand));
var nStrings = 4.rand;
var detune = 0.01.rand;
var freqs;
var sustain = 20.0.rand;
var levels = 1.0.rand;
pan = 2.0.rand-1;
freqs = mainFreq * Array.series(nStrings,1+detune,detune);
Synth(\string,[\freqs,freqs,\sustain,sustain,\pan,pan, \level, levels]);
)

s.volume = 1;
Array.series(3,1+0.2,0.2)
[400,600,900][[0.5,0.3,0.3].windex]

b.scope