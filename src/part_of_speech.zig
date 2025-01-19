const std = @import("std");
const Parsing = @import("parsing.zig").Parsing;

pub const PartOfSpeech = enum(u5) {
    unknown = 0,
    particle = 1,
    verb = 2,
    noun = 3,
    adjective = 4,
    adverb = 5,
    conjunction = 6,
    proper_noun = 7,
    preposition = 8,
    conditional = 9,
    article = 10,
    interjection = 11,
    pronoun = 12,
    personal_pronoun = 13,
    possessive_pronoun = 14,
    relative_pronoun = 15,
    demonstrative_pronoun = 16,
    reciprocal_pronoun = 17,
    reflexive_pronoun = 18,
    transliteration = 19,
    hebrew_transliteration = 20,
    aramaic_transliteration = 21,
    letter = 22,
    numeral = 23,
    superlative_adjective = 24,
    superlative_adverb = 25,
    superlative_noun = 26,
    comparative_adjective = 27,
    comparative_adverb = 28,
    comparative_noun = 29,
};

// pos_to_string returns a capitalised English name for the part of
// speech with spaces between words.
pub fn pos_to_string(parsing: Parsing) []const u8 {
    return switch (parsing.part_of_speech) {
        .unknown => "",
        .particle => {
            if (parsing.interrogative) {
                return "Interrogative Particle";
            }
            return "Particle";
        },
        .verb => "Verb",
        .noun => "Noun",
        .adjective => "Adjective",
        .adverb => "Adverb",
        .conjunction => "Conjunction",
        .proper_noun => {
            if (parsing.interrogative) {
                return "Interrogative Proper Noun";
            }
            if (parsing.indeclinable) {
                return "Indeclinable Proper Noun";
            }
            return "Proper Noun";
        },
        .preposition => "Preposition",
        .conditional => "Conditional",
        .article => "Definite Article",
        .interjection => "Interjection",
        .pronoun => {
            if (parsing.interrogative) {
                return "Interrogative Pronoun";
            }
            if (parsing.indefinite) {
                return "Indefinite Pronoun";
            }
            return "Pronoun";
        },
        .personal_pronoun => "Personal Pronoun",
        .relative_pronoun => "Relative Pronoun",
        .reciprocal_pronoun => "Reciprocal Pronoun",
        .demonstrative_pronoun => "Demonstrative Pronoun",
        .reflexive_pronoun => "Reflexive Pronoun",
        .possessive_pronoun => "Possessive Pronoun",
        .transliteration => "Transliteration",
        .hebrew_transliteration => "Hebrew Transliteration",
        .aramaic_transliteration => "Aramaic Transliteration",
        .numeral => "Numeral",
        .letter => "Letter",
        .superlative_noun => "Superlative Noun",
        .superlative_adverb => "Superlative Adverb",
        .superlative_adjective => "Superlative Adjective",
        .comparative_noun => "Comparative Noun",
        .comparative_adverb => "Comparative Adverb",
        .comparative_adjective => "Comparative Adjective",
    };
}

// pos_to_camel_case returns a capitalised English name for the part of
// speech with no spaces between words.
pub fn pos_to_camel_case(parsing: Parsing) []const u8 {
    return switch (parsing.part_of_speech) {
        .unknown => "Unknown",
        .particle => {
            if (parsing.interrogative) {
                return "InterrogativeParticle";
            }
            return "Particle";
        },
        .verb => "Verb",
        .noun => "Noun",
        .adjective => "Adjective",
        .article => "DefiniteArticle",
        .adverb => "Adverb",
        .pronoun => {
            if (parsing.interrogative) {
                return "InterrogativePronoun";
            }
            if (parsing.indefinite) {
                return "IndefinitePronoun";
            }
            return "Pronoun";
        },
        .preposition => "Preposition",
        .conjunction => "Conjunction",
        .conditional => "Conditional",
        .interjection => "Interjection",
        .relative_pronoun => "RelativePronoun",
        .reciprocal_pronoun => "ReciprocalPronoun",
        .demonstrative_pronoun => "DemonstrativePronoun",
        .reflexive_pronoun => "ReflexivePronoun",
        .possessive_pronoun => "PosessivePronoun",
        .personal_pronoun => "PersonalPronoun",
        .proper_noun => {
            if (parsing.interrogative) {
                return "InterrogativeProperNoun";
            }
            if (parsing.indeclinable) {
                return "IndeclinableProperNoun";
            }
            return "ProperNoun";
        },
        .superlative_noun => "SuperlativeNoun",
        .superlative_adjective => "SuperlativeAdjective",
        .comparative_noun => "ComparativeNoun",
        .comparative_adjective => "ComparativeAdjective",
        .transliteration => "HebrewTransliteration",
        .hebrew_transliteration => "HebrewTransliteration",
        .aramaic_transliteration => "AramaicTransliteration",
        .numeral => "Numeral",
        .letter => "Letter",
        else => "",
    };
}

