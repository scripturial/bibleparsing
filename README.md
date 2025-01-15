# Bible Parsing

This library converts a bible parsing/tagging code into a compressed
u32 value, and allows writing a u32 value back to a string.

    // Convert code to u32 value
    const code = "A-DSN";
    var out = std.ArrayList(u8).init(allocator);
    const in = try parse(code);

    // Convert 
    try byz.string(in, out);
    try std.testing.expectEqualStrings(code, out.items);

There is no promise this code will work for you. It works for me for
my personal use cases. Feel free to use at your own risk. Released
into the public domain under the MIT license.
