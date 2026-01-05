//init
(
Library.addFromYAML("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-data\\config.YAML");
c = TrackClock.new(2);
~speakerDegrees = [-30, 30, -90]; // [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 0, 0, 0]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
if(Library.at(\audioConfiguration) == "surroundByKernel"){
    ~matrixDecoderMain = FoaDecoderMatrix.newDiametric(~speakerDegrees.degrad, k: 'single');
};
if(Library.at(\audioConfiguration) == "pureStereo"){
    ~matrixDecoderMain = FoaDecoderMatrix.newStereo;
};
~matrixDecoderHeads = FoaDecoderMatrix.newStereo;
~kernelEncoderSuperStereo = FoaEncoderKernel.newSuper(8192);
~matrixEncoderStereo = FoaEncoderMatrix.newStereo;
~numberChannels = ~kernelEncoderSuperStereo.numOutputs;
)

//midi
(
~mBcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
)

//bus
(
~bMicrophone = Bus.audio(s, ~numberChannels);
~bEffectKnobsR = Bus.control(s, 4);
~bDeck1 = Bus.audio(s,~numberChannels);
~bDeck2 = Bus.audio(s,~numberChannels);
~bDeck3 = Bus.audio(s,~numberChannels);
~bDeck4 = Bus.audio(s,~numberChannels);
~bDrumMachine = Bus.audio(s,~numberChannels);
~bThrustMaster = Bus.audio(s,~numberChannels);
~bPreview = Bus.audio(s,~numberChannels);
~bSend1 = Bus.audio(s,~numberChannels);
~bSend2 = Bus.audio(s,~numberChannels);
~bSend3 = Bus.audio(s,~numberChannels);
~bSend3Side = Bus.audio(s,~numberChannels);
~bCrossL = Bus.audio(s,~numberChannels);
~bCrossR = Bus.audio(s,~numberChannels);
~bCrossBypass = Bus.audio(s,~numberChannels);
~bOutMain = Bus.audio(s,~numberChannels);
~bQue = Bus.audio(s,~numberChannels);
~bOutHeads = Bus.audio(s,~numberChannels);
~bScopeKr = Bus.control(s,1);
~bScopeAr= Bus.audio(s,1);
)

