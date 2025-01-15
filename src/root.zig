const std = @import("std");
const testing = std.testing;
const parse = @import("parse.zig").parse;
const Parsing = @import("parsing.zig").Parsing;
const byz = @import("byz.zig");

//const parsing = @import("parse.zig").Tokenizer;

//export fn parse_cstring(data: *const [*:0]u8, max: usize) u32 {
//    const t: parsing.Tokenizer = .{
//        .data = data,
//        .index = 0,
//        .limit = max, // Stop at zero, or if we hit 1000
//        .parsing = .{},
//    };
//    return parsing.parse_data(t);
//}

test "basic library functionality" {
    const in = "A-DSN";
    const out = try parse(in);
    try testing.expectEqual(9449476, @as(u32, @bitCast(out)));
    const s = try byz.byz_string(out, std.testing.allocator);
    defer s.deinit();
    try std.testing.expectEqualStrings(in, s.items);
}
