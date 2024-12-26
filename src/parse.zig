const std = @import("std");
const Parsing = @import("parsing.zig").Parsing;

pub const Error = error{ InvalidParsing, Incomplete };

pub fn parse(data: []const u8) !Parsing {
    var t: Tokenizer = .{
        .data = data,
        .index = 0,
        .limit = data.len,
        .parsing = .{},
    };
    return parse_data(&t);
}

pub fn parse_data(t: *Tokenizer) !Parsing {
    t.skip();
    const c = t.next();
    const p = t.peek();
    if (p == '-' or p == 0) {
        _ = t.next();
        switch (c) {
            'V' | 'v' => {
                t.parsing.part_of_speech = .verb;
                try parse_vp(t);
                return t.parsing;
            },
            'N' | 'n' => {
                t.parsing.part_of_speech = .noun;
                try parse_cng(t);
                return t.parsing;
            },
            'A' | 'a' => {
                t.parsing.part_of_speech = .adjective;
                try parse_cng(t);
                return t.parsing;
            },
            'R' | 'r' => {
                t.parsing.part_of_speech = .relative_pronoun;
                try parse_cng(t);
                return t.parsing;
            },
            'C' | 'c' => {
                t.parsing.part_of_speech = .relative_pronoun;
                try parse_cng(t);
                return t.parsing;
            },
            'D' | 'd' => {
                t.parsing.part_of_speech = .demonstrative_pronoun;
                try parse_cng(t);
                return t.parsing;
            },
            'T' | 't' => {
                t.parsing.part_of_speech = .article;
                try parse_cng(t);
                return t.parsing;
            },
            'O' | 'o' => {
                t.parsing.part_of_speech = .pronoun;
                try parse_cng(t);
                return t.parsing;
            },
            'K' | 'k' => {
                t.parsing.part_of_speech = .pronoun;
                t.parsing.correlative = true;
                try parse_cng(t);
                return t.parsing;
            },
            'I' | 'i' => {
                t.parsing.part_of_speech = .pronoun;
                t.parsing.interrogative = true;
                try parse_cng(t);
                return t.parsing;
            },
            'X' | 'x' => {
                t.parsing.part_of_speech = .pronoun;
                t.parsing.indefinite = true;
                try parse_cng(t);
                return t.parsing;
            },
            'Q' | 'q' => {
                t.parsing.part_of_speech = .pronoun;
                t.parsing.interrogative = true;
                t.parsing.correlative = true;
                try parse_cng(t);
                return t.parsing;
            },
            'F' | 'f' => {
                t.parsing.part_of_speech = .reflexive_pronoun;
                if (p == '-') {
                    try parse_person(t);
                }
                return t.parsing;
            },
            else => {
                return error.InvalidParsing;
            },
        }
    }

    // TODO multi letter pos

    return error.InvalidParsing;
}

pub fn parse_a(t: *Tokenizer) !Parsing {
    t.skip();
    const c = t.next();
    switch (c) {
        '-' => {
            parse_cng(t);
        },
        'D' | 'd' => {
            if (c == 'v' or c == 'v') {
                parse_adv_type(t);
            } else {
                return error.InvalidParsing;
            }
        },
        else => {
            return error.InvalidParsing;
        },
    }
    return error.InvalidParsing;
}

pub fn parse_vp(t: *Tokenizer) !void {
    // tense-form
    const c = t.next();
    if (c == '2') {
        switch (t.next()) {
            'F' | 'f' => {
                t.parsing.tense_form = .second_future;
            },
            'A' | 'a' => {
                t.parsing.tense_form = .second_aorist;
            },
            'R' | 'r' => {
                t.parsing.tense_form = .second_perfect;
            },
            'L' | 'l' => {
                t.parsing.tense_form = .second_pluperfect;
            },
            else => {
                return error.InvalidParsing;
            },
        }
    }
    switch (c) {
        'P' | 'p' => {
            t.parsing.tense_form = .present;
        },
        'I' | 'i' => {
            t.parsing.tense_form = .imperfect;
        },
        'F' | 'f' => {
            t.parsing.tense_form = .future;
        },
        'A' | 'a' => {
            t.parsing.tense_form = .aorist;
        },
        'R' | 'r' => {
            t.parsing.tense_form = .perfect;
        },
        'L' | 'l' => {
            t.parsing.tense_form = .pluperfect;
        },
        else => {
            return error.InvalidParsing;
        },
    }
}

