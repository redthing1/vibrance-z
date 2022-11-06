module web;

import std.stdio;
import std.typecons;
import std.json;
import vibe.d;
import vibrant.d;
import mir.ser.json : serializeJson;

struct Book {
    string id;
}

struct Bookshelf {
    static Book[] all = [Book("apple"), Book("banana"), Book("cherry")];

    static Nullable!Book find(string id) {
        foreach (book; all) {
            if (book.id == id) {
                return Nullable!Book(book);
            }
        }
        return Nullable!Book.init;
    }

    static bool destroy(string id) {
        foreach (i, book; all) {
            if (book.id == id) {
                all = all[0 .. i] ~ all[i + 1 .. $];
                return true;
            }
        }
        return false;
    }
}

class BookController {
    mixin Routes;

    // GET /book
    void index() {
        auto books = Bookshelf.all;

        render!JSON = books.serializeJson;
    }

    // GET /book/:id
    void show() {
        auto id = params["id"].as!string;
        auto book = Bookshelf.find(id);

        render!JSON = book.serializeJson;
    }

    // DELETE /book/:id
    void destroy() {
        auto id = params["id"].as!string;

        if (Bookshelf.destroy(id)) {
            render!EMPTY = 201;
        } else {
            render!EMPTY = 404;
        }
    }
}

void vibrant_web(T)(T vib) {
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

        Resource!BookController;
    }
}