// synthdef
(
SynthDef.new(\microphone, { |bus|
	var in;
	in = In.ar(4, 1);
	Out.ar(bus, in);
}).add;

SynthDef.new(\monoToFoa, { |bus|
	var foa;
	foa = FoaEncode.ar(In.ar(bus, 1), FoaEncoderMatrix.newDirection); // make surround
    ReplaceOut.ar(bus, [foa[0], foa[1], foa[2]]); //output, and ignore fourth empty channel
}).add;

SynthDef(\effectKnobsR,{
	var knob1, knob2, knob3, knob4;
	knob1 = ServerControlLag.kr(\knob1, 0.5);
	knob2 = ServerControlLag.kr(\knob2, 0.5);
	knob3 = ServerControlLag.kr(\knob3, 0.5);
	knob4 = ServerControlLag.kr(\knob4, 0.5);
	Out.kr(~bEffectKnobsR,[knob1, knob2, knob3, knob4]);
}).add;

SynthDef.new(\delay, { |bus, effectKnobsBus, tempoBus|
	var in, effectKnobs, tempo, delayTimeArray, delayTimeIndex, delayTime, decayTime, out;
	in = In.ar(bus, ~numberChannels);
	effectKnobs = In.kr(effectKnobsBus, 4);
	tempo = In.kr(tempoBus);
	delayTimeArray = [0.125, 0.25, 0.5, 1, 2, 4];
	delayTimeIndex = effectKnobs[0].linlin(0,1,0,5.99).floor.asInteger;
	delayTime = Select.kr(delayTimeIndex, delayTimeArray);// in beats
	decayTime = effectKnobs[1].linlin(0,1,0,16); // in beats
	out = CombC.ar(in, 8, delayTime/tempo, decayTime/tempo);
    ReplaceOut.ar(bus, out);
}).add;

SynthDef(\inputs, {
}).add;

~outputChannelSelection = Array.series((s.options.numOutputBusChannels-2).clip(2,6));
SynthDef(\outputsSurround, {
	var inputMain, inputQue, outputMain, outputHeadsMain, outputHeadsQue, outputHeads, splitQue;
	inputMain = In.ar(~bOutMain,~numberChannels);
	outputMain =  FoaDecode.ar(inputMain, ~matrixDecoderMain);
	outputMain = MulAdd(outputMain,~speakerDbsCorrection.dbamp); // correct for speaker locations
	outputMain = ((outputMain * ServerControlLag.kr(\masterVolume, Library.at(\masterVolume)).dbamp)*(-10).dbamp).clip2(1); //(-10).dbamp) to make sure we have some headroom in order to gain uncompressed tracks a bit more
    Out.ar(0, outputMain[~outputChannelSelection]); // we only output as many channels as we have speakers
    inputQue = In.ar(~bQue,~bQue.numChannels);
    outputHeadsMain = FoaDecode.ar(inputMain, ~matrixDecoderHeads);
    outputHeadsQue = FoaDecode.ar(inputQue, ~matrixDecoderHeads);
    outputHeadsQue = outputHeadsQue * ServerControlLag.kr(\gainPrelisten, 0.5).linlin(0, 1, -25, 25).dbamp; // -6 to +6 gain
    splitQue = ServerControlLag.kr(\splitQue, 0);
    //splitQue = (ServerControlLag.kr(\splitQue, 0).asin*2/pi).asin*2/pi; // we correct for the fact that the output from xone for this knob is not symmetric EDIT, this trick does not work, because we have too poor resolution on the right side of the knob
    outputHeads = [XFade2.ar(outputHeadsMain[0], outputHeadsQue[0], splitQue.linlin(0.5,1,-1,1)), XFade2.ar(outputHeadsMain[1], outputHeadsQue[1], splitQue.linlin(0,0.5,-1,1))];
    outputHeads = BhobLoShelf.ar(outputHeads, 200, 10);
    outputHeads = ((outputHeads * ServerControlLag.kr(\headPhoneGainDb, Library.at(\headPhoneGainDb)).dbamp)*(-5).dbamp).clip2(1);
    Out.ar(~outputChannelSelection.size, outputHeads); // for example: if you have 6 channels, we assume last two are for headphone, first four are for speakers; so nSpeakers = 4; then busses 0,1,2,3 are for the speakers, and 4,5 are headphones, so headphone should start at 4 = nSpeakers
}).add;

//channelmixer
SynthDef(\channelMixer, { |inputBus, que = 0, crossfaderSelectorL = 0, crossfaderSelectorR = 0|
    var input, output, freqLow, freqHigh, lowGain, midGain, highGain, vst1, vst2, outputPostFader;
    input = In.ar(inputBus, ~numberChannels);
    output = input * ServerControlLag.kr(\gain, 0.5).linlin(0, 1, -25, 25).dbamp; // -6 to +6 gain
	output = FoaPushX.ar(output, ServerControlLag.kr(\push, 0.5).linlin(0,1,-pi/2,pi/2));
    output = FoaRotate.ar(output, angle: ServerControlLag.kr(\pan, 0.5).linlin(0,1,-pi,pi)); // surround panner

    // EQ
    freqLow = ServerControlLag.kr(\freqLow, Library.at(\EqFreqLow));
    freqHigh = ServerControlLag.kr(\freqHigh, Library.at(\EqFreqHigh));
    lowGain = ServerControlLag.kr(\lowGain, 0.5);
    midGain = ServerControlLag.kr(\midGain, 0.5);
    highGain = ServerControlLag.kr(\highGain, 0.5);
    vst1 = VSTPlugin.ar([output[0], output[1]], 2, params: [2, freqLow, 3, freqHigh, 4, lowGain, 5, midGain, 6, highGain], id: \eq3vst1);
    vst2 = VSTPlugin.ar(output[2], 1, params: [2, freqLow, 3, freqHigh, 4, lowGain, 5, midGain, 6, highGain], id: \eq3vst2);
    output = [vst1[0], vst1[1], vst2];
    output = DjFilter.ar(output, ServerControlLag.kr(\filter, 0.5));
    // Sends
    Out.ar(~bSend1,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send1Volume)));
    Out.ar(~bSend2,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send2Volume)));
    Out.ar(~bSend3,     output * VolumeFaderCurve.kr(ServerControlLag.kr(\send3Volume)));
    Out.ar(~bSend3Side, output * VolumeFaderCurve.kr(ServerControlLag.kr(\send3SideVolume)));
    outputPostFader = output * VolumeFaderCurve.kr(ServerControlLag.kr(\faderVolume));
    Out.ar(~bCrossL, outputPostFader * crossfaderSelectorL);
    Out.ar(~bCrossR, outputPostFader * crossfaderSelectorR);
    Out.ar(~bCrossBypass, outputPostFader * (1 - crossfaderSelectorL) * (1 - crossfaderSelectorR));
    Out.ar(~bQue, output * que);
}).add;

