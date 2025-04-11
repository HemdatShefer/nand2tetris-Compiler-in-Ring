// ===============================================
// File: HelperFunctions.ring
// Description: A collection of utility functions
//              to be reused across the VM translator
//              project in Ring language.
// Author: hemdat shefer
// ===============================================

///.......................................
/// Splits a string by a given separator and returns a list of parts.
/// Works like the built-in split function in python
///.......................................
func my_split(str, sep) {
    new_str = ""
    result = []
    
    for i in str
        if i = sep
            result + new_str
            new_str = ""
        else
            new_str += i
        ok
	next 
    
    result + new_str
    return result
}
