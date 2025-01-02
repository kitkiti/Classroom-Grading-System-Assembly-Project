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
student_count db ?          ; Actual number of students (input by the user)
student_ids db 50 dup(0)    ; Array for Student IDs
marks db 50 dup(0)          ; Array for Marks
grades db 50 dup('?')       ; Array for Grades
cgpa dw 50 dup(0)           ; Array for cgpa
;------------------------x---------------------------------;



;----------------------------------------------------------;
;INITIALIZE STRINGS HERE
greeting db "Welcome to the Student Grading System!", 0Dh, 0Ah, "$"
header db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "|    Student ID     |       Marks       |       Grade       |       CGPA       |", 0Dh, 0Ah, "$"
separator db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
footer db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
 
average_label db "Class Average: $"
num_students_label db "Total Students: $"
column_separator db "|$"
;------------------------x---------------------------------; 



;----------------------------------------------------------;
;INITIALIZE VARIABLES HERE
temp db ?                  ; Temporary variable for calculations
rem dw ?
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
    PrintString greeting
    
    ; Prompt user for the number of students (only works for one byte - kept for testing)
    mov ah, 1             ; DOS function to take a single character input
    int 21h               ; Input student count
    sub al, 30h           ; Convert ASCII to numeric
    mov bl, 10
    mul bl
    mov bl, al
    mov ah, 1
    int 21h
    sub al, 30h
    add al, bl
    
    
    mov student_count, al ; Store the count
    
    PrintChar 0Dh
    PrintChar 0Ah
    
    
    ;---;
    ;MIM;
    ;---;
    ; Placeholder for Mim's main code

    ;------;
    ;DIPITA;
    ;------;
    ; Placeholder for Dipita's main code

    ;------;
    ;ADRITA;
    ;------;

    ; Initialize student data
    call InitializeData
    
    mov ax, 350d
    mov rem, ax
    NumLength ax
    call PrintDigits
    PrintChar 0Dh
    PrintChar 0Ah


    ; Display the grades and summary
    ;call DisplayGrades
    
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
    xor si, si             ; Array index
    mov ch, 0h
    mov cl, student_count  ; Number of students
    mov bx, 375d           ; Initialize BX with the starting CGPA value (375d)
    
    InitLoop:
        mov ax, si
        mov student_ids[si], al ; Assign Student ID as the index
        mov marks[si], al       ; Assign marks (example values)
        mov grades[si], 'A'     ; Assign grade (example values)
        
        ; Initialize CGPA array
        mov cgpa[si*2], bx      ; Assign the full word (BX) to cgpa array
        inc bx                  ; Increment BX for the next CGPA value
        
        inc si
        loop InitLoop
        
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
        PrintRow student_ids[si], marks[si], grades[si], cgpa[si*2]
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