//mainmixer
SynthDef(\mainMixer, {
    var output;
    output = XFade2.ar(In.ar(~bCrossL, ~numberChannels), In.ar(~bCrossR, ~numberChannels), ServerControlLag.kr(\crossFader).linlin(0,1,-1,1)); // add crossfader outputs; outputs who bypass the crossfader have added allready
    output = output + In.ar(~bCrossBypass, ~numberChannels);
    output = output + In.ar(~bSend1, ~numberChannels) + In.ar(~bSend2, ~numberChannels) + In.ar(~bSend3, ~numberChannels);// add sends
    Out.ar(~bOutMain, output);//all seperate channels have allready been added, we only need to add the send
    Out.ar(~bQue, In.ar(~bPreview, ~numberChannels));
    //Out.ar(~bOutHeads, (1-splitQue)*FoaRotate.ar(FoaPushX.ar(In.ar(~bOutMain, ~numberChannels), splitQue.linlin(0,0.5,0,pi)), angle: splitQue.linlin(0,1,0,pi)) + splitQue*FoaRotate.ar(FoaPushX.ar(In.ar(~bQue, ~numberChannels), splitQue.linlin(0.5,1,pi,0)), angle: pi + splitQue.linlin(0,1,0,pi)));
}).add;
)

// synths
(
~sInputs   = Synth.new(\inputs);
~sEffectKnobsR = Synth.new(\effectKnobsR);
~gChannels = Group.new(~sInputs, \addAfter);
~gChannel7 = Group.new(~gChannels, \addToHead);
~sMicrophone = Synth.head(~gChannel7, \microphone, [\bus, ~bMicrophone]);
Synth.tail(~gChannel7, \monoToFoa, [\bus, ~bMicrophone]);
~sChannel7 = Synth.tail(~gChannel7, \channelMixer,[\inputBus, ~bMicrophone]);
~gEffects  = Group.new(~gChannels, \addAfter);
~sEffect1  = Synth.head(~gEffects, \delay, [\bus, ~bSend1, \effectKnobsBus, ~bEffectKnobsR, \tempoBus, c.bus]);
~sMixer    = Synth.after(~gEffects, \mainMixer);
~sOutputs  = Synth.after(~s_mixer, \outputsSurround);
)

//midi
(
MidiCC([89, 0, ~mBcr], ServerTarget(~sEffectKnobsR, \knob1), mode: \absolute);
MidiCC([90, 0, ~mBcr], ServerTarget(~sEffectKnobsR, \knob2), mode: \absolute);
MidiCC([91, 0, ~mBcr], ServerTarget(~sEffectKnobsR, \knob3), mode: \absolute);
MidiCC([92, 0, ~mBcr], ServerTarget(~sEffectKnobsR, \knob4), mode: \absolute);
MidiCC([103, 0, ~mBcr], ServerTarget(~sChannel7, \faderVolume), mode: \absolute);
MidiCC([104, 0, ~mBcr], ServerTarget(~sChannel7, \send1Volume), mode: \absolute);
)
~sEffect1.trace
~bCrossBypass.scope
~bOutMain.scope;
~bEffectKnobsR.scope
~bEffectKnobsR.index
c.bus.index