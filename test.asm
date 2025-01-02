                    .MODEL SMALL
;----------------------------------------------------------;
;DEFINE MACROS HERE 
;------;
;GLOBAL;
;------;
PrintString MACRO addr
    push ax
    push dx
    lea dx, addr
    mov ah, 9
    int 21h
    pop dx
    pop ax
ENDM

PrintChar MACRO char
    push ax
    push dx
    mov dl, char
    mov ah, 2
    int 21h
    pop dx
    pop ax
ENDM




;------;
;ADRITA;
;------;
NumLength MACRO num
    local NumLengthEnd
    push ax
    mov ax, num
    
    mov temp, 1           ; Default to 1 digit
    mov bx, 1d           ; Default divisor for 1 digit
    cmp ax, 9            ; Is REM <= 9?
    jle NumLengthEnd      ; If yes, done

    mov temp, 2           ; 2 digits
    mov bx, 10d
    cmp ax, 99
    jle NumLengthEnd

    mov temp, 3           ; 3 digits
    mov bx, 100d
    cmp ax, 999
    jle NumLengthEnd

    mov temp, 4           ; 4 digits
    mov bx, 1000d
    cmp ax, 9999
    jle NumLengthEnd

    mov temp, 5           ; 5 digits
    mov bx, 10000d

    NumLengthEnd:
    pop ax
ENDM

PrintRow MACRO id, mrk, grd, cgp
    push ax
    push dx
    push cx
    push bx
    push si

    ; Print the left border
    PrintString column_separator

    ; Print Student ID (padded to 19 characters)

    mov dh, 0
    mov dl, id
    NumLength dx
    ;left padding
    mov cx, 19          ; Total column width for Student ID
    sub cl, temp        ; Subtract digit count in TEMP
    call PrintSpaces    ; Print left padding depending on cx
    mov al, id
    mov ah, 0
    mov rem, ax
    call PrintDigits

    ; Print Marks (padded to 19 characters)
    PrintString column_separator
    mov dh, 0
    mov dl, mrk
    NumLength dx
    ;left padding
    mov cx, 19          ; Total column width for Student ID
    sub cl, temp        ; Subtract digit count in TEMP
    call PrintSpaces    ; Print left padding depending on cx
    mov al, mrk
    mov ah, 0
    mov rem, ax
    call PrintDigits

    ; Print Grade (padded to 19 characters)
    PrintString column_separator
    mov cx, 18
    call PrintSpaces
    PrintChar grd
    
    
    ; Print CGPA (padded to 18 characters)
    PrintString column_separator
    mov cx, 14
    call PrintSpaces
    
    ; Step 1: Calculate the integer part
    mov ax, cgp               ; Load CGPA value (375 for example)
    mov bl, 100               ; Divisor
    int 3h
    div bl                    ; AX / BX -> Quotient in AL (integer part), Remainder in AH
    
    add al, '0'               ; Convert integer part to ASCII
    PrintChar al              ; Print integer part
    PrintChar '.'             ; Print the decimal point
    
    ; Step 2: Print the fractional part (remainder)
    mov dl, ah                ; Move remainder (AH) to DL (8-bit to 8-bit is valid)
    mov dh, 0                 ; Clear AH to prepare for division
    mov bx, 10d
    mov rem, dx 
    call PrintDigits
    
        
    
    ; Print right border
    PrintString column_separator
    pop si
    pop bx
    pop cx
    pop dx
    pop ax
ENDM



;------;
;DIPITA;
;------;
; Placeholder for Dipita's macros

;---;
;MIM;
;---;
; Placeholder for Mim's macros

;------------------------x---------------------------------;
.STACK 100H

.DATA
; Variables, strings and arrays
;----------------------------------------------------------;
;INITIALIZE ARRAYS HERE
max_students db 50          ; Maximum number of students

student_ids db 50 dup(0)    ; Array for Student IDs
marks db 50 dup(0)          ; Array for Marks
grades db 50 dup('?')       ; Array for Grades
cgpa dw 50 dup(0)           ; Array for cgpa
;------------------------x---------------------------------;



;----------------------------------------------------------;
;INITIALIZE STRINGS HERE
header db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "|    Student ID     |       Marks       |       Grade       |       CGPA       |", 0Dh, 0Ah, "$"
separator db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
footer db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
 
average_label db "Class Average: $"
num_students_label db "Total Students: $"
column_separator db "|$"


