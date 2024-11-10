/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.logging;
import numem.all;
import numem.format;

/**
    Write to log
*/
void nuvkLogDebug(Args...)(const(char)* fmt, Args args) @nogc {
    debug {
        if (&nuvkLogSink) {
            nstring str = fmt.format(args);
            nuvkLogSink("[Nuvk::Debug] {0}".format(str));
        }
    }
}

/**
    Write to log
*/
void nuvkLogInfo(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = fmt.format(args);
        nuvkLogSink("[Nuvk::Info] {0}".format(str));
    }
}

/**
    Write to log
*/
void nuvkLogWarning(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = fmt.format(args);
        nuvkLogSink("[Nuvk::Warning] {0}".format(str));
    }
}

/**
    Write to log
*/
void nuvkLogError(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = fmt.format(args);
        nuvkLogSink("[Nuvk::Error] {0}".format(str));
    }
}

/**
    Nuvk enforce function
*/
pragma(inline, true)
void nuvkEnforce(T, Args...)(T input_, const(char)* fmt, Args args) @nogc {
    enforce(
        input_,
        fmt.format(args)
    );
}

/**
    The sink which should be written to.
*/
void function(nstring) @nogc nuvkLogSink = &nuvkDefaultSink;

/**
    The default sink.
*/
void nuvkDefaultSink(nstring text) @nogc {
    import core.stdc.stdio : printf;
    printf("%s\n", text.toCString());
}