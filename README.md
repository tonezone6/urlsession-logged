# SwiftNetworkLogger

A lightweight Swift package extending `URLSession` for logging network activity into the console.
To enable that, use the custom  `Combine` publisher. 

```swift
URLSession.shared
    .load(Response.self, with: request)
    .compactMap { $0.user }
    .map { user in 
        user.first + " " + user.last
    }
    .eraseToAnyPublisher()
```
