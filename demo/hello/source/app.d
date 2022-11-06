import vibe.d;
import vibrant.d;
import std.stdio;

// class BookController {
// 	mixin Routes;

// 	// GET /book
// 	void index() {
// 		Book[] books = Book.all;

// 		render!JSON = books.toJson;
// 	}

// 	// GET /book/:id
// 	void show() {
// 		string id = params["id"];
// 		Book book = Book.find(id);

// 		render!JSON = book.toJson;
// 	}

// 	// DELETE /book/:id
// 	void destroy() {
// 		string id = params["id"];
// 		Book.destroy(id);

// 		render!EMPTY = 201;
// 	}
// }

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

		Catch(Exception.classinfo, (ex, req, res) {
			res.statusCode = 500;
			res.writeBody(ex.msg);
		});

		Get("/oops", (req, res) { throw new Exception("Whoops!"); });

		Get!Json("/hello2/:name", "application/json",
			(req, res) =>
				Json([
						"greeting": Json("Hello " ~ req.params["name"])
					]),
				(json) =>
				json.toPrettyString
		);

		with (Scope("/api")) {
			// Path : /api/hello
			Get("/hello", (req, res) => "Hello developer!");

			with (Scope("/admin")) {
				// Path : /api/admin/hello
				Get("/hello", (req, res) => "Hello admin!");
			}
		}

		// Resource!BookController;
	}

	// listenHTTP is called automatically
	runApplication();

	scope (exit)
		vib.Stop();
}
