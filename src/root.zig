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

    // Convert code to u32 value
    const code = "A-DSN";
    var out = std.ArrayList(u8).init(std.testing.allocator);
    defer out.deinit();
    const in = try parse(code);

    // Convert u32 back to string
    try byz.string(in, &out);
    try std.testing.expectEqualStrings(code, out.items);

    try testing.expectEqual(9449476, @as(u32, @bitCast(in)));
}
test {
    std.testing.refAllDecls(@This());
}
