(
SynthDef("DJdeck", { |bus = 0, mute = 1, pos, jumpToPos, bufnum, trackTempo, deckTempoBus|
	var rate, trig, output, position;
	rate =  BufRateScale.kr(bufnum) * In.kr(deckTempoBus) / trackTempo;
	trig = Changed.kr(jumpToPos);
	output = PlayBuf.ar(2, bufnum, rate, trig, pos);
	output = output * mute;
	Out.ar(bus, output);
}).add;
)

s.boot;
o = Bus.audio(s,2);
d = DJdeck(o);
d.loadTrack;
d.play;
d.clock.beats
d.beatJump(-4);
d.jumpToBeat(200);

(
var length, previousIndex = 0, toRemove;
f = File.readAllString("C:\\Users\\PierTabak\\Music\\collection.nml");
length = f.lookup("COLLECTION ENTRIES").asInteger;
a = Array.newClear(length);
for(0,(length-1)){|i|
	var substring, track;
	substring = f.findInBetween("<ENTRY", "</ENTRY>", previousIndex);
	previousIndex = substring.endIndex;
	//track = TrackDescription.newFromTraktor(substring.string);
	try{track = TrackDescription.newFromTraktor(substring.string)}{i.postln; substring.string.postln};
	a.put(i,track);
};
a.removeNil;
)

f = SoundFile.new("C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3");
b = f.asBuffer;

a= ServerOptions.outDevices;
a.do({|item,i|item.postln});

"Windows WASAPI : Microphone Array (Intel® Smart Sound Technology for Digital Microphones)"
"Windows WASAPI : Speakers (Realtek(R) Audio)"

Server.default.options.inDevice_("Windows WASAPI : Microphone Array (Intel® Smart Sound Technology for Digital Microphones)");
Server.default.options.outDevice_("Windows WASAPI : Speakers (Realtek(R) Audio)");

Platform.userConfigDir