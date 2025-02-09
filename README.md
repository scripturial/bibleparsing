# Bible Parsing

This library converts a bible parsing/tagging code into a compressed
u32 value, and allows writing a u32 value back to a string. Tested
using the parsing codes found in the Byzantine Text data files.

```zig
// Convert code 'A-DSN' to u32 value.
const in = try parse("A-DSN");

// Convert u32 value back to code.
var out = std.ArrayList(u8).init(allocator);
try byz.string(in, out);
try std.testing.expectEqualStrings(code, out.items);

// Incomplete or InvalidParsing errors may be returned.
try std.testing.expectEqual(Error.Incomplete, parse(""));
try std.testing.expectEqual(Error.InvalidParsing, parse("Z"));
```

There is no promise this code will work for you. It works for me for
my personal use cases. Feel free to use at your own risk. Released
into the public domain under the MIT license.

Sponsored by [Scripturial - Learn Biblical Greek](https://scripturial.com/)
