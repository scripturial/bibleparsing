pub const parse = @import("parse.zig").parse;
pub const Parsing = @import("parsing.zig").Parsing;
pub const Gender = @import("parsing.zig").Gender;
pub const PartOfSpeech = @import("parsing.zig").PartOfSpeech;
pub const Error = @import("parse.zig").Error;
pub const byz = @import("byz.zig");
pub const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
