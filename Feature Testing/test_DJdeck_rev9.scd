(
SynthDef(\DJdeck, { |bufnum, outputBus = 0, referenceBufnum, referenceBus, mute = 0, positionSetBus, jumpToPositionBus, trackTempo, deckTempoBus, bendEvent, bendIntensity, pauseBus|
	var rate, rateBended, trig, output, position, blockPosition, referencePosition, blockReferencePosition, jumpToPosition;
	var bend;

	// pitch bending
	bend = Changed.kr(bendEvent);
	bend = bend * bendIntensity;
	bend = Lag.kr(bend, 0.4);

	// rate
	rate =  BufRateScale.kr(bufnum) * (In.kr(deckTempoBus) / trackTempo) * (1 - In.kr(pauseBus)); // if it is paused the rate will be zero; paused is to be used only for when the beat is negative, meaning we are before the track, so we need to wait with playing the track untill we arrive at the start of the track
	rateBended = rate + bend;

	// jumping
	jumpToPosition = K2A.ar(In.kr(jumpToPositionBus));
	trig = Changed.ar(jumpToPosition);

	// position
	//# blockPosition, blockReferencePosition = Integrator.kr([rateBended, rate],1-trig);
	//position =  In.kr(positionSetBus) + (blockPosition* s.options.blockSize);
	//referencePosition =  In.kr(positionSetBus) + (blockReferencePosition* s.options.blockSize);

	position = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rateBended));
	referencePosition = In.kr(positionSetBus) + (SampleRate.ir * Sweep.ar(trig, rate));

	// actual soundfile reading
	output = BufRd.ar(2, bufnum, position);
	output = output * Lag.kr(1 - mute, 0.01);
	Out.ar(outputBus, output);

	// for reference
	Out.kr(referenceBus,[position, referencePosition]);
}).add;
)
y = l.asCompileString.interpret
y.tracks[2].title
l.tracks[2].title
y.tracks
l.tracks
l.writeArchive("C:\\Users\\PierTabak\\Music\\Music\\ar.txt");
Library.addFromJSON("C:\\Users\\PierTabak\\Music\\SuperCollider\\Project_rev7\\config.JSON");
Library.at(\musicLibraryPath)

d = "C:\\Users\\PierTabak\\Music\\SuperCollider\\Project_rev7\\config.JSON".parseJSONFile;
d.do({|item| Library.put
	d.do({|item| item.postln})
	d.asPairs
	d.getPairs[0].asSymbol
	d.asAssociations
	d.class
	d.at("musicLibraryPath")
d.getPairs.[0].class
d = Dictionary[\monkey -> 99];
d.at(\monkey)
	4/2
	File.mtime("C:\\Users\\PierTabak\\Music\\Music\\ar.txt");
	File.mtime("C:\\Users\\PierTabak\\Music\\collection.nml");
y = Object.readTextArchive("C:\\Users\\PierTabak\\Music\\Music\\ar.txt");

	o = "<ENTRY MODIFIED_DATE=\"2023/7/23\" MODIFIED_TIME=\"30789\" AUDIO_ID=\"AUQ1d4eWZ4eXV3eKiZmdmIl6d4iJhoiJx4hnzd3d7M3d7t3e7cy5jP/f7v7u7v3d7e3N3e3Oz+3f7v/u/u3tzey5qZmYmom5mZiZirznR2M1VWarVEIjRVNY///9///u/t3d7d3d7u3O/t3+/+7v/////+3N7d3c7c7szdzMVFzM3e3c7u/t3N7t2a3EQkVURVRFVTIkaZet/u/v//7v/e/u/e7v/szf/e/f/u7u7t3e7v7v7+7t3tzd3fzc3bIhMzVTREVUQleGZ2cgJVRDIQT///7+/d7v7e/v7d7u3c7+7v3u7u3t7d3e3cvcy8u7uqq6vKurqFMzMjMRAAAAAA==\" TITLE=\"Dirty Mariposa\" ARTIST=\"Parov Stelar\"><LOCATION DIR=\"/:Users/:piert/:Music/:ZSpotify Music/:Maybe Set1/:\" FILE=\"Parov Stelar - Dirty Mariposa.mp3\" VOLUME=\"C:\" VOLUMEID=\"a440e74c\"></LOCATION>";
	o.lookup("AUDIO_ID");

l =
		l = MusicLibrary.loadFromTraktor("C:\\Users\\PierTabak\\Music\\Music\\ar.txt","C:\\Users\\PierTabak\\Music\\collection.nml");
	l.updateTracksFromTraktor(File.readAllString("C:\\Users\\PierTabak\\Music\\collection.nml"));
l = MusicLibrary.newFromTraktor("C:\\Users\\PierTabak\\Music\\collection.nml");
	l.store("C:\\Users\\PierTabak\\Music\\Music\\ar.txt")
		l.playlists[0].randomTrack
	Library.at(\musicLibrary)
	l.tracks[0].id
t = l.findTitle("Tuvan 1")[0];
t.path = "C:\\Users\\PierTabak\\Music\\Music\\To Edit\\Anmon - Anmon - Tuvan 1.mp3";//overwrite path for now, because at different PC

y = l.findTitle("Curativo")[0];
y.path = ("C:\\Users\\PierTabak\\Music\\Music\\To Edit\\LAZA - Mergulho - Curativo.mp3");

	Library.addFromJSON("C:\\Users\\PierTabak\\Music\\SuperCollider\\Project_rev7\\config.JSON");
	Library.at(\musicLibraryPath)

o = Bus.audio(s,2);
d = DJdeck.new(o,125);

i = Bus.audio(s,2);
e = DJdeck.new(i,125);
)

n = Date.getDate
n.dayStamp
n.asSortableString.cl
n.month.class
n.rawSeconds
n
e= Date.rawSeconds(1704444570)
j = e.asSortableString
e.day_(e.day.asInteger)
e.year
e.dayStamp
e.month.class
e = Date.new(year: 2024);
e = "2023/3/28".replace("\/")
e > j
e<n
r = "2025"
r<n
(
SystemClock.sched(1,{
((d.beatsReference-d.clock.beats)/d.clock.tempo).postln;
	1;
});
)
d.jumpToBeat(100)
(
d.beatsReference.postln;
d.clock.beats.postln;
)
d.clock.tempoInterface_(1)

d.userInducedGridOffset
d.track.gridOffset
d.beatJump(8);
d.pitchbend_(1)
d.clock.beats

d.clock.beats_(100);

(
d.position2beatAdjusted(d.referenceBus.getSynchronous).postln;
d.clock.beats.postln;
)

d.clock.dependants
d.loadAndPlayTrack(t);
(
d.clock.beats.postln;

0.1/60*10
(120-120.1)/60*10/(120/60)

0.1/120*60
d.pause
d.play
e.pause
d.clock.tempoInterface_(2.2)
d.loadAndPlayTrack(y);
e.play
d.loadDouble(e);
d.play
(
d.pause;
e.loadAndPlayDouble(d);
)
e.clock.tempo
e.clock.pause
e.play
e.synth.trace
Stethoscope.new
s.plotTree
a = Bus.audio;
a.getSynchronous