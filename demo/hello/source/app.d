import vibrant.d;

shared static this() {
	with (Vibrant) {
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
}
