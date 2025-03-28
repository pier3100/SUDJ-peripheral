s.boot;
Server.killAll;

(
SynthDef("test",{
	Out.kr(0,VolumeFaderCurve.kr(In.kr(0,1)));
}
).add;
)

(
Synth("test");
)