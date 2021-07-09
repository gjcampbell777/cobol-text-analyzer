*> Program Created by Gregory Campbell

        identification division.
        program-id. wordStat.

        environment division.
        input-output section.
        file-control.
*>I set up the input and output files so the input file name is dynamic whereas the
*>output file is always created with the same name
        select input-file assign to dynamic fname
                organization is line sequential
                file status is inputFS.
        select output-file assign to "stats.txt"
                organization is line sequential
                file status is outputFS.

        data division.
        file section.
*>Declaration of all the variables used throughout the program
        fd input-file.
            01 finput      pic x(80).
        fd output-file. 
            01 foutput     pic x(80).

        working-storage section.
        77  endOfFile        pic 9        value 1.
        77  inputFS          pic xx.
        77  outputFS         pic xx.
        77  fname            pic x(30).

        01  numSent          pic s9(7)    comp.
        01  numWords         pic s9(7)    comp.
        01  numChar          pic s9(7)    comp.
        01  numNums          pic s9(7)    comp.
        01  linePos          pic s9(2)    comp.
        01  skip             pic s9(2)    comp.
        01  input-area.
           02 charScan         pic x        occurs 80 times.
         01  output-title.
           02  filler        pic x(20)    value "INPUT TEXT ANALYZED:".
        01 output-underline.
           02  filler        pic x(40)    
                    value "----------------------------------------".
           02  filler        pic x(40)    
                    value "----------------------------------------".
        01 output-area.
           02  filler        pic x        value space.
           02  out-line      pic x(80).
        01 output-stat-1.
           02  filler        pic x(20)    value "number of sentences=".
           02  outSent       pic -(7)9.
        01 output-stat-2.
           02  filler        pic x(16)    value "number of words=".
           02  outWords      pic -(7)9.
        01 output-stat-3.
           02  filler        pic x(16)    value "number of chars=".
           02  outChar       pic -(7)9.
        01 output-stat-4.
           02  filler        pic x(16)    value "number of nums=".
           02  outNums       pic -(7)9.
        01 output-stat-5.
           02  filler        pic x(33)    
                    value "average number of words/sentence=".
           02  averWordSent  pic -(4)9.9.
         01 output-stat-6.
           02  filler        pic x(31)    
                    value "average number of symbols/word=".
           02  averCharWord  pic -(4)9.9.
            
*>Program starts by asking the user to input the name of the file that will be analyzed
        procedure division.
            display "Input filename: ".
            accept fname.
            
*>checks if file exists, program ends if it doesnt exist
            open input input-file.    
            if inputFS not = "00"
                if inputFS = "35"
                    display "File not found: ", fname
                    stop run
                end-if
            end-if.
            
            open output output-file.
            
            write foutput from output-title after advancing 0 lines.
            
            compute numSent = 0.
            compute numWords = 0.
            compute numChar = 0.
            compute numNums = 0.
            
*> calls function that runs until the file is completely analyzed
            perform readFile
                until endOfFile is = 0.
            
*>stat values are moved into output variables and all output
*>is put onto the output file  
            compute outSent = numSent.
            compute outWords =  numWords.
            compute outChar = numChar.
            compute outNums = numNums.
            compute averWordSent = numWords / numSent.
            compute averCharWord = numChar / numWords.
            write foutput from output-underline after advancing 1 line.
            write foutput from output-stat-1 after advancing 1 line.
            write foutput from output-stat-2 after advancing 1 line.
            write foutput from output-stat-3 after advancing 1 line.
            write foutput from output-stat-4 after advancing 1 line.
            write foutput from output-stat-5 after advancing 1 line.
            write foutput from output-stat-6 after advancing 1 line.
            write foutput from output-underline after advancing 1 line.
                       
            close input-file.
            close output-file.
            
            display "Word Statistics generated to stats.txt".
            
            stop run.

*>function that goes through everyline of the file until end of file is reached
*>writes every line of this file into the output file
*>calls a function that looks at every character
        readFile.
           compute linePos = 81.
           read input-file into input-area 
               at end compute endOfFile = 0
           end-read.
           if endOfFile is not = 0
               move input-area to out-line
               write foutput from output-area after advancing 1 line
           end-if.
           compute linePos = 0.
           perform statCheck 
            until linePos is > 80 or endOfFile is = 0.

*>function looks at every character in the file in order to determine
*>what statistic can be found based on the character and possibly
*>the character in after it depending on the character
       statCheck.
           compute skip = 0.
           
           if charScan(linePos) is equal to space
               compute linePos = linePos + 1
               if charScan(linePos) is not equal to space
                   compute numWords = numWords + 1
               else 
                   compute skip = skip + 1
           else if charScan(linePos) is equal to "." or "!" or "?"
               compute numSent = numSent + 1
               compute linePOs = linePos + 1
           else if charScan(linePos) is numeric
               compute linePos = linePos + 1
               if charScan(linePos) is numeric
                    compute skip = skip + 1
                else
                    compute numNums = numNums + 1
           else if charScan(linePos) is not alphabetic
               compute linePos = linePos + 1
           else
               compute numChar = numChar + 1 
               compute linePos = linePos + 1.

       end-of-job. 

