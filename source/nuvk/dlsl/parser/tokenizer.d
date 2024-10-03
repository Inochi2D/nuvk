/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.dlsl.parser.tokenizer;
import numem.all;

enum DlslTokenType {
    keyword,
    attribute,
    identifier,
    openParen,
    closeParen,
    openCurly,
    closeCurly,
    openSquare,
    closeSquare
}

/**
    A token
*/
struct DlslToken {
    DlslTokenType type;
    string[] slice;
    size_t line;
    size_t column;
}

class DlslScanner {
@nogc:
private:
    nstring stream;
    weak_vector!DlslToken tokens;

public:

}