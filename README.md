# Classroom Grading System - Assembly Project

A console-based classroom grading system written in **8086 Assembly Language**. The program collects student IDs and marks, validates user input, assigns letter grades, calculates GPA values, sorts students by marks, displays a formatted class report table, and computes the class average.

This project demonstrates low-level programming concepts such as register manipulation, DOS interrupt-based I/O, arrays, macros, procedures, loops, conditional branching, arithmetic operations, and sorting in Assembly.

## Project Overview

The Classroom Grading System is designed to manage a small classroom record through an Assembly language program. Users enter the number of students, student IDs, and marks. The program then processes the data and displays both unsorted and sorted student reports.

Each report includes:

```text
Student ID
Marks
Letter Grade
CGPA
```

The final output also includes the class average marks.

## Features

- Console-based student grading system
- Supports up to 50 students
- Takes student count as user input
- Takes student IDs as input
- Takes marks as input
- Validates numeric input
- Rejects invalid marks outside the 0-100 range
- Assigns letter grades based on marks
- Converts marks into CGPA values
- Displays data in a formatted table
- Sorts student records by marks
- Calculates and displays class average marks
- Uses modular macros and procedures for cleaner Assembly code

## Repository Structure

```text
Classroom-Grading-System-Assembly-Project/
├── classreport.asm   # Main Assembly source code
└── README.md         # Project documentation
```

## Main Source File

The main program is implemented in:

```text
classreport.asm
```

This file contains:

- Macro definitions for printing strings, characters, rows, and number formatting
- Data declarations for student IDs, marks, grades, and messages
- Main procedure for input collection and program flow
- Procedures for validation, display, average calculation, digit printing, and GPA conversion
- Bubble sort logic for sorting student records by marks

## Technologies Used

- 8086 Assembly Language
- MASM/TASM-style syntax
- DOS interrupts
- EMU8086 / DOSBox-compatible execution environment

## How the Program Works

### 1. Start Program

The program initializes the data segment and displays a welcome message.

```text
Welcome to the classroom grading system
```

### 2. Enter Student Count

The user enters the number of students.

Rules:

- Maximum allowed students: 50
- Input must be numeric
- If the number exceeds 50, the program displays an error and exits

### 3. Enter Student IDs

The user enters a two-digit ID for each student.

Example:

```text
Enter Student's ID:
12
24
35
```

### 4. Enter Student Marks

The user enters marks for each student.

Rules:

- Marks must be numeric
- Marks must be between 0 and 100
- Invalid input terminates the program with an error message

Example:

```text
Enter Student's marks:
085
074
092
```

### 5. Assign Letter Grades

The program assigns letter grades using the following scale:

| Marks Range | Grade |
|---|---|
| 80 and above | A |
| 70-79 | B |
| 60-69 | C |
| 50-59 | D |
| Below 50 | F |

### 6. Convert Marks to CGPA

The program converts marks into CGPA values using this scale:

| Marks Range | CGPA |
|---|---|
| 90 and above | 4.00 |
| 85-89 | 3.70 |
| 80-84 | 3.30 |
| 75-79 | 3.00 |
| 70-74 | 2.70 |
| 65-69 | 2.30 |
| 60-64 | 2.00 |
| 57-59 | 1.70 |
| 55-56 | 1.30 |
| 52-54 | 1.00 |
| 50-51 | 0.70 |
| Below 50 | 0.00 |

### 7. Display Report

The program displays the student records in a formatted table.

Example format:

```text
+-------------------+-------------------+-------------------+------------------+
|    Student ID     |       Marks       |       Grade       |       CGPA       |
+-------------------+-------------------+-------------------+------------------+
|                 12|                 85|                  A|              3.70|
+-------------------+-------------------+-------------------+------------------+
```

### 8. Sort by Marks

The program uses a bubble sort algorithm to sort student records by marks. During sorting, the program swaps:

- Student IDs
- Marks
- Grades

This keeps each student record consistent after sorting.

### 9. Calculate Class Average

After displaying the sorted report, the program calculates and prints the average marks for the class.

Example:

```text
Class Average Marks: 78.50
```

## Core Assembly Concepts Demonstrated

This project demonstrates practical use of:

