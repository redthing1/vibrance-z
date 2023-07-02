import std.stdio;
import vibrant.d;
import web;

void main(string[] args) {
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["0.0.0.0"];

	auto vib = Vibrant(settings);
	vibrant_web(vib);

	vib.start();

	scope (exit)
		vib.stop();
}
