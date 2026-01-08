e = Buffer.read(s,"C:/Users/piert/Music/ZSpotify Music/Maybe Set1/TheBoyTapes, J Slayz - 911.ogg");

(
q = SynthDef(\t,{
	Out.ar(0,PlayBuf.ar(2,e));
}).play;
)



~sThrustMaster.trace
~sChannel6.trace