pub fn parse_person(t: *Tokenizer) !void {
    // case
    switch (t.next()) {
        '1' => {
            t.parsing.person = .first;
        },
        '2' => {
            t.parsing.person = .second;
        },
        '3' => {
            t.parsing.person = .third;
        },
        else => {
            return error.InvalidParsing;
        },
    }
}

pub fn parse_cng(t: *Tokenizer) !void {
    // case
    switch (t.next()) {
        'N' | 'n' => {
            t.parsing.case = .nominative;
        },
        'A' | 'a' => {
            t.parsing.case = .accusative;
        },
        'G' | 'g' => {
            t.parsing.case = .genitive;
        },
        'D' | 'd' => {
            t.parsing.case = .dative;
        },
        'V' | 'v' => {
            t.parsing.case = .vocative;
        },
        else => {
            return error.InvalidParsing;
        },
    }

    // number
    switch (t.next()) {
        'S' | 's' | '1' => {
            t.parsing.number = .singular;
        },
        'P' | 'p' | '2' => {
            t.parsing.number = .plural;
        },
        else => {
            return error.InvalidParsing;
        },
    }

    // gender
    switch (t.next()) {
        'M' | 'm' => {
            t.parsing.gender = .masculine;
        },
        'F' | 'f' => {
            t.parsing.gender = .feminine;
        },
        'N' | 'N' => {
            t.parsing.gender = .neuter;
        },
        else => {
            return error.InvalidParsing;
        },
    }

    if (!is_breaking(t.next())) {
        return error.InvalidParsing;
    }
}

pub fn parse_adv_type(t: *Tokenizer) !Parsing {
    // case
    switch (t.next()) {
        'I' | 'i' => {
            t.parsing.interrogative = true;
        },
        'K' | 'k' => {
            t.parsing.correlative = true;
        },
        'N' | 'n' => {
            t.parsing.negative = true;
        },
        'C' | 'c' => {
            t.parsing.comparative = true;
        },
        'S' | 's' => {
            t.parsing.superlative = true;
        },
        else => {
            return error.InvalidParsing;
        },
    }

    if (is_breaking(t.next())) {
        return t.parsing;
    }
}

const Tokenizer = struct {
    data: []const u8,
    index: usize,
    limit: usize,
    parsing: Parsing,

    inline fn next(self: *Tokenizer) u8 {
        if (self.index >= self.limit) {
            return 0;
        }
        const c = self.data[self.index];
        if (c != 0) {
            self.index += 1;
        }
        return c;
    }

    inline fn peek(self: *Tokenizer) u8 {
        if (self.index >= self.limit) {
            return 0;
        }
        return self.data[self.index];
    }

    inline fn skip(self: *Tokenizer) void {
        while (self.index <= self.limit) {
            const c = self.data[self.index];
            if (is_breaking(c)) {
                // Increment over valid/plausible leading characters
                self.index += 1;
            }
            return;
        }
        return;
    }
};

inline fn is_breaking(c: u8) bool {
    return (c == ' ' or c == '{' or c == '}' or c == '[' or c == ']' or c == '(' or c == ')' or c == '.' or c == '\"' or c == '\'');
}

const expectEqual = std.testing.expectEqual;
const expectError = std.testing.expectError;

test "simple parsing tests" {
    // Some basic sanity checks.
    expectEqual(Parsing{
        .part_of_speech = .noun,
        .case = .nominative,
        .number = .singular,
        .gender = .masculine,
    }, parse("N-NSM"));
    expectEqual(Parsing{
        .part_of_speech = .article,
        .case = .genitive,
        .number = .plural,
        .gender = .feminine,
    }, parse("T-GSF"));
    expectEqual(Parsing{
        .part_of_speech = .verb,
        .tense_form = .present,
        .voice = .active,
        .mood = .indicative,
        .person = .second,
        .number = .plural,
    }, parse("V-PAI-2P"));

    expectError(error.InvalidParsing, parse("M-GSF"));
    expectError(error.Incomplete, parse("A-GS"));
    expectError(error.Incomplete, parse("V"));
}
