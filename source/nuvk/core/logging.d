module nuvk.core.logging;
import numem.all;
import core.stdc.stdio;

private {
    nstring nuvkFormat(Args...)(const(char)* fmt, Args args) {
        nstring fmtString = nstring(snprintf(null, 0, fmt, args)+1);
        char* bufptr = cast(char*)fmtString.toCString();
        
        snprintf(bufptr, fmtString.size(), fmt, args);
        return fmtString;
    }
}

/**
    Write to log
*/
void nuvkLogDebug(Args...)(const(char)* fmt, Args args) @nogc {
    debug {
        if (&nuvkLogSink) {
            nstring str = nuvkFormat(fmt, args);
            str = nuvkFormat("[Nuvk::Debug] %s", str.toCString());
            nuvkLogSink(str);
        }
    }
}

/**
    Write to log
*/
void nuvkLogInfo(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = nuvkFormat(fmt, args);
        str = nuvkFormat("[Nuvk::Info] %s", str.toCString());
        nuvkLogSink(str);
    }
}

/**
    Write to log
*/
void nuvkLogWarning(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = nuvkFormat(fmt, args);
        str = nuvkFormat("[Nuvk::Warning] %s", str.toCString());
        nuvkLogSink(str);
    }
}

/**
    Write to log
*/
void nuvkLogError(Args...)(const(char)* fmt, Args args) @nogc {
    if (&nuvkLogSink) {
        nstring str = nuvkFormat(fmt, args);
        str = nuvkFormat("[Nuvk::Error] %s", str.toCString());
        nuvkLogSink(str);
    }
}

/**
    Nuvk enforce function
*/
pragma(inline, true)
void nuvkEnforce(T, Args...)(T input_, const(char)* fmt, Args args) @nogc {
    enforce(
        input_,
        nuvkFormat(fmt, args)
    );
}

/**
    The sink which should be written to.
*/
void function(ref nstring) @nogc nuvkLogSink = &nuvkDefaultSink;

/**
    The default sink.
*/
void nuvkDefaultSink(ref nstring text) @nogc {
    printf("%s\n", text.toCString());
}