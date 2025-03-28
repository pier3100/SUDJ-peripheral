(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.boot;
)

(
MyMIDI2.classInit;
~m_xone = MidiInOutPair("XONE","XONE");
)

(
SynthDef(\exp1,{
	var output, env;
	env = Env.new(times: [100,20]);
	output = SinOsc.ar(440*(1+ServerControl.kr(\freq,0)));
	output = output * EnvGen.kr(env, doneAction: Done.freeSelf);
	Out.ar(0,output);
}).add;
)

q = Synth(\exp1);
q.free;

MidiCC(\normal,[~m_xone,0,1],CCAbstractTarget(q,\freq, \relative));
MyMIDI2.normalCCMappingDictionary[0].[1].parameterBus.getSynchronous