gap1 db "                $"
welcome db "Welcome to the classroom grading system$"
newline db 0Dh, 0Ah, "$"
id_inp db "Enter Student's ID: $"
indent db "                    $"  
indent2 db "                       $"
marks_inp db "Enter Student's marks: $"      
err db " (Please provide valid marks) $"

msg1 db "After sorting by marks: ", 0Dh, 0Ah, "$"
;------------------------x---------------------------------; 



;----------------------------------------------------------;
;INITIALIZE VARIABLES HERE
temp db ?                  ; Temporary variable for calculations
rem dw ?
student_count db ?         ; Actual number of students (input by the user)


tempID db ?
tempMarks db ?
tempGrade db ?
tempCGPA dw ?                     ; Changed to word
;------------------------x---------------------------------;



.CODE
;----------------------------------------------------------;
;MAIN PROCEDURE HERE
MAIN PROC
    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Enter your code here
    ;------;
    ;GLOBAL;
    ;------;



    ;------;
    ;DIPITA;
    ;------;
    ; Display gap1
    lea dx, gap1
    mov ah, 9
    int 21h
    
    ; Display welcome message
    lea dx, welcome
    mov ah, 9
    int 21h
    
    ; Add a newline
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Prompt user for number of students
    mov cx, 0            ; Clear CX
    mov ah, 1
    int 21h
    sub al, 30h          ; Convert ASCII to numeric
    mul cx
    mov cl, al           ; Read tens place
    mov ah, 1
    int 21h
    sub al, 30h
    add cl, al           ; Combine digits
    mov student_count, cl ; Store student count
    jmp Adrita
    ; Validate student_count
    mov al, student_count ; Load student_count into AL
    cmp al, max_students  ; Compare AL (student_count) with max_students
    jle valid_count       ; Jump if less than or equal to max_students
    mov al, max_students  ; Cap student_count to max_students
    mov student_count, al ; Store capped value back
    
    valid_count:
    
    ; Initialize variables
    mov si, 0            ; Index for IDs and marks
    mov ch, 0
    mov cl, student_count ; Loop for number of students
    
    ; Input Student IDs
    lea dx, newline
    mov ah, 9
    int 21h
    
    lea dx, id_inp
    mov ah, 9
    int 21h
    
    input_ids:
    mov ax, 0            ; Clear AX (to hold final result)
    mov bl, 10
    mov bh, 0            ; Multiplier for tens place
    
    ; Read tens place
    mov ah, 1
    int 21h
    sub al, 30h          ; Convert ASCII to numeric
    mul bl
    mov bx, ax
    
    ; Read units place
    mov ah, 1
    int 21h
    sub al, 30h
    add bx, ax
    
    ; Store the ID
    mov student_ids[si], bl
    
    lea dx, newline
    mov ah, 9
    int 21h
    
    lea dx, indent
    mov ah, 9
    int 21h
    
    add si, 1            ; Move to next ID slot
    loop input_ids
    
    ; Input Marks
    lea dx, newline
    mov ah, 9
    int 21h
    
    lea dx, marks_inp
    mov ah, 9
    int 21h
    
    mov si, 0            ; Reset index for marks
    mov ch, 0
    mov cl, student_count ; Loop for number of students
    
    input_marks:
    mov ax, 0            ; Clear AX (to hold final result)
    mov bl, 100          ; Multiplier for hundreds place
    
    ; Read hundreds place
    mov ah, 1
    int 21h
    sub al, 30h          ; Convert ASCII to numeric
    mul bl
    mov dx, ax
    
    ; Read tens place
    mov bl, 10
    mov ah, 1
    int 21h
    sub al, 30h
    mul bl
    add dx, ax
    
    ; Read units place
    mov ah, 1
    int 21h
    sub al, 30h
    add dx, ax
    
    ; Store the Marks
    mov marks[si], dl
    
    lea dx, newline
    mov ah, 9
    int 21h
    
    lea dx, indent2
    mov ah, 9
    int 21h
    
    inc si
    loop input_marks
    
    ; Add a newline before displaying grades
    lea dx, newline
    mov ah, 9
    int 21h
    
    ;---;
    ;MIM;
    ;---;
    ; Assign letter grades and CGPA based on marks
    MOV CH, 0
    MOV CL, student_count        ; Loop for the number of students
    MOV SI, 0                    ; Starting index
assign_grades_and_cgpa:
    MOV AL, marks[SI]            ; Load marks into AL register
    CMP AL, 80
    JGE grade_A
    CMP AL, 70
    JGE grade_B
    CMP AL, 60
    JGE grade_C
    CMP AL, 50
    JGE grade_D
    MOV grades[SI], 'F'          ; If below 50, grade is 'F'
    MOV cgpa[SI+SI], 0   ; CGPA = 0.0
    JMP next_student

