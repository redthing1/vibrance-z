import std.stdio;
import vibe.d;
import vibrant.d;
import web;

void main(string[] args) {
	auto settings = new HTTPServerSettings;
	settings.port = 8080;

	auto vib = Vibrant(settings);
	vibrant_web(vib);

	// listenHTTP is called automatically
	runApplication();

	scope (exit)
		vib.Stop();
}
