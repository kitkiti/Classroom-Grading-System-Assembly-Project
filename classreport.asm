.MODEL SMALL
;----------------------------------------------------------;
;DEFINE MACROS HERE
;ADRITA
PrintChar MACRO char
    mov dl, char
    mov ah, 2
    int 21h
ENDM

;DIPITA
; Placeholder for Dipita's macros

;MIM
; Placeholder for Mim's macros

;------------------------x---------------------------------;
.STACK 100H

.DATA
; Variables and arrays
numbers db 1, 2, 3, 4, 5  ; Example array
temp db ?                 ; Temporary storage
greeting db 'Hello, World!$', 0  ; Example string

.CODE
;----------------------------------------------------------;
;MAIN PROCEDURE HERE
MAIN PROC
    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Enter your code here

    ; MIM
    ; Placeholder for Mim's main code

    ; DIPITA
    ; Placeholder for Dipita's main code

    ; ADRITA
    ; Placeholder for Adrita's main code

    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
;----------------------------------------------------------;
;DEFINE PROCEDURES HERE

;ADRITA
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

;DIPITA
; Placeholder for Dipita's procedures

;MIM
; Placeholder for Mim's procedures

;------------------------x---------------------------------;
END MAIN
