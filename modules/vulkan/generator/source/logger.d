module logger;

import std.stdio;

import core.sync.mutex : Mutex;

import consolecolors;


/** 
 * Stateful, thread-safe logger class.
 */
class Logger {
    private Mutex mutex;

    private int verbose;


    /** 
     * Construct a new logger instance with the given verbosity level.
     * 
     * Params:
     *   verbose = Verbosity level as obtained from command-line arguments.
     */
    this(int verbose) {
        mutex = new Mutex();
        this.verbose = verbose;
    }

    /** 
     * Log debug information at-and-above the specified verbosity level.
     * 
     * Params:
     *   level = The verbosity level at-and-above which this will be shown.
     *   fmt = The format string to append to our prefix for logging.
     *   args = Arguments to stringify and format into our output.
     */
    void dbg(Args...)(int level, string fmt, Args args) {
        debug if (verbose >= level) {
            mutex.lock();
            cwritefln("<grey>Debug</grey> " ~ fmt, args);
            mutex.unlock();
        }
    }

    /** 
     * Log regular information to the terminal. Always shown.
     * 
     * Params:
     *   fmt = The format string to append to our prefix for logging.
     *   args = Arguments to stringify and format into our output.
     */
    void info(Args...)(string fmt, Args args) {
        mutex.lock();
        cwritefln("<lcyan>Info</lcyan> " ~ fmt, args);
        mutex.unlock();
    }

    /** 
     * Log a warning message to the terminal. Always shown.
     * 
     * Params:
     *   fmt = The format string to append to our prefix for logging.
     *   args = Arguments to stringify and format into our output.
     */
    void warn(Args...)(string fmt, Args args) {
        mutex.lock();
        cwritefln(stderr, "<yellow>Warning</yellow> " ~ fmt, args);
        mutex.unlock();
    }

    /** 
     * Log an error message to the terminal. Always shown.
     * 
     * Params:
     *   fmt = The format string to append to our prefix for logging.
     *   args = Arguments to stringify and format into our output.
     */
    void err(Args...)(string fmt, Args args) {
        mutex.lock();
        cwritefln(stderr, "<red>Error</red> " ~ fmt, args);
        mutex.unlock();
    }

    /** 
     * Log an empty line to the terminal. Always shown.
     */
    void line() {
        mutex.lock();
        cwritefln("");
        mutex.unlock();
    }
}

/** Make our color escaping function visible and easy to use. */
enum esc = &escapeCCL;

static this() {
    version (Windows) {
        enableConsoleUTF8();
    }
}