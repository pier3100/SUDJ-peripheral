(
t = HID.findAvailable;
h = HID.open(3118, 2823);
h.action_({|val, something, rawVal, arrayVal, elementUsage, elementUsagePage, elementId| if(elementUsagePage == 140 && elementUsage == 254){rawVal.postln}});
HID.debug = true;
)
//TODO: debug code by first taking a look at the first character only, see hidapi_parser, not yet commit, pushed, and pulled
////TEST
                //cur_element->report_index = 2; //for first test




HID.action_({|val, valRaw,  elementUsage, elementUsagePage,elementId, element, deviceId, device| if(elementUsagePage == 140 && elementUsage == 254){ e = element}});

HID.debug = false;
t = HID.postAvailable
t.asArray.selectIndices({ |item| item.productName =="HID POS" })
t[14].productName =="HID POS"
HIDInfo.browse
//  \\?\hid#vid_0c2e&pid_0b07&mi_00#8&12aced56&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}: 3118, 2823
//  \\?\hid#vid_0c2e&pid_0b07&mi_00#8&2c1303ec&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}
(
o = 3;
(
var open;
open = 5;
)
)
(
var open;
open = 5;
)

IdentityDictionary.browse
t.array
t.size

t = HID.findAvailable;

HID.openAt(t.selectKeys({ |item| item.productName =="HID POS" })[0])
    selectKeys { |func|
        var array, indices, selectecValues, selectedKeys;
	~func = { |item| item.productName =="HID POS" };
        ~selectedKeys = Array.new(t.size);
        ~array = t.asArray;
        ~indices = ~array.selectIndices(~func);
        ~selectecValues = ~array[~indices];
	~selectecValues.do({ |item| var key; (key = t.findKeyForValue(item)) !? ({~selectedKeys.add(key) }) });
        ~selectedKeys;
    }
k = t[14]
g = t.findKeyForValue(k) !? ({g})
g = t.findKeyForValue(k) 