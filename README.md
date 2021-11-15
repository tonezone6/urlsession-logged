# URLSession logged

A custom `URLSession` for logging network activity into the console.

```swift
URLSession.logged(.basic)
```

There are two available output levels: `basic` and `detailed`. 

Basic

```
🚀  GET https://users-endpoint.com/user
✅  200 https://users-endpoint.com/user 
```


Detailed

```
🚀  POST https://users-endpoint.com/user
    "Content-Type" : "application/json"
    {
        "foo" : "Foo",
        "bar" : "Bar"
    }

✅  200 https://users-endpoint.com/user 
    {
        "id" : 25918204,
        "name" : "John Doe"
    }
    
⛔️  -999 https://users-endpoint.com/user
    timeout
```
