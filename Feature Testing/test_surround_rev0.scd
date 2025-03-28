MIDIClient.init;
~m_akai_mpk = MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MPKmini2")};
~knob1 = 0.0;
~knob1;
BasicMIDIControl([~m_akai_mpk, \omni], 1, { arg val; ~knob1 = val.linlin(0,127,-1,1)});
BasicMIDIControl([~m_akai_mpk, \omni], 1, { arg val; u.set(\ang,val.linlin(0,127,-2*pi,2*pi))});

~sD = IdentityDictionary.new;
~b_out = Bus.audio(s,8);
~b_out.scope;
FreqScope(busNum: ~b_out);
Stethoscope.new;

(
SynthDef("out",{
	Out.ar(0,In.ar(~b_out,8))}).add;
)

(
SynthDef("pad",{arg pos;
	var out, outPanL,outPanR, env;
	env = Env([0, 1, 0],[0.3, 0.4]);
	out = SinOsc.ar([440, 880]) ;
	outPanL = PanAz.ar(6, out[0], pos:pos, level: 1.0, width: 2.0, orientation: 0.5);
	outPanR = PanAz.ar(6, out[1], pos:pos+(2/6), level: 1.0, width: 2.0, orientation: 0.5);
	Out.ar(~b_out,(outPanL+outPanR)*EnvGen.kr(env,doneAction: Done.freeSelf));
}).add;
)

(
SynthDef("pad2",{arg pos;
	var out, outPanL,outPanR, env;
	env = Env([0, 1, 0],[0.3, 0.4]);
	out = SinOsc.ar([440, 440*2, 440*3]) ;
	Out.ar(~b_out,out.sum*EnvGen.kr(env,doneAction: Done.freeSelf));
}).add;
)

Synth("out");
Synth("pad",[\pos, -1/6]).key(\pad);

\\ATK
Atk.downloadKernels;
Atk.downloadMatrices;
Atk.downloadSounds;
Atk.openUserSupportDir;
Platform.userExtensionDir;

~decoder = FoaDecoderMatrix.newPanto(numChans: 6, orientation: 'flat', k: 'dual');

~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Anderson-Pacific_Slope.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Howle-Calling_Tunes.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Pampin-On_Space.wav")

(
SynthDef("surr1",{
    var sig;                            // audio signal


    // display encoder and decoder
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // ------------------------------------------------------------
    // test sig
    sig = PlayBuf.ar(~sndbuf.numChannels, ~sndbuf, BufRateScale.kr(~sndbuf), doneAction:2);   // soundfile


    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    //~renderDecode.value(sig, ~decoder)
	Out.ar(0,FoaDecode.ar(sig, ~decoder));

}).add;
)

u = Synth("surr1");

// free buffer
~sndbuf.free
// ------------------



//HOA
~matrixEncoder = HoaMatrixEncoder.newDirections([-30, 30].degrad, order: 2);

~matrixDecoder = HoaMatrixDecoder.newPanto(numChans: 6, orientation: 'flat', beamShape: 'basic', match: 'amp', order: 2);
~matrixDecoder = HoaMatrixDecoder.newProjection([-30, 30, -90, 90, -150, 150].degrad, beamShape: 'basic', match: 'amp', order: 2);
~decoder.directions.raddeg;
(
SynthDef("surr2",{arg ang;
	var input, ambiPre, ambiAfter, output;

	input = In.ar(8,2);
	ambiPre = HoaEncodeMatrix.ar(input, ~matrixEncoder);
	ambiAfter = HoaRotate.ar(ambiPre, angle: ang, order: 2);
    output = HoaDecodeMatrix.ar(ambiAfter, ~matrixDecoder);
	Out.ar(0,output);
}).add;
)

u = Synth("surr2");
u.get(\ang,{arg val;val.postln}); 