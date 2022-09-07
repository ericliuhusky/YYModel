# YYModel

YYModel实现原理

```swift
let json: [String: Any] = [
    "uid": 123,
    "name": "Harry",
    "created": 684042754.858783
]

@objcMembers
class User: NSObject {
    var uid: UInt64 = 0
    var name: NSMutableString!
    var created: NSDate!
}

let user = User.yy_model(withJSON: json)!
let dict = user.yy_modelToJSONObject() as! [String: Any]
dump(user)
print(dict)
```
