const std = @import("std");
const Parsing = @import("parsing.zig").Parsing;
const parse = @import("parse.zig").parse;

pub const Error = error{ InvalidParsing, Incomplete };

pub fn main() !void {
    parse("N-NSM");
}
