HID.findAvailable;
HID.postAvailable;
h = HID.openAt(7);
h.action_({arg ...args; args.postln});
h.action_(nil);
h.deviceAction_({arg ...args; args.postln});
r.respondsTo(hoi)
1.not


HID.openDevices
HID.action_({arg ...args; args.postln})