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

f = File.new("C:\\Users\\PierTabak\\Music\\collection.nml","r");
q = String.readNew(f);
"These are several words".find("are").postln;
q.mid(10,20);
h = "hoi"
h.asFloat

p = "\"hoi\""

String.browse;
p.replace("\"");


q.lookup("TITLE")
p++p
p
p.find("i",2)
w = "TRIES=\"3327\"\>"
w.lookup("TRIES",0,"=\"","\"");

w.findInBetween("TRIES=\"","\"");
a = w.find("TRIES=\"") + "TRIES=\"".size;
b = w.find("\"", offset: 7);
w.mid(7,4)

q.findInBetween("<ENTRY","</ENTRY>")
q.find("")
[3,"hoi"]
l = Array(4000);

(
var length, previousIndex = 0, substring;
f = File.readAllString("C:\\Users\\PierTabak\\Music\\collection.nml");
length = f.lookup("COLLECTION ENTRIES").asInteger;
a = Array.newClear(length);
for(1,5){|i|
	substring = f.findInBetween("<ENTRY", "</ENTRY>", previousIndex);
	previousIndex = substring.endIndex;
	a.put(i,substring.string);
}
a[2].class
)
f.findInBetween("<ENTRY","</ENTRY>")
a= Array.newClear(5);
a.put(3,"hoi")