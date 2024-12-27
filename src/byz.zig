//! Output a `Parsing` bitfield in the format use
//! by the byzantine GNT

const std = @import("std");
const parsing = @import("parsing.zig");

pub fn byz_string(p: parsing.Parsing, allocator: std.mem.Allocator) !std.ArrayList(u8) {
    var b = std.ArrayList(u8).init(allocator);

    switch (p.part_of_speech) {
        .unknown => {
            return b;
        },
        .adverb => {
            try b.appendSlice("ADV");
            try append_flag(p, &b);
            return b;
        },
        .comparative_adverb => {
            try b.appendSlice("ADV-C");
            return b;
        },
        .superlative_adverb => {
            try b.appendSlice("ADV-S");
            return b;
        },
        .conjunction => {
            try b.appendSlice("CONJ");
            try append_flag(p, &b);
            return b;
        },
        .conditional => {
            try b.appendSlice("COND");
            try append_flag(p, &b);
            return b;
        },
        .particle => {
            try b.appendSlice("PRT");
            try append_flag(p, &b);
            return b;
        },
        .preposition => {
            try b.appendSlice("PREP");
            try append_flag(p, &b);
            return b;
        },
        .interjection => {
            try b.appendSlice("INJ");
            try append_flag(p, &b);
            return b;
        },
        .aramaic_transliteration => {
            try b.appendSlice("ARAM");
            return b;
        },
        .hebrew_transliteration => {
            try b.appendSlice("HEB");
            return b;
        },
        .proper_noun => {
            if (p.indeclinable) {
                try b.appendSlice("N-PRI");
                return b;
            }
        },
        .numeral => {
            if (p.indeclinable) {
                try b.appendSlice("A-NUI");
                return b;
            }
        },
        .letter => {
            if (p.indeclinable) {
                try b.appendSlice("N-LI");
                return b;
            }
        },
        .noun => {
            if (p.indeclinable) {
                try b.appendSlice("N-OI");
                return b;
            }
        },
        else => {},
    }

    switch (p.part_of_speech) {
        .verb => {
            try b.append('V');
            try append_vp(p, &b);
            return b;
        },
        .noun => {
            try b.append('N');
            try append_cng(p, &b);
            return b;
        },
        .article => {
            try b.append('T');
            try append_cng(p, &b);
            return b;
        },
        .adjective => {
            try b.append('A');
            try append_cng(p, &b);
            return b;
        },
        .relative_pronoun => {
            try b.append('R');
            try append_cng(p, &b);
            return b;
        },
        .reciprocal_pronoun => {
            try b.append('C');
            try append_cng(p, &b);
            return b;
        },
        .demonstrative_pronoun => {
            try b.append('D');
            try append_cng(p, &b);
            return b;
        },
        .reflexive_pronoun => {
            try b.appendSlice("F-");
            try append_person(p, &b);
            try append_cng(p, &b);
            return b;
        },
        .possessive_pronoun => {
            try b.appendSlice("S-");
            try append_ref(p, &b);
            try append_cng(p, &b);
            return b;
        },
        .personal_pronoun => {
            try b.appendSlice("P-");
            try append_pcn(p, &b);
            return b;
        },
        .proper_noun => {
            if (p.indeclinable) {
                try b.appendSlice("IPN");
                try append_cng(p, &b);
                return b;
            }
            try b.appendSlice("PN");
            try append_cng(p, &b);
            return b;
        },
        .pronoun => {
            if (p.correlative and p.interrogative) {
                try b.appendSlice("Q");
                try append_cng(p, &b);
                return b;
            }
            if (p.correlative) {
                try b.appendSlice("K");
                try append_cng(p, &b);
                return b;
            }
            if (p.interrogative) {
                try b.appendSlice("I");
                try append_cng(p, &b);
                return b;
            }
            if (p.indefinite) {
                try b.appendSlice("X");
                try append_cng(p, &b);
                return b;
            }
            try b.appendSlice("O");
            try append_cng(p, &b);
            return b;
        },
        .superlative_adverb => {
            try b.appendSlice("ADV-S");
            try append_flag(p, &b);
            return b;
        },
        .superlative_noun => {
            try b.appendSlice("N");
            try append_cng(p, &b);
            try b.appendSlice("-S");
            return b;
        },
        .superlative_adjective => {
            try b.appendSlice("A");
            try append_cng(p, &b);
            try b.appendSlice("-S");
            return b;
        },
        .comparative_adverb => {
            try b.appendSlice("ADV-C");
            try append_flag(p, &b);
            return b;
        },
        .comparative_noun => {
            try b.append('N');
            try append_cng(p, &b);
            try b.appendSlice("-C");
            return b;
        },
        .comparative_adjective => {
            try b.append('A');
            try append_cng(p, &b);
            try b.appendSlice("-C");
            return b;
        },
        else => {},
    }

    return b;
}

inline fn append_person(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    switch (p.person) {
        .first => try b.append('1'),
        .second => try b.append('2'),
        .third => try b.append('3'),
        else => return,
    }
}

