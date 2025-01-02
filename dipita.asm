.MODEL SMALL
.STACK 100H

.DATA 
gap1 db "                $"
welcome db "Welcome to the classroom grading system$"
newline db 0Dh, 0Ah, "$"
id_inp db "Enter Student's ID: $"
indent db "                    $"  
indent2 db "                       $"
marks_inp db "Enter Student's marks: $"      
err db " (Please provide valid marks) $"
student_ids db 50 dup(0)      ; Array for Student IDs
marks db 50 dup(0)            ; Array for Marks
grades db 50 dup('?')         ; Array for Grades
cgpa dw 50 dup(0)             ; Array for CGPA
max_students db 50
student_count db ?
msg db "Enter number of students (at max. 50): $"
msg1 db "Invalid input.$"
.CODE
MAIN PROC

; Initialize DS
MOV AX, @DATA
MOV DS, AX
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

    lea dx, msg
    mov ah, 9
    int 21h
    
    mov cx, 0            ; Clear CX
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h          ; Convert ASCII to numeric
    mul cx
    mov cl, al           ; Read tens place
    mov ah, 1
    int 21h
    call VALIDATE_DIGIT
    sub al, 30h
    add cl, al           ; Combine digits
    mov student_count, cl ; Store student count
    
      
    
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
    call VALIDATE_DIGIT
    sub al, 30h          ; Convert ASCII to numeric
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
    call VALIDATE_DIGIT
    sub al, 30h          ; Convert ASCII to numeric
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

; Display Grades

; Exit to DOS
exit:
MOV AX, 4C00H
INT 21H

MAIN ENDP

VALIDATE_MARKS PROC
    PUSH AX            ; Save AX
    PUSH BX            ; Save BX
    PUSH DX            ; Save DX

    ; Check if DX < 0
    CMP DX, 0          ; Compare DX with 0
    JL INVALID_MARKS   ; Jump if DX < 0

    ; Check if DX > 100
    MOV AX, 100d        ; Load 100 into AX
    CMP DX, AX         ; Compare DX with 100
    ;int 3h
    JG INVALID_MARKS   ; Jump if DX > 100

    POP DX             ; Restore DX
    POP BX             ; Restore BX
    POP AX             ; Restore AX
    RET                ; Return if valid marks

INVALID_MARKS:
    lea dx, newline     ; Display newline
    mov ah, 9
    int 21h

    LEA DX, msg1        ; Load address of error message
    MOV AH, 9           ; Display string function
    INT 21H             ; Call DOS interrupt

    MOV AX, 4C00H       ; DOS terminate program
    INT 21H             ; Terminate the program

VALIDATE_MARKS ENDP


VALIDATE_DIGIT PROC
    PUSH AX            ; Save AX
    PUSH DX            ; Save DX

    CMP AL, '0'        ; Check if AL is less than '0'
    JL INVALID_INPUT   ; Jump to terminate if AL < '0'
    CMP AL, '9'        ; Check if AL is greater than '9'
    JG INVALID_INPUT   ; Jump to terminate if AL > '9'

    POP DX             ; Restore DX
    POP AX             ; Restore AX
    RET                ; Return if valid input

INVALID_INPUT:
    lea dx, newline
    mov ah, 9
    int 21h    
    LEA DX, msg1        ; Load address of error message
    MOV AH, 9          ; Display string function
    INT 21H            ; Call DOS interrupt
    MOV AX, 4C00H      ; DOS terminate program
    INT 21H            ; Terminate the program

VALIDATE_DIGIT ENDP


END MAIN

