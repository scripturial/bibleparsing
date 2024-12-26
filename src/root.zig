const std = @import("std");
const testing = std.testing;
const parser = @import("parse.zig").parse;
const parsing = @import("parsing.zig").Tokenizer;

export fn parse_cstring(data: *const [*:0]u8, max: usize) u32 {
    const t: parsing.Tokenizer = .{
        .data = data,
        .index = 0,
        .limit = max, // Stop at zero, or if we hit 1000
        .parsing = .{},
    };
    return parsing.parse_data(t);
}

test "basic library functionality" {
    try testing.expectEqual(parse_cstring("A-DSN ", 6), 10);
}