grade_A:
    MOV grades[SI], 'A'
    MOV cgpa[SI+SI], 400d ; CGPA = 4.00 (scaled by 100)
    JMP next_student

grade_B:
    MOV grades[SI], 'B'
    MOV cgpa[SI+SI], 300d ; CGPA = 3.00
    JMP next_student

grade_C:
    MOV grades[SI], 'C'
    MOV cgpa[SI+SI], 200d ; CGPA = 2.00
    JMP next_student

grade_D:
    MOV grades[SI], 'D'
    MOV cgpa[SI+SI], 100d ; CGPA = 1.00

next_student:
    INC SI
    LOOP assign_grades_and_cgpa
    ;call DisplayGrades
;-------------------------------------------------------------------------------------------    
;    push cx
;    push ax
;    push dx
;    mov ch, 0
;    mov cl, student_count   ; Use student_count to determine loop count
;    mov si, 0               ; Start index for CGPA array
;    print_cgpa_loop:
;    mov ax, cgpa[si]        ; Load CGPA value (word)
;    mov rem, ax             ; Store in rem for digit processing
;    NumLength ax            ; Calculate number length
;    call PrintDigits        ; Print the digits
;
;    lea dx, newline         ; Add newline after each CGPA
;    mov ah, 9
;    int 21h
;
;    add si, 2               ; Increment index for word-sized array
;    loop print_cgpa_loop
;    pop dx
;    pop ax
;    pop cx
;----------------------------------------------------------------------------------------------

    ; Bubble Sort Algorithm to sort by marks
    MOV CH, 0
    MOV CL, student_count        ; Outer loop: number of students - 1 iterations
    DEC CX                       ; Reduce by 1 for sorting passes
outer_loop:
    MOV SI, 0                    ; Start from the first student
    MOV DI, 1                    ; Compare with the next student
    MOV BH, 0
    MOV BL, student_count
    DEC BX                       ; Number of comparisons in each pass
inner_loop:
    MOV AL, marks[SI]
    MOV AH, marks[DI]
    CMP AL, AH
    JG swap_elements             ; If marks[SI] > marks[DI], swap

next_iteration:
    INC SI
    INC DI
    DEC BX
    JNZ inner_loop

    DEC CX
    JNZ outer_loop

exit_program:
    PrintString msg1
    jmp Adrita

swap_elements:
    ; Swap marks
    MOV AL, marks[SI]
    MOV tempMarks, AL
    MOV AL, marks[DI]
    MOV marks[SI], AL
    MOV AL, tempMarks
    MOV marks[DI], AL

    ; Swap student ID
    MOV AL, student_ids[SI]
    MOV tempID, AL
    MOV AL, student_ids[DI]
    MOV student_ids[SI], AL
    MOV AL, tempID
    MOV student_ids[DI], AL

    ; Swap grades
    MOV AL, grades[SI]
    MOV tempGrade, AL
    MOV AL, grades[DI]
    MOV grades[SI], AL
    MOV AL, tempGrade
    MOV grades[DI], AL

    ; Swap CGPA
    MOV AX, cgpa[SI+SI]
    MOV tempCGPA, AX
    MOV AX, cgpa[DI+DI]
    MOV cgpa[SI+SI], AX
    MOV AX, tempCGPA
    MOV cgpa[DI+DI], AX

    ; Return to inner loop
    JMP next_iteration    

Adrita:
    ;------;
    ;ADRITA;
    ;------;
;-------------------------------------------------------------------------------------------    
;    push cx
;    push ax
;    push dx
;    mov ch, 0
;    mov cl, student_count   ; Use student_count to determine loop count
;    mov si, 0               ; Start index for CGPA array
;    print_cgpa:
;    mov ax, cgpa[si]        ; Load CGPA value (word)
;    mov rem, ax             ; Store in rem for digit processing
;    NumLength ax            ; Calculate number length
;    call PrintDigits        ; Print the digits
;
;    lea dx, newline         ; Add newline after each CGPA
;    mov ah, 9
;    int 21h
;
;    add si, 2               ; Increment index for word-sized array
;    loop print_cgpa
;    pop dx
;    pop ax
;    pop cx
;----------------------------------------------------------------------------------------------
    ; Initialize student data
    call InitializeData

    ; Display the grades and summary
    call DisplayGrades
    
    PrintString average_label
    ; Calculate the average
    call CalcAverage
    
    
    
    
        
    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
