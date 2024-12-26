pub const Parsing = packed struct(u32) {
    part_of_speech: PartOfSpeech = .unknown,
    tense_form: TenseForm = .unknown,
    mood: Mood = .unknown,
    ref_singular: bool = false,
    //ref_plural: bool = false,
    gender: Gender = .unknown,
    voice: Voice = .unknown,
    case: Case = .unknown,
    person: Person = .unknown,
    number: Number = .unknown,
    interrogative: bool = false,
    negative: bool = false,
    correlative: bool = false,
    indefinite: bool = false,
    indeclinable: bool = false,
    crasis: bool = false,
};

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

pub const TenseForm = enum(u4) {
    unknown = 0,
    present = 1,
    future = 2,
    aorist = 3,
    imperfect = 4,
    perfect = 5,
    pluperfect = 6,
    second_future = 7,
    second_aorist = 8,
    second_perfect = 9,
    second_pluperfect = 10,
};

pub const Voice = enum(u3) {
    unknown = 0,
    active = 1,
    middle = 2,
    passive = 3,
    middle_or_passive = 4,
    middle_deponent = 5,
    passive_deponent = 6,
    middle_or_passive_deponent = 7,
};

pub const Mood = enum(u3) {
    unknown = 0,
    indicative = 1,
    subjunctive = 2,
    optative = 3,
    imperative = 4,
    infinitive = 5,
    participle = 6,
};

pub const Gender = enum(u3) {
    unknown = 0,
    masculine = 1,
    feminine = 2,
    neuter = 3,
    masculine_feminine = 4,
};

pub const Person = enum(u2) {
    unknown = 0,
    first = 1,
    second = 2,
    third = 3,
};

pub const Number = enum(u2) {
    unknown = 0,
    singular = 1,
    dual = 2,
    plural = 3,
};

pub const Case = enum(u3) {
    unknown = 0,
    nominative = 1,
    accusative = 2,
    genitive = 3,
    dative = 4,
    vocative = 5,
};

test "packed parsing" {
    var p: Parsing = .{
        .part_of_speech = .noun,
    };
    p.person = .first;
    var p2: Parsing = .{};
    p2.person = .first;
}