inline fn append_pcn(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    switch (p.person) {
        .first => try b.appendSlice("-1"),
        .second => try b.appendSlice("-2"),
        .third => try b.appendSlice("-3"),
        else => return,
    }
    switch (p.case) {
        .nominative => try b.append('N'),
        .accusative => try b.append('A'),
        .genitive => try b.append('G'),
        .dative => try b.append('D'),
        .vocative => try b.append('V'),
        else => return,
    }
    switch (p.number) {
        .singular => try b.append('S'),
        .plural => try b.append('P'),
        else => return,
    }
    if (p.crasis) {
        try b.appendSlice("-K");
    }

    return;
}

inline fn append_ref(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    try append_person(p, b);
    switch (p.tense_form) {
        .ref_singular => try b.append('S'),
        .ref_plural => try b.append('P'),
        else => return,
    }
}

fn append_cng(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    switch (p.case) {
        .nominative => try b.appendSlice("-N"),
        .accusative => try b.appendSlice("-A"),
        .genitive => try b.appendSlice("-G"),
        .dative => try b.appendSlice("-D"),
        .vocative => try b.appendSlice("-V"),
        else => return,
    }
    switch (p.number) {
        .singular => try b.append('S'),
        .plural => try b.append('P'),
        else => return,
    }
    switch (p.gender) {
        .masculine => try b.append('M'),
        .feminine => try b.append('F'),
        .neuter => try b.append('N'),
        .masculine_feminine => try b.append('C'),
        .unknown => try b.appendSlice("-U"),
    }
}

inline fn append_vp(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    switch (p.tense_form) {
        .present => try b.appendSlice("-P"),
        .imperfect => try b.appendSlice("-I"),
        .future => try b.appendSlice("-F"),
        .aorist => try b.appendSlice("-A"),
        .perfect => try b.appendSlice("-R"),
        .pluperfect => try b.appendSlice("-L"),
        else => return,
    }
    switch (p.voice) {
        .active => try b.append('A'),
        .middle => try b.append('M'),
        .passive => try b.append('P'),
        .middle_or_passive => try b.append('E'),
        .middle_deponent => try b.append('D'),
        .passive_deponent => try b.append('O'),
        .middle_or_passive_deponent => try b.append('N'),
        else => return,
    }
    switch (p.mood) {
        .indicative => try b.append('I'),
        .subjunctive => try b.append('S'),
        .optative => try b.append('O'),
        .imperative => try b.append('M'),
        .infinitive => try b.append('N'),
        .participle => try b.append('P'),
        else => return,
    }
    switch (p.person) {
        .first => try b.appendSlice("-1"),
        .second => try b.appendSlice("-2"),
        .third => try b.appendSlice("-3"),
        else => return,
    }
    switch (p.number) {
        .singular => try b.append('S'),
        .plural => try b.append('P'),
        else => return,
    }
}

inline fn append_flag(p: parsing.Parsing, b: *std.ArrayList(u8)) !void {
    if (p.correlative) {
        try b.appendSlice("-K");
    }
    if (p.crasis) {
        try b.appendSlice("-K");
    }
    if (p.negative) {
        try b.appendSlice("-N");
    }
    if (p.interrogative) {
        try b.appendSlice("-I");
    }
}

const expectEqual = std.testing.expectEqual;
const expectEqualStrings = std.testing.expectEqualStrings;
//const expectError = std.testing.expectError;

test "simple byz string tests" {
    const allocator = std.heap.page_allocator;
    // Some basic sanity checks.
    {
        const i = try byz_string(parsing.Parsing{
            .part_of_speech = .noun,
            .case = .nominative,
            .number = .singular,
            .gender = .masculine,
        }, allocator);
        defer i.deinit();
        try expectEqualStrings("N-NSM", i.items);
    }

    {
        const i = try byz_string(parsing.Parsing{
            .part_of_speech = .adjective,
            .case = .genitive,
            .number = .plural,
            .gender = .feminine,
        }, allocator);
        defer i.deinit();
        try expectEqualStrings("A-GPF", i.items);
    }

    {
        const i = try byz_string(parsing.Parsing{
            .part_of_speech = .verb,
            .tense_form = .present,
            .voice = .active,
            .mood = .indicative,
            .person = .first,
            .number = .plural,
        }, allocator);
        defer i.deinit();
        try expectEqualStrings("V-PAI-1P", i.items);
    }
}

const parse = @import("parse.zig").parse;

test "byz data test" {
    const allocator = std.heap.page_allocator;

    //const byz_data = "N-GSF\nT-APN";
    const byz_data = @embedFile("data/byz-parsing.txt");
    var items = std.mem.tokenizeAny(u8, byz_data, " \r\n");
    while (items.next()) |item| {
        const x = try parse(item);
        const y = try byz_string(x, allocator);
        defer y.deinit();
        try expectEqualStrings(item, y.items);
    }

    //const nestle_data = "T-APN\nA-NSN";
    const nestle_data = @embedFile("data/nestle-parsing.txt");
    items = std.mem.tokenizeAny(u8, nestle_data, " \r\n");
    while (items.next()) |item| {
        const x = try parse(item);
        const y = try byz_string(x, allocator);
        defer y.deinit();
        try expectEqualStrings(item, y.items);
    }
}
