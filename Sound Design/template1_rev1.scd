(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.options.memSize_(8192*(2**2));
s.boot;
)

(
MyMIDI2.classInit;
~m_bcr2000 = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
)

(
~hoaOrder = 2;
~speakerDegrees = [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 4, 0, 4]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
~matrixDecoder = HoaMatrixDecoder.newModeMatch(~speakerDegrees.degrad, beamShape: 'basic', match: 'amp', order: ~hoaOrder);
~matrixEncoder = HoaMatrixEncoder.newDirections([-30, 30].degrad, order: ~hoaOrder);
~hoaChannels = ~matrixEncoder.numOutputs;
~bOutMain = Bus.audio(s,~hoaChannels);
)

\\template
SynthDef(\temp,{
	var input, wet, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	wet = input;
	output = XFade2.ar(input,wet,ServerControl.kr(\drywet).linlin(0,1,-1,1));
	ReplaceOut.ar(~bOutMain,output);
}).add;


(
SynthDef(\dust,{
	var output;
	output = Dust2.ar(ServerControl.kr(\density).linexp(0,1,0.01,6000)*Ones(~hoaChannels));
	Out.ar(~bOutMain,output);
}).add;

SynthDef(\dist,{
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = LPF.ar(input,ServerControl.kr(\freq).linexp(0,1,22000,44000));
	output = output.clip2(1);
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\filt,{
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = VadimFilter.ar(input,ServerControl.kr(\filtHP).linexp(0,1,500,20000),0,4);//HP
	output = VadimFilter.ar(output,ServerControl.kr(\filtLP,1).linexp(0,1,4000,20000),0);//LP
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\outputs, {
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = HoaDecodeMatrix.ar(input, ~matrixDecoder);
	output = MulAdd(output,~speakerDbsCorrection.dbamp);
	output = output * ServerControl.kr(\volume);
    output = output.clip2(1);
	output = LeakDC.ar(output);
    Out.ar(0, output);
}).add;
)

(
g = Group.new();
q = Synth.tail(g,\dust);
w = Synth.tail(g,\dist);
e = Synth.tail(g,\filt);
p = Synth.tail(g,\outputs);
)
q.trace

(
MyMIDI2.resetLibraries;
MidiCC(\normal,[~m_bcr2000,0,1],CCAbstractTarget(q,\density, \relative));
MidiCC(\normal,[~m_bcr2000,0,2],CCAbstractTarget(w,\freq, \relative));
//MidiCC(\normal,[~m_xone,0,3],CCAbstractTarget(w,\freq, \relative));
//MidiCC(\normal,[~m_xone,0,4],CCAbstractTarget(w,\damp, \relative));
//MidiCC(\normal,[~m_xone,0,5],CCAbstractTarget(e,\freq, \relative));
MidiCC(\normal,[~m_bcr2000,0,6],CCAbstractTarget(e,\filtHP, \relative));
MidiCC(\normal,[~m_bcr2000,0,7],CCAbstractTarget(e,\filtLP, \relative));
MidiCC(\normal,[~m_bcr2000,0,8],CCAbstractTarget(p,\volume, \relative));
)