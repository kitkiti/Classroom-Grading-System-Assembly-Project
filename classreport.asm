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
   
    mov temp, 1           ; 1 digit
    mov bx, 1d        
    cmp ax, 9          
    jle NumLengthEnd      

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

PrintRow MACRO id, mrk, grd
    push ax
    push dx
    push cx
    push bx
    push si

    ; left border
    PrintString column_separator

    ; Student ID column (padded to 19 characters)
    mov dh, 0
    mov dl, id
    NumLength dx  ;sets bx (divisor) and temp (numlength)
    ;left padding
    mov cx, 19          
    sub cl, temp        
    call PrintSpaces  
    mov al, id
    mov ah, 0
    mov rem, ax
    call PrintDigits

    ; Marks column (padded to 19 chars)
    PrintString column_separator
    mov dh, 0
    mov dl, mrk
    NumLength dx  
    ;left padding
    mov cx, 19        
    sub cl, temp        
    call PrintSpaces
   
    mov al, mrk
    mov ah, 0
    mov rem, ax
    call PrintDigits

    ; Grades column (padded to 19 chars)
    PrintString column_separator
    ;left padding
    mov cx, 18
    call PrintSpaces
   
    PrintChar grd
   
   
    ; CGPA column (padded to 18 chars)
    PrintString column_separator
    ;left padding
    mov cx, 14
    call PrintSpaces
   
    ; cgpa integer part
    call MARK_TO_GPA  ; takes marks from AX and stores CGPA in AX
    mov bl, 100            
    div bl                    
   
    add al, 30h      ; Convert to ASCII
    PrintChar al              
    PrintChar '.'            
   
    ; cgpa fractional part (remainder)
    mov dl, ah                
    mov dh, 0
    mov bx, 10d
    mov rem, dx
    call PrintDigits
   
       
   
    ; right border
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
max_students db 50d          ; Maximum number of students

student_ids db 50 dup(0)    ; Array for Student IDs
marks db 50 dup(0)          ; Array for Marks
grades db 50 dup('?')       ; Array for Grades

;------------------------x---------------------------------;



;----------------------------------------------------------;
;INITIALIZE STRINGS HERE
header db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "|    Student ID     |       Marks       |       Grade       |       CGPA       |", 0Dh, 0Ah, "$"
separator db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
footer db "+-------------------+-------------------+-------------------+------------------+", 0Dh, 0Ah, "$"
 
average_label db "Class Average Marks: $"
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

srtrdmsg db "After sorting by marks: ", 0Dh, 0Ah, "$"

msg db "Enter number of students (at max. 50): $"
msg1 db "Invalid input.$"   
msg2 db "Maximum student count exceeded.$"
;------------------------x---------------------------------;



;----------------------------------------------------------;
;INITIALIZE VARIABLES HERE
temp db ?                  ; Temporary variable for calculations
rem dw ?                   ; imortant for PrintDigits
student_count db ?         ; Actual number of students (input by the user)


tempID db ?
tempMarks db ?
tempGrade db ?
cgp db ?
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
    PrintString gap1
    PrintString welcome
    PrintString newline
   

    ; Prompt user to enter student count
    PrintString msg
   
    mov cx, 0            
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h  
    mov cl,10      
    mul cl
    mov cl, al           ; store tens place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h
    add cl, al           ; combine  digits  
   
    cmp cl,50            ; checking exceed student
    jg exceed_student
    jle proceed
   
    exceed_student:
    PrintString newline
    PrintString msg2
    jmp exit
   
    proceed:
    mov student_count, cl
   
     
   
    ; Initialize variables
    mov si, 0            
    mov ch, 0
    mov cl, student_count
   
    ; Input Student IDs
    PrintString newline
    PrintString id_inp
   
    input_ids:
    mov ax, 0            ; Clear AX (to hold final result)
    mov bl, 10
    mov bh, 0            ; Multiplier for tens place
   
    ; Read tens place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h          
    mul bl
    mov bx, ax
   
    ; Read units place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h
    add bx, ax
   
    ; Store the ID
    mov student_ids[si], bl
   
    PrintString newline
    PrintString indent
   
    add si, 1            ; Move to next ID slot
    loop input_ids
   
    ; Input Marks
    PrintString newline
    PrintString marks_inp
   
    mov si, 0            ; Reset index for marks
    mov ch, 0
    mov cl, student_count ; Loop variable
   
    input_marks:
    mov ax, 0            ; Clear AX (to hold final result)
    mov bl, 100          ; Multiplier for hundreds place
   
    ; Read hundreds place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h          
    mul bl
    mov dx, ax
   
    ; Read tens place
    mov bl, 10
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h
    mul bl
    add dx, ax
   
    ; Read units place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h
    add dx, ax
    mov dh, 0
    call VALIDATE_MARKS
    ; Store the Marks
    mov marks[si], dl
   
    PrintString newline
    PrintString indent2
   
    inc si
    loop input_marks
   
    PrintString newline
   
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
    JMP next_student

grade_A:
    MOV grades[SI], 'A'
    JMP next_student

grade_B:
    MOV grades[SI], 'B'
    JMP next_student

grade_C:
    MOV grades[SI], 'C'
    JMP next_student

grade_D:
    MOV grades[SI], 'D'

next_student:
    INC SI
    LOOP assign_grades_and_cgpa
   
;---------shows unsorted grades----------;    
    call DisplayGrades
;----------------------------------------;


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
    PrintString srtrdmsg
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

    ; Return to inner loop
    JMP next_iteration    

