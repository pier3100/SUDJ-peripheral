s.boot;
s.quit;

(
SynthDef("ping",
	{arg freq, length;
		var audio;
		var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.47]*length);
		audio = SinOsc.ar(freq)*EnvGen.ar(env, doneAction: Done.freeSelf);
		Out.ar(0,audio);
	}
).add;
)
~synthy = Synth.new("ping",["freq", 450, "length", 1]);



x = Pseq([Pdef(\patternA)],inf);
x.play;
x.stop;

(
p = Pdef(\patternA,
	Pbind(
		\instrument,\ping,
		\freq, Pseq([440, 460, 440, 500],1),
		\length, Pseq([1, 1, 1, 1],1)
	)
)
)

(
p = Pdef(\patternA,
	Pbind(
		\instrument,\ping,
		\freq, Pseq([440, 460, 740, 500],1),
		\length, Pseq([1, 1, 1, 1],1)
	)
)
)

p.play;
p.stop;




stage
0      loop in buffer which has been created by randomness, but is now static
1      random mutation at each iteration of the buffer, is only written as a mutation of the original buffer if one presses next, mutation propabality density influenced by 2 parameters, and mutation severity (volume, effect, pitch) by 3 other parameters; you hear some thing you like better, than you press the next button on presseing next (storage_buffer = mutated buffer);to make sure you do not forget your reference, every fourth loop is the non mutated storage_buffer; assign the parameter to yes/no to a key on the keyboard; if key is pressed at beginning of loop; then press next automatic; furthermore if key is pressed increasy intensity of a noise effect with slope propertional to velocity; or only press next if sound is still heard at start of new loop

trigger discrete transitions (with quantisation) when knob first derivative if high