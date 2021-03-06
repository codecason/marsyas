// Generated by Bisonc++ V4.04.01 on Sat, 30 Nov 2013 23:52:34 -0800

    // Include this file in the sources of the class Parser.

// $insert class.h
#include "parser.h"
#include <marsyas/common_source.h>

// $insert namespace-open
namespace Marsyas
{

inline void Parser::error(char const *msg)
{
    MRSERR("Script parser: Line " << d_scanner.lineNr() << ": " << msg);
}

// $insert lex
inline int Parser::lex()
{
    return d_scanner.lex();
}

inline void Parser::print()         
{
    print__();           // displays tokens if --print was specified
}

inline void Parser::exceptionHandler__(std::exception const &exc)         
{
    throw;              // re-implement to handle exceptions thrown by actions
}

// $insert namespace-close
}

    // Add here includes that are only required for the compilation 
    // of Parser's sources.


// $insert namespace-use
    // UN-comment the next using-declaration if you want to use
    // symbols from the namespace Marsyas without specifying Marsyas::
//using namespace Marsyas;

    // UN-comment the next using-declaration if you want to use
    // int Parser's sources symbols from the namespace std without
    // specifying std::

//using namespace std;
