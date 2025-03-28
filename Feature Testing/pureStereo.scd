Stethoscope.new;

(
//~matrixDecoderMain = FoaDecoderMatrix.newDiametric([-pi/2], k: 'single'); <- does not work because singular
~matrixDecoderMain = FoaDecoderMatrix.newDiametric([-30, 30, -90].degrad, k: 'single');
~matrixDecoderHeads = FoaDecoderMatrix.newStereo;
~kernelEncoderSuperStereo = FoaEncoderKernel.newSuper(8192);
~matrixEncoderStereo = FoaEncoderMatrix.newStereo;
)

(
SynthDef(\test,{
	var in, foa, out, diff;
	in = SinOsc.ar([440, 430], 0, 0.2);
	foa = FoaEncode.ar(in, ~matrixEncoderStereo); // make surround
	//foa = FoaEncode.ar(in, ~kernelEncoderSuperStereo);
	out = FoaDecode.ar(foa,~matrixDecoderHeads);
	diff = in - out;
	diff.poll(Impulse.ar(20));
}).add;
)
q = Synth.new(\test);
q.trace;

Library.at(\audioConfiguration) == "pureStereo"
