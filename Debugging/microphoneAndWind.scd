~windMute.toggle_
~windMute.value
~windMute.value_(true)
~windMute.value_(false)
m = MidiButton([50, 0, ~mBcr], BoolLangLangTarget(~windMute, \value), mode: \direct, feedbackMode: false);
m.targetOff
m.target.parameterValue
m.targetOn.value(true)
m.targetOn.value(false)
m.messageMapping
~sWind
~windParameter.value
~bWind.scope
~sChannel7.trace
c.sched(1,~wind);