;------------------------x---------------------------------;




;----------------------------------------------------------;
;DEFINE PROCEDURES HERE

;------;
;GLOBAL;
;------;
; Initialize data (dummy data for testing)
; Initialize data (dummy data for testing)
InitializeData PROC
    push ax
    push bx
    push si
    xor si, si             ; Array index
    mov ch, 0h
    mov cl, student_count  ; Number of students
    mov bx, 356d           ; Initialize BX with the starting CGPA value (375d)
    
    InitLoop:
        mov ax, si
        mov student_ids[si], al ; Assign Student ID as the index
        mov marks[si], al       ; Assign marks (example values)
        mov grades[si], 'A'     ; Assign grade (example values)
        ; Initialize CGPA array
        mov cgpa[si+si], bx      ; Assign the full word (BX) to cgpa array
        inc bx                  ; Increment BX for the next CGPA value
        push bx
        mov bx, cgpa[si+si]
        int 3h
        pop bx
        inc si
        loop InitLoop
    pop si    
    pop bx
    pop ax
    ret
InitializeData ENDP




;------;
;ADRITA;
;------;
; Procedure to calculate average
CalcAverage PROC
    push ax               ; Save registers
    push bx
    push cx
    push dx
    push si

    mov ax, 0             ; Initialize sum (AX = 0)
    mov ch, 0
    mov cl, student_count ; Set loop counter (number of students)
    mov si, offset marks  ; Point SI to the start of the marks array

    SumLoop:
        mov bl, [si]          ; Load current mark into BX
        mov bh, 0
        add ax, bx            ; Add BX to the running total (AX)
        inc si             ; Move to the next mark (each mark is 2 bytes)
        loop SumLoop          ; Repeat until all students are processed

    ; AX now contains the total sum of the marks
    mov dx, 0
    mov bh, 0
    mov bl, student_count
    div bx
    ;AX now contains the quotient i.e. the decimal values
    mov rem, ax     
    NumLength ax       ;sets bx and temp
    call PrintDigits      ; Print the total sum
    PrintChar '.'
    
    ; Calculate and print the fractional part
    mov ax, dx            ; Load the remainder into AX
    mov bx, 100           ; Multiply remainder by 100 to get fractional part
    mul bx
    mov bh, 0
    mov bl, student_count ; Divide by student count
    div bx                ; AX = fractional part (two digits), DX = remainder

    ; Print the fractional part
    mov rem, ax           ; Store the fractional part in `rem`
    NumLength ax          ; Calculate the number of digits
    call PrintDigits      ; Print the fractional part

    ; Restore registers
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
CalcAverage ENDP


; Procedure to display grades
DisplayGrades PROC
    push ax
    push dx
    push si
    push cx

    ; Display header and separator
    PrintString header
 

    ; Initialize array index and student count
    xor si, si                ; Array index
    mov ch, 0h
    mov cl, student_count     ; Number of students
    

    ; Iterate through student data
    DisplayLoop:
        PrintString separator
        PrintRow student_ids[si], marks[si], grades[si], cgpa[si+si]
        inc si
        loop DisplayLoop
        
    ; Display the footer
    PrintString footer

    ; Restore registers and return
    pop cx
    pop si
    pop dx
    pop ax
    ret
DisplayGrades ENDP

PrintSpaces PROC
    ; Input: CX = number of spaces to print
    
    push ax
    push dx

    mov dl, ' '        ; Space character
    SpaceLoop:
        mov ah, 2
        int 21h
        loop SpaceLoop

    pop dx
    pop ax
    ret
PrintSpaces ENDP


PrintDigits PROC
    ;store required bx beforehand
    push ax
    push dx
    push bx


    PrintDigitsLoop:
        ; 32-bit division setup
        mov ax, rem
        mov dx, 0
        div bx              ; Quotient in AX, remainder in DX
        mov rem, dx         ; Update remainder
    
        ; Print the digit
        mov dl, al
        add dl, '0'
        mov ah, 2
        int 21h
    
    
        ; Update divisor (BX /= 10)
        mov ax, bx
        mov dx, 0
        
        mov bx, 10
        div bx
        mov bx, ax          ; Updated divisor
    
        cmp bx, 0
        jg PrintDigitsLoop  ; Loop until divisor becomes 0

    pop bx
    pop dx
    pop ax
    ret
PrintDigits ENDP

;------;
;DIPITA;
;------;
; Placeholder for Dipita's procedures

;---;
;MIM;
;---;
; Placeholder for Mim's procedures

;------------------------x---------------------------------;
END MAIN