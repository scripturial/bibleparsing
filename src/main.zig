const std = @import("std");
const Parsing = @import("parsing.zig").Parsing;
//const parse = @import("parse.zig").parse;
//const byz = @import("byz.zig");
const bp = @import("bibleparsing.zig");

pub const Error = error{ InvalidParsing, Incomplete };

pub fn main() !void {
    if (std.os.argv.len > 0) {
        const input: [*:0]u8 = std.os.argv[1];
        const in: [:0]const u8 = std.mem.span(input);

        const p = bp.parse(in) catch |e| {
            std.debug.print("parse failed: {s} -> {any}\n", .{ in, e });
            return;
        };
        var out = std.ArrayList(u8).init(std.heap.page_allocator);
        defer out.deinit();
        bp.byz.string(p, &out) catch |e| {
            std.debug.print("to string failed: {s} -> {any}\n", .{ in, e });
            return;
        };
        std.debug.print("output: {s} -> {s}\n", .{ in, out.items });
    } else {
        std.debug.print("example: main N-MSN\n", .{});
    }
}

test {
    std.testing.refAllDecls(@This());
}
