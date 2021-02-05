# Session logger

A custom `URLSession` for logging network activity into the console. 

```swift
URLSession.logger.load(User.self, with: request) { ... }
```

Output

```
🚀  POST https://some-endpoint.com/user
    * request headers: ["Content-Type": "application/json"]
    * request body: {
        "foo" : "Foo",
        "bar" : "Bar"
      }

👍  https://some-endpoint.com/user
    * response code: 200
    * response body: {
        "id" : 25918204,
        "first" : "John",
        "last" : "Williams"
      }
```
