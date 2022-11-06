# vibrance-z

 a revival of vibrant.d

## overview

vibrant.d is a light routing framework that mimicks the style of frameworks like Sinatra and Spark.

## a simple example

```d
with (vib) {
    Get("/hello", (req, res) => "Hello World!");

    Before("/hello/:name", (req, res) {
        if (req.params["name"] == "Jack") {
            halt("Don't come back.");
        }
    });

    Get("/hello/:name", (req, res) =>
            "Hello " ~ req.params["name"]
    );
}
```

## demo

see [hello demo](demo/hello) for a demo showing off some features.
