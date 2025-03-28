(
//busses
~b_dummy = Bus.control(s,2);
~b_dummy.set(-1,1); //the first value of this bus is the crossfade, which should definitely be -1, i.e. take the dry signal
~b_macro_1 = Bus.control(s,2);
~b_macro_1.set(-1,1);

//setting the macroBus handover values
~macroBus = 0;
~macroToggle = 0;

//dictionary
~synthDictionary = IdentityDictionary.new;

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
Synth.key(\mainSynth,"mainSynth");
Synth.key(\macro_4,"macro_LFO",[\bus, ~b_macro_1]); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary
)

//midi
(
MIDIClient.init;

~m_akai_mpk = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint|endpoint.name.contains("MPKmini2")},-1);
~m_fire = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("FIRE")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("FIRE")});

MIDIdef.freeAll;
MIDIIn.connectAll;
)

(
////this is normal mapping of knob to parameter
~a = Array.new(400);
~a_macroMIDI = Array.new(400);

MIDIdef.cc(\normalCC, {arg val, cc, chan, srcID;
	~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,item[2].value(val))}
	});
	~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,item[2].value(val))}
	});
}); //

////write down macroBus nr
MIDIdef.cc(\macroMappingSource, {arg val, cc, chan, srcID; //this is mapping for Macro
	if(~macroToggle.asBoolean){
		~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~synthDictionary[item[1].synthKey].get(\bus, {|val| ~macroBus = val});}
		});
	};
}); // match cc 1

////this is the mapping of the bus of the the synth, to the macro, in order to delete a mapping one just presses the map button and then turns the knob one whishes to un map; this sets the bus to the dummy bus, which has crossfade = -1
MIDIdef.cc(\macroMappingDestination, {arg val, cc, chan, srcID;
	if(~macroToggle.asBoolean){
		~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~synthDictionary[item[1].synthKey].setBus(item[1].parameterKey,~macroBus)}
		});
	};
}); //
)

(
////mappings
~a.add([MS(~m_akai_mpk,0,7),SP(\mainSynth,\freq),{|val| val.linlin(0,127,0,1)}]);
~a_macroMIDI.add([MS(~m_akai_mpk,0,1),SP(\macro_4,\crossfade),{|val| val.linlin(0,127,-1,1)}]);
~a_macroMIDI.add([MS(~m_akai_mpk,0,2),SP(\macro_4,\amplitude),{|val| val.linlin(0,127,0,1)}]);
~a_macroMIDI.add([MS(~m_akai_mpk,0,3),SP(\macro_4,\freq),{|val| val.linlin(0,127,0.1,1)}]);
ButtonOnOffMIDISocket([~m_fire.indexIn, 0],{~macroToggle = 1},{~macroToggle = 0;
	~macroBus = ~b_dummy.index;
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
~synthDictionary[\macro_4].get(\crossfade, {|val| val.postln});
~synthDictionary[\macro_4].get(\amplitude, {|val| val.postln});
~synthDictionary[\macro_4].get(\freq, {|val| val.postln});
~b_dummy.index;
~b_macro_1.index;
~macroToggle;
~macroBus;
~synthDictionary[\mainSynth].getn(\freq,2, {|val| val.postln});
~synthDictionary[\mainSynth].trace;
~synthDictionary[\macro_4].trace;

