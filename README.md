# SwiftNetworkLogger

A lightweight Swift package to help development phase, logging network activity into the console.
It simply extends `URLSession` and you can use `Logger` methods directly into your networking code

``` swift
if let error = error {
    Logger.log(error)
    // ...
} 
if let response = response, let data = data {
    Logger.log(response)
    Logger.log(data)
    // ...
}
```

or you can just use  `load(_:with:)` method

```swift
URLSession.shared.load(User.self, with: request) { result in
    switch result {
    case .success(let user):  
        // ...
    case .failure(let error): 
        // ...
    }
}
```

Output

```
⬆️ POST https://some-endpoint.com/user
+ request headers: ["Content-Type": "application/json"]
+ request body: {
    "foo" : "Foo",
    "bar" : "Bar"
}

✅ https://some-endpoint.com/user
+ response code: 200
+ response body: {
    "id" : 25918204,
    "first" : "John",
    "last" : "Williams"
}
```
