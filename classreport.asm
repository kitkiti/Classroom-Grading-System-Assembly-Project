.MODEL SMALL
;----------------------------------------------------------;
;DEFINE MACROS HERE 
;GLOBAL
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
; Placeholder for Adrita's macros

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
;------------------------x---------------------------------;



;----------------------------------------------------------;
;INITIALIZE STRINGS HERE
greeting db "Welcome to the Student Grading System!", 0Dh, 0Ah, "$"
header db "Student ID    Marks    Grade", 0Dh, 0Ah, "$"
separator db "-----------------------------------", 0Dh, 0Ah, "$"
average_label db "Class Average: $"
num_students_label db "Total Students: $"
;------------------------x---------------------------------; 



;----------------------------------------------------------;
;INITIALIZE VARIABLES HERE
temp db ?                  ; Temporary variable for calculations
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
    
    ; Prompt user for the number of students
    mov ah, 1             ; DOS function to take a single character input
    int 21h               ; Input student count
    sub al, 30h           ; Convert ASCII to numeric
    mov student_count, al ; Store the count
    
    
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

    ; Calculate the average
    ;call CalcAverage

    ; Display the grades and summary
    ;call DisplayGrades
        
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
    xor si, si             ; Array index
    mov ch, 0h
    mov cl, student_count  ; Number of students
    
    InitLoop:
        mov student_ids[si], si ; Assign Student ID as the index
        mov marks[si], si       ; Assign marks (example values)
        mov grades[si], 'A'     ; Assign grade (example values)
        inc si
        loop InitLoop
    ret
InitializeData ENDP


;------;
;ADRITA;
;------;
; Procedure to calculate average
CalcAverage PROC
    ; Code to compute average
    ret
CalcAverage ENDP

; Procedure to display grades
DisplayGrades PROC
    ; Code to display detailed grades
    ret
DisplayGrades ENDP

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