pub fn parse_pos(allocator: std.mem.Allocator, text: []const u8) !Parsing {
    const value = try std.ascii.allocLowerString(allocator, text);
    defer allocator.free(value);
    const hashmap = std.StaticStringMap(Parsing).initComptime(.{
        .{ "verb", .{ .part_of_speech = .verb } },
        .{ "noun", .{ .part_of_speech = .noun } },
        .{ "article", .{ .part_of_speech = .article } },
        .{ "definitearticle", .{ .part_of_speech = .article } },
        .{ "definite article", .{ .part_of_speech = .article } },
        .{ "definite-article", .{ .part_of_speech = .article } },
        .{ "definite_article", .{ .part_of_speech = .article } },
        .{ "adverb", .{ .part_of_speech = .adverb } },
        .{ "adjective", .{ .part_of_speech = .adjective } },
        .{ "pronoun", .{ .part_of_speech = .pronoun } },
        .{ "particle", .{ .part_of_speech = .particle } },
        .{ "preposition", .{ .part_of_speech = .preposition } },
        .{ "conjunction", .{ .part_of_speech = .conjunction } },
        .{ "conditional", .{ .part_of_speech = .conditional } },
        .{ "interjection", .{ .part_of_speech = .interjection } },
        .{ "relativepronoun", .{ .part_of_speech = .relative_pronoun } },
        .{ "relative pronoun", .{ .part_of_speech = .relative_pronoun } },
        .{ "relative-pronoun", .{ .part_of_speech = .relative_pronoun } },
        .{ "relative_pronoun", .{ .part_of_speech = .relative_pronoun } },
        //.{ "interrogativepronoun", .{ .part_of_speech = .interrogative_pronoun } },
        //.{ "interrogative pronoun", .{ .part_of_speech = .interrogative_pronoun } },
        //.{ "interrogative-pronoun", .{ .part_of_speech = .interrogative_pronoun } },
        //.{ "interrogative_pronoun", .{ .part_of_speech = .interrogative_pronoun } },
        //.{ "indefinitepronoun", .{ .part_of_speech = .indefinite_pronoun } },
        //.{ "indefinite pronoun", .{ .part_of_speech = .indefinite_pronoun } },
        //.{ "indefinite-pronoun", .{ .part_of_speech = .indefinite_pronoun } },
        //.{ "indefinite_pronoun", .{ .part_of_speech = .indefinite_pronoun } },
        .{ "reciprocalpronoun", .{ .part_of_speech = .reciprocal_pronoun } },
        .{ "reciprocal pronoun", .{ .part_of_speech = .reciprocal_pronoun } },
        .{ "reciprocal-pronoun", .{ .part_of_speech = .reciprocal_pronoun } },
        .{ "reciprocal_pronoun", .{ .part_of_speech = .reciprocal_pronoun } },
        .{ "demonstrativepronoun", .{ .part_of_speech = .demonstrative_pronoun } },
        .{ "demonstrative pronoun", .{ .part_of_speech = .demonstrative_pronoun } },
        .{ "demonstrative-pronoun", .{ .part_of_speech = .demonstrative_pronoun } },
        .{ "demonstrative_pronoun", .{ .part_of_speech = .demonstrative_pronoun } },
        .{ "reflexivepronoun", .{ .part_of_speech = .reflexive_pronoun } },
        .{ "reflexive pronoun", .{ .part_of_speech = .reflexive_pronoun } },
        .{ "reflexive-pronoun", .{ .part_of_speech = .reflexive_pronoun } },
        .{ "reflexive_pronoun", .{ .part_of_speech = .reflexive_pronoun } },
        .{ "possessivepronoun", .{ .part_of_speech = .possessive_pronoun } },
        .{ "possessive pronoun", .{ .part_of_speech = .possessive_pronoun } },
        .{ "possessive-pronoun", .{ .part_of_speech = .possessive_pronoun } },
        .{ "possessive_pronoun", .{ .part_of_speech = .possessive_pronoun } },
        .{ "personalpronoun", .{ .part_of_speech = .personal_pronoun } },
        .{ "personal pronoun", .{ .part_of_speech = .personal_pronoun } },
        .{ "personal-pronoun", .{ .part_of_speech = .personal_pronoun } },
        .{ "personal_pronoun", .{ .part_of_speech = .personal_pronoun } },
        .{ "propernoun", .{ .part_of_speech = .proper_noun } },
        .{ "proper noun", .{ .part_of_speech = .proper_noun } },
        .{ "proper-noun", .{ .part_of_speech = .proper_noun } },
        .{ "proper_noun", .{ .part_of_speech = .proper_noun } },
        //.{ "interrogativepropernoun", .{ .part_of_speech = .proper_noun, .interrogative = true } },
        //.{ "interrogative_proper_noun", .{ .part_of_speech = .proper_noun, .interrogative = true } },
        //.{ "interrogative proper noun", .{ .part_of_speech = .proper_noun, .interrogative = true } },
        //.{ "interrogative-proper-noun", .{ .part_of_speech = .proper_noun, .interrogative = true } },
        .{ "indeclinablepropernoun", .{ .part_of_speech = .proper_noun, .indeclinable = true } },
        .{ "indeclinable_proper_noun", .{ .part_of_speech = .proper_noun, .indeclinable = true } },
        .{ "indeclinable proper noun", .{ .part_of_speech = .proper_noun, .indeclinable = true } },
        .{ "indeclinable-proper-noun", .{ .part_of_speech = .proper_noun, .indeclinable = true } },
        .{ "transliteration", .{ .part_of_speech = .transliteration } },
        .{ "aramaic_transliteration", .{ .part_of_speech = .aramaic_transliteration } },
        .{ "aramaic-transliteration", .{ .part_of_speech = .aramaic_transliteration } },
        .{ "aramaic transliteration", .{ .part_of_speech = .aramaic_transliteration } },
        .{ "aramaictransliteration", .{ .part_of_speech = .aramaic_transliteration } },
        .{ "hebrewtransliteration", .{ .part_of_speech = .hebrew_transliteration } },
        .{ "hebrew_transliteration", .{ .part_of_speech = .hebrew_transliteration } },
        .{ "hebrew-transliteration", .{ .part_of_speech = .hebrew_transliteration } },
        .{ "hebrew transliteration", .{ .part_of_speech = .hebrew_transliteration } },
        .{ "superlativeadjective", .{ .part_of_speech = .superlative_adjective } },
        .{ "superlative adjective", .{ .part_of_speech = .superlative_adjective } },
        .{ "superlative-adjective", .{ .part_of_speech = .superlative_adjective } },
        .{ "superlative_adjective", .{ .part_of_speech = .superlative_adjective } },
        .{ "superlativenoun", .{ .part_of_speech = .superlative_noun } },
        .{ "superlative_noun", .{ .part_of_speech = .superlative_noun } },
        .{ "superlative-noun", .{ .part_of_speech = .superlative_noun } },
        .{ "superlative noun", .{ .part_of_speech = .superlative_noun } },
        .{ "superlativeadverb", .{ .part_of_speech = .superlative_adverb } },
        .{ "superlative_adverb", .{ .part_of_speech = .superlative_adverb } },
        .{ "superlative-adverb", .{ .part_of_speech = .superlative_adverb } },
        .{ "superlative adverb", .{ .part_of_speech = .superlative_adverb } },
        .{ "superlativeadjective", .{ .part_of_speech = .superlative_adjective } },
        .{ "comparative adjective", .{ .part_of_speech = .comparative_adjective } },
        .{ "comparative-adjective", .{ .part_of_speech = .comparative_adjective } },
        .{ "comparative_adjective", .{ .part_of_speech = .comparative_adjective } },
        .{ "comparativenoun", .{ .part_of_speech = .comparative_noun } },
        .{ "comparative_noun", .{ .part_of_speech = .comparative_noun } },
        .{ "comparative-noun", .{ .part_of_speech = .comparative_noun } },
        .{ "comparative noun", .{ .part_of_speech = .comparative_noun } },
        .{ "comparativeadverb", .{ .part_of_speech = .comparative_adverb } },
        .{ "comparative_adverb", .{ .part_of_speech = .comparative_adverb } },
        .{ "comparative-adverb", .{ .part_of_speech = .comparative_adverb } },
        .{ "comparative adverb", .{ .part_of_speech = .comparative_adverb } },
        .{ "numeral", .{ .part_of_speech = .numeral } },
        .{ "letter", .{ .part_of_speech = .letter } },
        .{ "unknown", .{ .part_of_speech = .unknown } },
    });
    const result = hashmap.get(value);
    if (result == null) {
        return .{};
    }
    return result.?;
}

//const expectEqual = std.testing.expectEqual;
const eq = @import("std").testing.expectEqual;
const seq = @import("std").testing.expectEqualStrings;

test "pos_to_string" {
    const allocator = std.testing.allocator;

    try seq("Numeral", pos_to_string(.{ .part_of_speech = .numeral }));
    try seq("Noun", pos_to_string(.{ .part_of_speech = .noun }));
    try eq(Parsing{ .part_of_speech = .proper_noun }, parse_pos(allocator, "Proper Noun"));
    try eq(Parsing{ .part_of_speech = .proper_noun }, parse_pos(allocator, "proper_noun"));
    try eq(Parsing{ .part_of_speech = .letter }, parse_pos(allocator, "letter"));
    try eq(Parsing{ .part_of_speech = .unknown }, parse_pos(allocator, "fishing"));

    inline for (comptime std.enums.values(PartOfSpeech)) |f| {
        const value = pos_to_string(.{ .part_of_speech = f });
        const reverse = try parse_pos(allocator, value);
        //std.debug.print("check {any} {any} {any}\n", .{ f, value, reverse.part_of_speech });
        try eq(f, reverse.part_of_speech);
    }
}
