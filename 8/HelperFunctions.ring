// ===============================================
// File: HelperFunctions.ring
// Description: A collection of utility functions
//              to be reused across the VM translator
//              project in Ring language.
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
/// (e.g. "vm", "asm") in the given directory
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
