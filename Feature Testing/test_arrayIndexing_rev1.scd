(
SynthDef("test1",{arg hoi, parameters = #[0, 0, 0, 0]; var input, output, room, room2, mix2;
	room = parameters[2];
	room2 = hoi.volumeFaderCurve;
	mix2 = hoi;
	input = In.ar(0,2);
	output = FreeVerb2.ar(input[0], input[1], mix2, room2, damp: 0.5, mul: mix2, add: 0.0);
})

)

OutputProxy.browse;