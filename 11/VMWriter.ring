Class VMWriter
    file
    
    # Constructor
    func init outputPath
        file = fopen(outputPath, "w")
    
    # 1. WritePush - Writes a VM push command
    func writePush segment, index
        fwrite(file, "push " + segment + " " + string(index) + nl)
    
    # 2. WritePop - Writes a VM pop command  
    func writePop segment, index
        fwrite(file, "pop " + segment + " " + string(index) + nl)
    
    # 3. WriteArithmetic - Writes a VM arithmetic command
    func writeArithmetic command
        fwrite(file, command + nl)
        # command can be: add, sub, neg, eq, gt, lt, and, or, not
    
    # 4. WriteLabel - Writes a VM label command
    func writeLabel label
        fwrite(file, "label " + label + nl)
    
    # 5. WriteGoto - Writes a VM goto command
    func writeGoto label
        fwrite(file, "goto " + label + nl)
    
    # 6. WriteIf - Writes a VM if-goto command
    func writeIf label
        fwrite(file, "if-goto " + label + nl)
    
    # 7. WriteCall - Writes a VM call command
    func writeCall name, nArgs
        fwrite(file, "call " + name + " " + string(nArgs) + nl)
    
    # 8. WriteFunction - Writes a VM function command
    func writeFunction name, nLocals
        fwrite(file, "function " + name + " " + string(nLocals) + nl)
    
    # Additional helper method - WriteReturn
    func writeReturn
        fwrite(file, "return" + nl)
    
    # Close the output file
    func close
        if file != NULL
            fclose(file)
        ok

# Usage Example:
/*
load "vmwriter.ring"

vmWriter = new VMWriter("output.vm")
vmWriter.writePush("local", 0)
vmWriter.writePush("constant", 5)
vmWriter.writeArithmetic("add")
vmWriter.writePop("local", 0)
vmWriter.writeReturn()
vmWriter.close()
*/