pub const std = @import("std");

pub const parse = @import("parse.zig").parse;
pub const Parsing = @import("parsing.zig").Parsing;
pub const Gender = @import("parsing.zig").Gender;
pub const Error = @import("parse.zig").Error;
pub const byz = @import("byz.zig");

pub const PartOfSpeech = @import("part_of_speech.zig").PartOfSpeech;
pub const pos_to_string = @import("part_of_speech.zig").pos_to_string;
pub const pos_to_camel_case = @import("part_of_speech.zig").pos_to_camel_case;
pub const parse_pos = @import("part_of_speech.zig").parse_pos;

test {
    std.testing.refAllDecls(@This());
}