- `.MODEL SMALL`
- `.DATA`, `.CODE`, and `.STACK` segments
- DOS interrupt `INT 21H`
- Macros
- Procedures
- Register usage
- Stack operations with `PUSH` and `POP`
- Arrays using `DB`
- Looping with `LOOP`, `JMP`, and labels
- Conditional branching with `CMP`, `JGE`, `JG`, `JL`, and `JNZ`
- Arithmetic operations with `MUL` and `DIV`
- Bubble sort implementation
- ASCII-to-integer conversion
- Integer-to-ASCII output formatting

## Important Procedures and Macros

### Macros

| Macro | Purpose |
|---|---|
| `PrintString` | Prints a string using DOS interrupt `21H`, function `09H` |
| `PrintChar` | Prints a single character using DOS interrupt `21H`, function `02H` |
| `NumLength` | Determines the number of digits in a number |
| `PrintRow` | Prints one formatted student row in the report table |

### Procedures

| Procedure | Purpose |
|---|---|
| `DisplayGrades` | Displays the complete student report table |
| `CalcAverage` | Calculates and prints class average marks |
| `PrintSpaces` | Prints padding spaces for table formatting |
| `PrintDigits` | Prints numeric values digit by digit |
| `VALIDATE_DIGIT` | Ensures input characters are numeric digits |
| `VALIDATE_MARKS` | Ensures marks are within the valid range |
| `MARK_TO_GPA` | Converts marks into CGPA values |

## Input Requirements

The current implementation expects fixed-width numeric input.

### Student Count

Enter two digits.

Example:

```text
03
10
25
```

### Student ID

Enter two digits per student.

Example:

```text
01
12
45
```

### Marks

Enter three digits per student.

Examples:

```text
095
080
050
```

For marks below 100, include leading zeroes.

Correct:

```text
085
007
050
```

Incorrect:

```text
85
7
50
```

## How to Run

### Option 1: Run with EMU8086

1. Open EMU8086.
2. Load `classreport.asm`.
3. Compile the program.
4. Run the program.
5. Enter the required student data in the console.

### Option 2: Run with MASM/TASM and DOSBox

Assemble and link the file using a DOS-compatible Assembly toolchain.

Example workflow:

```bash
masm classreport.asm;
link classreport.obj;
classreport.exe
```

or with TASM:

```bash
tasm classreport.asm
tlink classreport.obj
classreport.exe
```

The exact commands may vary depending on your installed assembler and emulator setup.

## Example Program Flow

```text
Welcome to the classroom grading system
Enter number of students (at max. 50): 03

Enter Student's ID:
01
02
03

Enter Student's marks:
095
078
044

+-------------------+-------------------+-------------------+------------------+
|    Student ID     |       Marks       |       Grade       |       CGPA       |
+-------------------+-------------------+-------------------+------------------+
|                 01|                 95|                  A|              4.00|
+-------------------+-------------------+-------------------+------------------+
|                 02|                 78|                  B|              3.00|
+-------------------+-------------------+-------------------+------------------+
|                 03|                 44|                  F|              0.00|
+-------------------+-------------------+-------------------+------------------+

After sorting by marks:

+-------------------+-------------------+-------------------+------------------+
|    Student ID     |       Marks       |       Grade       |       CGPA       |
+-------------------+-------------------+-------------------+------------------+
|                 03|                 44|                  F|              0.00|
+-------------------+-------------------+-------------------+------------------+
|                 02|                 78|                  B|              3.00|
+-------------------+-------------------+-------------------+------------------+
|                 01|                 95|                  A|              4.00|
+-------------------+-------------------+-------------------+------------------+

Class Average Marks: 72.33
```

## Learning Objectives

This project was built to practice:

- Writing structured Assembly programs
- Working with user input in low-level programming
- Managing arrays manually in memory
- Formatting output without high-level libraries
- Implementing validation logic in Assembly
- Performing arithmetic and comparisons using CPU registers
- Building a complete menu-style/reporting program in 8086 Assembly
- Applying sorting logic at the assembly level

## Limitations

- The program supports a maximum of 50 students.
- Input is expected in fixed-width numeric format.
- Student IDs are stored as byte-sized values.
- Marks must be entered as three digits.
- The program is designed for a DOS-style 8086 execution environment.
- There is no persistent file storage; all data exists only during runtime.

## Future Improvements

Possible improvements include:

- Support variable-length input
- Add menu-based navigation
- Allow editing or deleting student records
- Sort in both ascending and descending order
- Add highest and lowest marks summary
- Add grade distribution statistics
- Save reports to a file
- Improve input prompts for each individual student
- Add better formatting for CGPA fractional digits

## Author

Tasfia Zaman

## License

No license is currently specified.
