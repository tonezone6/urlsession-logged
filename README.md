# SwiftNetworkLogger

A lightweight Swift package extending `URLSession` for logging network activity into the console.
You can use `Logger` methods directly into your networking code

``` swift
URLSession.shared.dataTask(with: request) { (data, response, error) in
    if let error = error {
        Logger.log(error)
        return completion(.failure(error))
    }
    if let response = response, let data = data {
        Logger.log(response)
        Logger.log(data)
        // ...
    }
}.resume()
```

or you can use the convenient `load(_:with:)` methods (`Combine` variant is used below)

```swift
URLSession.shared
    .load(SomeModel.self, with: request)
    .compactMap { $0.user }
    .map { user in 
        user.first + " " + user.last
    }
```

Console output example

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
    "time" : 1611680417,
    "user" : {
        "id" : 25918204,
        "first" : "John",
        "last" : "Williams"
    }
}
```
