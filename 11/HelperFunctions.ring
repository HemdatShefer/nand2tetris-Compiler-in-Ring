// ===============================================
// File: HelperFunctions.ring
// Description: A collection of utility functions
//              to be reused across the VM translator
//              and Jack analyzer projects in Ring language.
// ===============================================

///.......................................
/// Splits a string by a given separator.
/// Like Python's split() function.
///.......................................
func my_split(str, sep)
    new_str = ""
    result = []

    for i in str
        if i = sep
            add(result, new_str)
            new_str = ""
        else
            new_str += i
        ok
    next 

    add(result, new_str)
    return result
end

///.......................................
/// Recursively finds all files with a given extension
/// (e.g. "vm", "asm", "jack") in the given directory
///.......................................
func findFilesWithExtension(path, fileExtension)
    fileList = []
    dirContent = dir(path)

    if dirContent = 0
        see "ERROR: Could not open directory: " + path + nl
        return fileList
    ok

    for entry in dirContent
        name = entry[1]
        isDir = entry[2]
        fullpath = path + "\" + name

        if isDir
            Add(fileList, findFilesWithExtension(fullpath, fileExtension), true)
        else
            parts = my_split(name, ".")
            if len(parts) > 1
                ext = lower(parts[len(parts)])
                if ext = lower(fileExtension)
                    add(fileList, fullpath)
                ok
            ok
        ok
    next

    return fileList
end

///.......................................
/// Wrapper for finding all `.vm` files
///.......................................
func findVMFiles(path)
    return findFilesWithExtension(path, "vm")
end

///.......................................
/// Wrapper for finding all `.jack` files
///.......................................
func findJackFiles(path)
    return findFilesWithExtension(path, "jack")
end

///.......................................
/// Changes file extension from old to new
/// (e.g. MyFile.vm → MyFile.asm)
///.......................................
func changeFileExtension(filePath, oldExtension, newExtension)
    parts = my_split(filePath, "\\")
    filename = parts[len(parts)]
    folderLength = len(filePath) - len(filename)
    folderPath = left(filePath, folderLength)

    nameParts = my_split(filename, ".")
    if len(nameParts) > 1
        ext = nameParts[len(nameParts)]
        if lower(ext) = lower(oldExtension)
            baseName = ""
            for i = 1 to len(nameParts)-1
                baseName += nameParts[i]
                if i < len(nameParts)-1
                    baseName += "."
                ok
            next
            return folderPath + baseName + "." + newExtension
        else
            return filePath  // Extension doesn't match
        ok
    else
        return filePath  // No extension found
    ok
end

// This function changes .vm to .asm in file name
func getAsmFilePath(vmFilePath)
    parts = my_split(vmFilePath, "\")                // Split path
    filename = parts[len(parts)]                      // Get file name
    folderLength = len(vmFilePath) - len(filename)    // Get length without file name
    folderPath = left(vmFilePath, folderLength)       // Get folder path
    baseName = left(filename, len(filename) - 3)      // Remove ".vm"
    return folderPath + baseName + ".asm"             // Add ".asm"
end



///.......................................
/// Checks if a directory contains any `.vm` files.
/// Returns true if at least one `.vm` file is found.
///.......................................
func hasVMFiles(path)
    list = dir(path)
    for item in list
        name = lower(item[1])
        isDir = item[2]
        if not isDir and right(name, 3) = ".vm"
            see "Found VM file: " + name + " in " + path + nl
            return true
        ok
    next
    return false
end


///.......................................
/// Checks if a directory contains a `Sys.vm` file.
/// Returns true if `Sys.vm` is found.
///.......................................
func hasSysVm(path)
    list = dir(path)
    for item in list
        name = lower(item[1])
        isDir = item[2]
        if not isDir and name = "sys.vm"
            return true
        ok
    next
    return false
end



///.......................................
/// Creates a `Sys.vm` file in the given path
/// if it doesn't already exist.
/// This file is used for VM initialization.
/// It contains a function `Sys.init` that calls `Main.main`.
///.......................................  
func createSysVm(path)
    see "Checking for Sys.vm in: " + path + nl

    if hasVMFiles(path) and not hasSysVm(path)
        sysPath = path + "\\Sys.vm"
        see "Creating Sys.vm in folder: " + path + nl
        sysFile = fopen(sysPath, "w")
        if sysFile = 0
            see "ERROR: Could not create Sys.vm at " + sysPath + nl
            return
        ok
        fwrite(sysFile, "function Sys.init 0"+nl)
        fwrite(sysFile, "call Main.main 0"+nl)
        fwrite(sysFile, "return"+nl)
        fclose(sysFile)
    else
        if hasSysVm(path)
            see "Sys.vm already exists in: " + path + nl
        ok
    ok
end

///.......................................
/// Recursively ensures that `Sys.vm` exists
/// in the given directory and all its subdirectories.
/// If `Sys.vm` is missing, it creates it.
///.......................................
func ensureSysVm(path)
    createSysVm(path)

    // Recursively check subdirectories
    list = dir(path)
    for item in list
        name = item[1]
        isDir = item[2]
        if isDir
            ensureSysVm(path + "\\" + name)
        ok
    next
end




///.......................................
/// Character type checking functions
///.......................................
func isdigit(ch)
    asciiVal = ascii(ch)
    return asciiVal >= 48 and asciiVal <= 57  # '0' to '9'
end

func isalpha(ch)
    asciiVal = ascii(ch)
    return (asciiVal >= 65 and asciiVal <= 90) or (asciiVal >= 97 and asciiVal <= 122)  # A-Z or a-z
end

func isalnum(ch)
    return isalpha(ch) or isdigit(ch)
end

func cleanString(str)
    cleaned = ""
    for i = 1 to len(str)
        ch = substr(str, i, 1)
        asciiVal = ascii(ch)
        if asciiVal >= 32 and asciiVal <= 126  # 32 = רווח רגיל, עד תווים מדפיסים
            cleaned += ch
        ok
    next
    return cleaned

# Helper function to get the directory name from a path
func getDirectoryName(path)
    parts = my_split(path, "\")                // Split path
    Dirname = parts[len(parts)]
    see "Dirname is : " + Dirname
    return Dirname
end

# Helper function to get base name without extension
func getBaseName(filePath)
    parts = my_split(filePath, "\")
    filename = parts[len(parts)]
    
    dotParts = my_split(filename, ".")
    if len(dotParts) > 1
        baseName = ""
        for i = 1 to len(dotParts)-1
            baseName += dotParts[i]
            if i < len(dotParts)-1
                baseName += "."
            ok
        next
        
        # Reconstruct path
        folderLength = len(filePath) - len(filename)
        if folderLength > 0
            folderPath = left(filePath, folderLength)
            return folderPath + baseName
        else
            return baseName
        ok
    ok
    return filePath
end