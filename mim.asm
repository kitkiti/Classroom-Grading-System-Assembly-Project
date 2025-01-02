.MODEL SMALL
.STACK 100H

.DATA
; Student data
student_ids db 5, 3, 4, 1, 2      ; IDs of students
marks db 80, 90, 60, 50, 40       ; Marks of students
grades db 5 dup('?')              ; Grades placeholder
cgpa dw 5 dup(0)                  ; Placeholder for CGPA (0.0 initially)

; Letter grades
letterGrades db 'A', 'B', 'C', 'D', 'F'

; Temporary storage for swapping
tempID db ?
tempMarks db ?
tempGrade db ?
tempCGPA dw ?                     ; Changed to word

; Strings for display
newline db 0AH, 0DH, '$'          ; Newline for displaying results

.CODE
MAIN PROC
    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Assign letter grades and CGPA based on marks
    MOV CX, 5                     ; Loop for 5 students
    MOV SI, 0                     ; Starting index
assign_grades_and_cgpa:
    MOV AL, marks[SI]             ; Load marks into AL register
    CMP AL, 80
    JGE grade_A
    CMP AL, 70
    JGE grade_B
    CMP AL, 60
    JGE grade_C
    CMP AL, 50
    JGE grade_D
    MOV grades[SI], 'F'           ; If below 50, grade is 'F'
    MOV word ptr cgpa[SI*2], 0    ; CGPA = 0.0
    JMP next_student

grade_A:
    MOV grades[SI], 'A'
    MOV word ptr cgpa[SI*2], 400  ; CGPA = 4.0 (scaled by 100)
    JMP next_student

grade_B:
    MOV grades[SI], 'B'
    MOV word ptr cgpa[SI*2], 300  ; CGPA = 3.0
    JMP next_student

grade_C:
    MOV grades[SI], 'C'
    MOV word ptr cgpa[SI*2], 200  ; CGPA = 2.0
    JMP next_student

grade_D:
    MOV grades[SI], 'D'
    MOV word ptr cgpa[SI*2], 100  ; CGPA = 1.0

next_student:
    INC SI
    LOOP assign_grades_and_cgpa

    ; Bubble Sort Algorithm to sort by marks
    MOV CX, 4                     ; Outer loop: 4 iterations (5 elements, need 4 passes)
outer_loop:
    MOV SI, 0                     ; Start from the first student
    MOV DI, 1                     ; Compare with the next student
    MOV BX, 4                     ; 4 comparisons to do in each pass
inner_loop:
    MOV AL, marks[SI]
    MOV AH, marks[DI]
    CMP AL, AH
    JG swap_elements              ; If marks[SI] > marks[DI], swap

next_iteration:
    INC SI
    INC DI
    DEC BX
    JNZ inner_loop

    DEC CX
    JNZ outer_loop

    ; Display Sorted Results
    MOV CX, 5                     ; Loop through the sorted students
    MOV SI, 0                     ; Start at the first student
display_results:
    ; Display student ID
    MOV AL, student_ids[SI]
    CALL DisplayNum

    ; Display marks
    MOV AL, marks[SI]
    CALL DisplayNum

    ; Display grade
    MOV AL, grades[SI]
    CALL DisplayChar

    ; Display CGPA
    MOV AX, word ptr cgpa[SI*2]   ; Load 16-bit CGPA
    CALL DisplayNum

    ; Newline after each student's information
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H

    INC SI
    LOOP display_results

exit_program:
    MOV AX, 4C00H
    INT 21H

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
    MOV AX, word ptr cgpa[SI*2]
    MOV tempCGPA, AX
    MOV AX, word ptr cgpa[DI*2]
    MOV word ptr cgpa[SI*2], AX
    MOV AX, tempCGPA
    MOV word ptr cgpa[DI*2], AX

    ; Return to inner loop
    JMP next_iteration

; Function to display a number (used for ID, marks, and CGPA)
DisplayNum PROC
    ADD AL, '0'                  ; Convert the number to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DisplayNum ENDP

; Function to display a character (used for grade)
DisplayChar PROC
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
DisplayChar ENDP

END MAIN