Adrita:
    ;------;
    ;ADRITA;
    ;------;

    ; Initialize student data
    ;call InitializeData

    ; Display the grades and summary
    call DisplayGrades
   
    PrintString average_label
    ; Calculate the average
    call CalcAverage
   
   
   
   
    exit:    
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
InitializeData PROC
    push ax
    push si
    xor si, si             ; Array index
    mov ch, 0h
    mov cl, student_count  ; Number of students
   
    InitLoop:
        mov ax, si
        mov student_ids[si], al ; Assign Student ID as the index
        mov marks[si], al       ; Assign marks (example values)
        mov grades[si], 'A'     ; Assign grade (example values)
        inc si
        loop InitLoop
    pop si    
    pop ax
    ret
InitializeData ENDP




;------;
;ADRITA;
;------;
; Procedure to calculate average
CalcAverage PROC
    push ax              
    push bx
    push cx
    push dx
    push si
   
    ; initializing
    mov ax, 0            
    mov ch, 0
    mov cl, student_count ;loop counter
    mov si, offset marks  ; Point SI to the start of the marks array

    SumLoop:
        mov bl, [si]          ; Load current mark into BX
        mov bh, 0
        add ax, bx            ; Add BX to the running total (AX)
        inc si             ; Move to the next mark
        loop SumLoop        

    ; AX has sum
    mov dx, 0
    mov bh, 0
    mov bl, student_count
    div bx
    ;AX now has quotient
    mov rem, ax    
    NumLength ax       ;sets bx
    call PrintDigits   ;total sum
    PrintChar '.'
   
    ;fractional part (upto two decimal places)
    mov ax, dx      
    mov bx, 100           ; Multiply remainder by 100 to get fractional part
    mul bx
    mov bh, 0
    mov bl, student_count
    div bx                ; AX = fractional part (two digits), DX = remainder

    mov rem, ax          
    NumLength ax          
    call PrintDigits      


    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
CalcAverage ENDP



DisplayGrades PROC
    push ax
    push dx
    push si
    push cx

   
    PrintString header
 

    ; Initializing
    mov si, 0h                
    mov ch, 0h
    mov cl, student_count    
   

    ; Printing Table Rows
    DisplayLoop:
        PrintString separator
        PrintRow student_ids[si], marks[si], grades[si]
        inc si
        loop DisplayLoop
       
   
    PrintString footer

   
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

    mov dl, ' '        
    SpaceLoop:
        mov ah, 2
        int 21h
        loop SpaceLoop

    pop dx
    pop ax
    ret
PrintSpaces ENDP


PrintDigits PROC
    ;!!IMPORTANT!! store required bx and rem beforehand !!IMPORTANT!!
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
VALIDATE_MARKS PROC
    PUSH AX    
    PUSH BX            
    PUSH DX            


    CMP DX, 0          
    JL INVALID_MARKS   ; Jump if DX < 0

    POP DX            
    POP BX            
    POP AX            
    RET                ; Return if valid marks

INVALID_MARKS:
    PrintString newline
    PrintString msg1              
    MOV AX, 4C00H      
    INT 21H             ; Terminate the program

VALIDATE_MARKS ENDP


VALIDATE_DIGIT PROC
    PUSH AX        
    PUSH DX        

    CMP AL, '0'      
    JL INVALID_INPUT   ; Jump to terminate if AL < '0'
    CMP AL, '9'      
    JG INVALID_INPUT   ; Jump to terminate if AL > '9'

    POP DX          
    POP AX          
    RET                ; Return if valid input

INVALID_INPUT:
    PrintString newline
    PrintString msg1            
    MOV AX, 4C00H      
    INT 21H            ; Terminate the program
           

VALIDATE_DIGIT ENDP


;---;
;MIM;
;---;
MARK_TO_GPA PROC
    CMP AX, 90
    JGE GPA_4_0          ; Marks >= 90

    CMP AX, 85
    JGE GPA_3_7          ; 85 <= Marks < 90

    CMP AX, 80
    JGE GPA_3_3          ; 80 <= Marks < 85

    CMP AX, 75
    JGE GPA_3_0          ; 75 <= Marks < 80

    CMP AX, 70
    JGE GPA_2_7          ; 70 <= Marks < 75

    CMP AX, 65
    JGE GPA_2_3          ; 65 <= Marks < 70

    CMP AX, 60
    JGE GPA_2_0          ; 60 <= Marks < 65

    CMP AX, 57
    JGE GPA_1_7          ; 57 <= Marks < 60

    CMP AX, 55
    JGE GPA_1_3          ; 55 <= Marks < 57

    CMP AX, 52
    JGE GPA_1_0          ; 52 <= Marks < 55

    CMP AX, 50
    JGE GPA_0_7          ; 50 <= Marks < 52

    JMP GPA_0_0          ; Marks < 50

GPA_4_0:
    MOV AX, 400          ; GPA = 4.00
    RET

GPA_3_7:
    MOV AX, 370          ; GPA = 3.70
    RET

GPA_3_3:
    MOV AX, 330          ; GPA = 3.30
    RET

GPA_3_0:
    MOV AX, 300          ; GPA = 3.00
    RET

GPA_2_7:
    MOV AX, 270          ; GPA = 2.70
    RET

GPA_2_3:
    MOV AX, 230          ; GPA = 2.30
    RET

GPA_2_0:
    MOV AX, 200          ; GPA = 2.00
    RET

GPA_1_7:
    MOV AX, 170          ; GPA = 1.70
    RET

GPA_1_3:
    MOV AX, 130          ; GPA = 1.30
    RET

GPA_1_0:
    MOV AX, 100          ; GPA = 1.00
    RET

GPA_0_7:
    MOV AX, 70           ; GPA = 0.70
    RET

GPA_0_0:
    MOV AX, 0            ; GPA = 0.00
    RET

MARK_TO_GPA ENDP


;------------------------x---------------------------------;
END MAIN