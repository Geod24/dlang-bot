import utils;

import std.format : format;

// test the first items of the cron job
unittest
{
    import std.stdio;
    setAPIExpectations(
        "/github/repos/dlang/phobos/issues?state=open&sort=updated&direction=asc",
        (scope HTTPServerRequest req, scope HTTPServerResponse res){
            res.headers["Link"] = `<https://api.github.com/repositories/1257084/issues?state=open&sort=updated&direction=asc&page=2>; rel="next", <https://api.github.com/repositories/1257084/issues?state=open&sort=updated&direction=asc&page=3>; rel="last"`;
        },
        "/github/repos/dlang/phobos/pulls/2526",
        "/github/repos/dlang/phobos/status/a04acd6a2813fb344d3e47369cf7fd64523ece44",
        "/github/repos/dlang/phobos/issues/2526/labels",
        (scope HTTPServerRequest req, scope HTTPServerResponse res){
            assert(req.method == HTTPMethod.PUT);
            assert(req.json[].map!(e => e.get!string).equal(["blocked", "stalled"]));
        },
        "/github/repos/dlang/phobos/pulls/3534",
        "/github/repos/dlang/phobos/status/b7bf452ca52c2a529e79a830eee97310233e3a9c",
        "/github/repos/dlang/phobos/issues/3534/labels",
        (scope HTTPServerRequest req, scope HTTPServerResponse res){
            assert(req.method == HTTPMethod.PUT);
            assert(req.json[].map!(e => e.get!string).equal(
                ["blocked", "needs rebase", "needs work", "stalled"]
            ));
        },
        "/github/repos/dlang/phobos/pulls/4551",
        "/github/repos/dlang/phobos/status/c4224ad203f5497569452ff05284124eb7030602",
        "/github/repos/dlang/phobos/issues/4551/labels",
        (scope HTTPServerRequest req, scope HTTPServerResponse res){
            assert(req.method == HTTPMethod.PUT);
            assert(req.json[].map!(e => e.get!string).equal(
                ["blocked", "needs rebase", "needs work", "stalled"]
            ));
        },
        "/github/repos/dlang/phobos/pulls/3620",
        "/github/repos/dlang/phobos/status/5b8b90e1824cb90635719f6d3b1f6c195a95a47e",
        "/github/repos/dlang/phobos/issues/3620/labels",
        (scope HTTPServerRequest req, scope HTTPServerResponse res){
            assert(req.method == HTTPMethod.PUT);
            assert(req.json[].map!(e => e.get!string).equal(
                ["Bug Fix", "Enhancement","decision block", "needs rebase", "stalled"]
            ));
        },
    );

    import dlangbot.app : cronDaily;
    cronDaily();
}
