HID.findAvailable;
HID.postAvailable;
h = HID.openAt(14);
h.close
h.isOpen

h.action_({arg ...args; args.postln});
h.action_(nil);
h.action_({|val, rawVal, elementUsagePage, elementUsage, elementID| if(elementUsagePage == 140){elementUsagePage.postln}});
h.deviceAction_({arg ...args; args.postln});
r.respondsTo(hoi)
1.not


HID.openDevices
HID.action_({arg ...args; args.postln})
w = 0
w
HID.action_(nil);
HID.action_({|val, valRaw,  elementUsage, elementUsagePage,elementId, element, deviceId, device| if(elementUsagePage == 140 && elementUsage == 254){element.postElement; element.rawValue.postln; e = element}});
h.postElements
h.elements[11].rawValue.asHexString

e.rawValue.postln
e.
e.usage
e.reportID
e.reportIndex
e.reportSize
e.logicalValue
e.physicalValue
e.arrayValue.asHexString.ascii
e.rawValue
e.arrayValue
128.asBinaryDigits
e.arrayValue.asBinaryDigits
e.arrayValue.class
e.collection
h.collections
"hoi".postln
e.typeSpec
HID.debug = true
