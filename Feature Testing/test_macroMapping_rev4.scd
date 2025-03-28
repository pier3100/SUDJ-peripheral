

//initializing MyMIDI
(
m = MyMIDI.new();


//busses
~b_macro_1 = Bus.control(s,2);
~b_macro_1.set(-1,1);

//dictionary
~sD = IdentityDictionary.new;

//synthDef
SynthDef("mainSynth",{
	var env, freq;
	freq = 400+(400*MyCon.kr(\freq,1));
	env = Env([0, 1, 0],[3, 2]);
	Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env));
	//Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;

SynthDef("macro_LFO",{arg bus;
	var output, amplitude;
	amplitude = \amplitude.kr(0);
	output = SinOsc.kr(\freq.kr(0.1), 0, amplitude/2, amplitude/2 );
	Out.kr(bus,[\crossfade.kr(-1),output]);
}).add;
)

//synths
(
Synth("mainSynth").key(\mainSynth);
Synth("macro_LFO",[\bus, ~b_macro_1]).key(\macro_4); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary
)

//midi
(


~m_akai_mpk = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint|endpoint.name.contains("MPKmini2")},-1);
~m_fire = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("FIRE")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("FIRE")});
)

MIDIdef.freeAll;
MIDIIn.connectAll;

(
////mappings
m.addNormal([MS(~m_akai_mpk,0,7),SP(\mainSynth,\freq),{|val| val.linlin(0,127,0,1)}]);
m.addMacro([MS(~m_akai_mpk,0,1),SP(\macro_4,\crossfade),{|val| val.linlin(0,127,-1,1)}]);
m.addMacro([MS(~m_akai_mpk,0,2),SP(\macro_4,\amplitude),{|val| val.linlin(0,127,0,1)}]);
m.addMacro([MS(~m_akai_mpk,0,3),SP(\macro_4,\freq),{|val| val.linlin(0,127,0.1,1)}]);
ButtonOnOffMIDISocket([~m_fire.indexIn, 0],{m.macroToggle_(1)},{m.macroToggle_(0);
	m.resetMacroBus;
}, 48);// button which enable macroMapping mode, as indicated by macroToggle = 1
)

////midi reference functions
MIDIdef.cc(\main2, {arg ...args; args.postln});
MIDIdef.noteOn(\main3, {arg ...args; args.postln});
MIDIdef.noteOff(\main4, {arg ...args; args.postln});
MIDIdef.all;
MIDIdef.freeAll;

//refernce entries
NodeProxy.browse;
~a = nil;
~a;
~a_macroMIDI = nil;
~a_macroMIDI;
~synthDictionary;
~sD[\macro_4].get(\crossfade, {|val| val.postln});
~synthDictionary[\macro_4].get(\amplitude, {|val| val.postln});
~synthDictionary[\macro_4].get(\freq, {|val| val.postln});
~b_dummy.index;
~b_macro_1.index;
~macroToggle;
m.macroBus;
m.macroToggle;
m.macroMappingDictionary;
~sD[\mainSynth].getn(\freq,2, {|val| val.postln});
~synthDictionary[\mainSynth].trace;
~synthDictionary[\macro_4].trace;
m.resetMacroBus;
