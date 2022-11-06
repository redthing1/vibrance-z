import vibe.d;
import vibrant.d;
import std.stdio;

void main(string[] args) {
	writefln("args: %s", args);
	auto settings = new HTTPServerSettings;
	settings.port = 8080;

	with (Vibrant(settings)) {
		Get("/hello", (req, res) => "Hello World!");

		Before("/hello/:name", (req, res) {
			if (req.params["name"] == "Jack") {
				halt("Don't come back.");
			}
		});

		Get("/hello/:name", (req, res) =>
				"Hello " ~ req.params["name"]
		);

		scope (exit) {
			Stop();
		}
	}

	// listenHTTP is called automatically

	runApplication();
}
