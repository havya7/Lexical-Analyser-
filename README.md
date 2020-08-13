# COOL Compiler #
# Report by: K. HAVYA SREE


# ----------------------------------- README FOR LEXICAL ANALYSER OF COOL COMPILER ---------------------------------------



# ----------------------------------------- RULE FOR STRINGS --------------------------------------------
   
   Any set of tokens beginning with a '"' and ending with an unescaped newline character or unescaped " or an .EOF is considered as a string and the processstring function is called.
   All the errors in the string are processed in the processstring() function.

   In the process string function,
   A string is constructed using string builder by  *  reporting error if any 
                                                    *  removing any unnesscary '\' 
                                                    *  and appending all other characters to the string
  

#  STRING FORMATION:

    1) For every unescaped character, we append it to the buffer if it is any other character other than an unescaped '"'
   
    2) For every escaped character, we check the next character and
       1) if it n,t,b,v we append the '\n','\b','\t','\v' characters to the buffer respectively
       2) for any other character, we append the character to the buffer
   
   
#  ERRORS:

    1)string constant is too long
      We check the length of the string after appending easch character to the buffer and it reports an error if it is greater than 1024.

    1) EOF in string constant
       1)  if the last element in the string is neither unescaped '\n' nor unescaped '"', then the only possibility is that there is EOF in string literal and report an error.
       2)  if the character in the position just before the last position is '\', then the last character in the string is an escaped character. And processstring() function is called only when the text ends with either an unescaped newline or unescaped " or EOF. Since the last character is an escaped character, so the string ended with EOF, so we report an error.
   
    2) string contains null character
         If the string contains a character with the unicode value '\u0000', then it reports an error.
   
    3) string contains an escaped null character
         If the string contains unescaped '\' just before the character with the unicode value '\u0000', then it reports an error.

    4) unterminated string constant
         If the string contains an unescaped newline character, it reports an error.

    5) backslash at end of file
         If the last character in a string is unescaped '\', then it means there is an EOF after that, hence it reports an error.

   



# -------------------------------------------- RULE FOR COMMENTS ---------------------------------------------


#  SINGLE LINE COMMENTS
   
   Single line comments are easy to deal with. We skip all characters until we encounter a new line or EOF

#  BLOCK COMMENTS
   
        There are 2 modes for the block comments.
        When we encounter the first (* we go into the 1st mode 'COMMENT'. And later for all the remaining '(*' we go into the other mode 'IN_COMMENT'.
        Both mode COMMENT and IN_COMMENT :
        * push mode IN_COMMENT if the encounter a (*
        * pop mode if they encounter a *)
        * report error, if they encounter an EOF
        * skip any other character

      The only difference between mode COMMENT and IN_COMMENT is that in mode IN_COMMENT EOF after a *) will report a "EOF in string" error and it won't be an error in mode COMMENT because the *) would mean the ending of the comment.
   
   

# ------------------------------------------ RULES FOR KEYWORDS -----------------------------------------------

   All the keywords are case-insensitive. Except for true and false, where the first letter should be a small letter.
   So, they are defined as

      IF : ('I'|'i')('F'|'f')
       ALL the letters can be of either lower or upper case

      TRUE : 't'('r'|'R')('u'|'U')('e'|'E')
       The first letter must be lower case


# ------------------------------------------ RULES FOR OPERATORS ------------------------------------------------

   All the operators are defined with their corresponding symbol.
   For example,
      MINUS : '-'

# ----------------------------------------- RULES FOR IDENTIFIERS -----------------------------------------------

   All the object identifiers should have a lower case first letter.
   [a-z][A-Za-z_]*   ->  which implies that the first letter is an lower case letter and following that there can be any number of upper case and lower case alphabets and _.

   All the type identifiers should have a upper case first letter.
   [A-Z][A-Za-z_]*   ->  which implies that the first letter is an upper case letter and following that there can be any number of upper case and lower case alphabets and _.


# ------------------------------------------ RULES FOR INTEGERS --------------------------------------------------

   All the integers must have atleast one digit. Hence,
   INTEGERS : [0-9]+;

# ----------------------------------------- RULE FOR WHITE SPACES -----------------------------------------------

      The characters '\n', '\t', '\r', '\f', '\v', ' ' are ignored(skipped). ANTLR doesn't support '\v', hence its unicode '\u000b' is used.
      SPACES			: ('\t'|'\r'|'\n'|'\f'|'\u000b'|' ')+ -> skip ;

# -------------------------------------- RULE FOR INVALID CHARACTERS --------------------------------------------

   Any character which does not satisy any of the above rules is an invalid character. Hence, we write the INVALID_CHAR rule at the end of all the rules.


# --------------------------------------------- TEST CASES ------------------------------------------------------

# NOTE: The line number shown in the output is the line no. corresponding to the first line of the error.

TESTCASE_1:
   Keywords, identifiers, operators and invalid characters are checked in this test case.

TESTCASE_2:
   Various strings without an error are checked here.

TESTCASE_3 :
   All the errors related to strings here. It contains unterminated strings, strings having length more than 1024 characters and string having EOF.

TESTCASE_4:
   This file checks the case where there is a backslash just before EOF in string literal

TESTCASE_5:
   Skipping the comments part and EOF in single line comment is checked in this test case.

TESTCASE_6:
   This file checks the case where there is EOF in comments

And all other test cases are non-trivial toy cool programs.




# --------------------------------------------------- THE END ----------------------------------------------------------