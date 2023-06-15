# assembly_pstrings

Pstring - Linux GNU Assembly Implementation
This repository contains a simple assembly implementation for the pstring string type in C. It was developed as part of a computer structure course at BIU. The pstring structure and associated functions are implemented entirely in GNU Assembly for Linux systems.

Instructions
To use the program, follow these steps:

Download the files to your Linux computer.
Open your terminal and navigate to the project directory.
Run make to compile the code.
Execute the program by running ./a.out.
The program will expect you to enter the following inputs:
First string length
First string
Second string length
Second string
Choose a number corresponding to the operation you want to perform:
31: Print the lengths of both strings (pstrlen)
32 or 33: Take two additional characters as input and replace the first occurrence of the first character with the second character in both strings (replaceChar)
35: Take two indices as input (i and j) and copy the substring of the second string from index i to j into the first string (strcpy)
36: Swap the case of each letter (upper to lower or lower to upper) in both strings (swapCase)
37: Perform a lexical comparison between the two strings based on ASCII values (strcmp)
The program will execute the chosen operation and provide the output.
Please note that all functions in this implementation are written in assembly language.

Feel free to explore and use this assembly implementation of the pstring structure and associated functions in your Linux environment.
If you have any questions or suggestions, please let us know.
