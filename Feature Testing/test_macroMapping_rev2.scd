(
//busses
~b_dummy = Bus.control;
~b_macro_1 = Bus.control;

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

SynthDef("macro_1",{arg bus;
	Out.kr(bus,\val.kr(0));
}).add;
)

//synths
(
Synth.key(\mainSynth,"mainSynth");
Synth.key(\macro_4,"macro_1",[\bus, ~b_macro_1]); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary
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
MIDIdef.cc(\main1, {arg val, cc, chan, srcID;
	~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,val.linlin(0,127,0,1))}
	});
}); //

////this is normal mapping for knob to macro parameter
~a_macroMIDI = Array.new(400);
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is normal mapping of knob to parameter
	~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,val.linlin(0,127,0,1))}
	});
}); //

////write down macroBus nr
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is mapping for Macro
	if(~macroToggle.asBoolean){
		~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~synthDictionary[item[1].synthKey].get(\bus, {|val| ~macroBus = val});}
		});
	};
}); // match cc 1

////this is the mapping of the bus of the the synth, to the macro
MIDIdef.cc(\main1, {arg val, cc, chan, srcID;
	if(~macroToggle.asBoolean){
		~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~objectDictionary[item[1].synthKey].setBus(item[1].parameterKey,~macroBus)}
		});
	};
}); //
)

(
////mappings
~a.add([MS(~m_akai_mpk,0,7),SP(\mainSynth,\freq)]);
~a_macroMIDI.add([MS(~m_fire,0,16),SP(\macro_4,\val)]);
ButtonOnOffMIDISocket([~m_fire.indexIn, 0],{~macroToggle = 1},{~macroToggle = 0;
	~macroBus = ~b_dummy.index;
}, 48);// button which enable macroMapping mode, as indicated by macroToggle = 1
)

////midi reference functions
MIDIdef.cc(\main2, {arg ...args; args.postln});
MIDIdef.noteOn(\main3, {arg ...args; args.postln});
MIDIdef.noteOff(\main4, {arg ...args; args.postln});

//refernce entries
~synthDictionary;
~synthDictionary[\macro_4].get(\bus, {|val| val.postln});
~b_dummy.index;
~b_macro_1.index;
~macroToggle;
~macroBus;
~synthDictionary[\mainSynth].getn(\freq,2, {|val| val.postln});