import vibe.d;
import vibrant.d;
import std.stdio;

void main(string[] args) {
	writefln("args: %s", args);
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	
	auto vib = Vibrant(settings);
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

	// listenHTTP is called automatically
	runApplication();

	scope(exit) vib.Stop();
}
