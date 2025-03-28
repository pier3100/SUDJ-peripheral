(s.sampleRate.asInteger * 60 * 60).class;
s.sampleRate
a = Array.series(s.sampleRate.asInteger * 60 *10, 1, 1);
b = Buffer.loadCollection(s,a);
b
b.write("C:\\Users\\PierTabak\\Music\\Music\\buffer1.txt")
a
(
var size, new;
size = b.numFrames;
new = Array.series(100000,size,1);
b.loadCollection(new,size);
)

(
SynthDef(\test, { |rate|
	PlayBuf.kr(1,b);
}).add;
)

~s1 = Synth.new(\test,[\rate, 0.001]);
~s2 = Synth.new(\test,[\rate, 0.002]);
~s3 = Synth.new(\test,[\rate, 0.0011]);
~s4 = Synth.new(\test,[\rate, 0.0015]);

(
~s1.trace;
~s2.trace;
~s3.trace;
~s4.trace;
)