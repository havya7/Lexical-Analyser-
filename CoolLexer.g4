lexer grammar CoolLexer;

tokens{
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}

/*
  DO NOT EDIT CODE ABOVE THIS LINE
*/

@members{

	/*
		YOU CAN ADD YOUR MEMBER VARIABLES AND METHODS HERE
	*/

	/**
	* Function to report errors.
	* Use this function whenever your lexer encounters any erroneous input
	* DO NOT EDIT THIS FUNCTION
	*/
	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}

	public void invalidChar(){
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		reportError(text);
	}

	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();

		//write your code to test strings here

		StringBuilder bstr = new StringBuilder(0);

		for(int i=1;i<text.length();i++)
		{
				
			if(text.charAt(i) == '\\')
			{
				if(i == text.length()-1)
				{
					reportError("backslash at end of file");
					return;
				}
				
				if(i == text.length()-2 )
				{	
					reportError("EOF in string constant");
					return;			
				}
				
				else if(text.charAt(i+1) == 'b')
					bstr.append('\b');
				else if(text.charAt(i+1) == 't')
					bstr.append('\t');
				else if(text.charAt(i+1) == 'n')
					bstr.append('\n');
				else if(text.charAt(i+1) == 'f')
					bstr.append('\f');
				else if(text.charAt(i+1) == '\u0000')
				{
					reportError("String contains escaped null character.");
					return;
				}
				
				else
					bstr.append(text.charAt(i+1));
				i++;
			}
			else
			{
				if(text.charAt(i) == '\n')
				{
					reportError("Unterminated string constant");
					return;
				}
				else if(text.charAt(i) == '\u0000')
				{
					reportError("String contains null character.");
					return;
				}
				else if(text.charAt(i) != '"')
				{
					if(i == text.length()-1)
					{
						reportError("EOF in string constant");
						return;
					}
					else
						bstr.append(text.charAt(i));
				}
			}

			String check_str = bstr.toString();
			if(check_str.length() > 1024)
				break;
			
		}
		
		String str = bstr.toString();
		if(str.length() > 1024)
		{
			reportError("String constant too long");
			return;
		}

		setText(str);
		return;

	}
}

/*
	WRITE ALL LEXER RULES BELOW
*/



DARROW      	: '=>';


BOOL_CONST	: 't'('r'|'R')('u'|'U')('e'|'E')|'f'('a'|'A')('l'|'L')('s'|'S')('e'|'E');
INT_CONST	: [0-9]+;

STR_ERROR	: '"'EOF  { reportError("EOF in string literal"); };
STR_CONST	: '"' ('\\\\'|'\\'(('"')|('\n'))|.)*? (('"')|('\n')|(.EOF)) {processString();};

LPAREN		: '(';
RPAREN		: ')';
COLON		: ':';
ATSYM		: '@';
SEMICOLON	: ';';
COMMA		: ',';
PLUS		: '+';
MINUS		: '-';
STAR		: '*';
SLASH		: '/';
TILDE		: '~';
LT			: '<';
EQUALS		: '=';
LBRACE		: '{';
RBRACE		: '}';
DOT			: '.';
LE			: '<=';
ASSIGN 		: '<-';



/* keywords */

CLASS		: ('c'|'C')('l'|'L')('a'|'A')('s'|'S')('s'|'S');
ELSE		: ('e'|'E')('l'|'L')('s'|'S')('e'|'E');
FI			: ('f'|'F')('i'|'I');
IF 			: ('i'|'I')('f'|'F');
IN			: ('i'|'I')('n'|'N');
INHERITS	: ('i'|'I')('n'|'N')('h'|'H')('e'|'E')('r'|'R')('i'|'I')('t'|'T')('s'|'S');
LET			: ('l'|'L')('e'|'E')('t'|'T');
LOOP		: ('l'|'L')('o'|'O')('o'|'O')('p'|'P');
POOL		: ('p'|'P')('o'|'O')('o'|'O')('l'|'L');
THEN		: ('t'|'T')('h'|'H')('e'|'E')('n'|'N');
WHILE		: ('w'|'W')('h'|'H')('i'|'I')('l'|'L')('e'|'E');
CASE		: ('c'|'C')('a'|'A')('s'|'S')('e'|'E');
ESAC		: ('e'|'E')('s'|'S')('a'|'A')('c'|'C');
OF			: ('o'|'O')('f'|'F');
NEW			: ('n'|'N')('e'|'E')('w'|'W');
ISVOID		: ('i'|'I')('s'|'S')('v'|'V')('o'|'O')('i'|'I')('d'|'D');
NOT			: ('n'|'N')('o'|'O')('t'|'T');

/* identifiers */

TYPEID		: [A-Z][A-Za-z0-9_]*;
OBJECTID	: [a-z][A-Za-z0-9_]*;


SPACES			: ('\t'|'\r'|'\n'|'\f'|'\u000b'|' ')+ -> skip ;

/* comments */

LINE_ERROR		: '--'EOF -> skip;
LINE_COMMENT	: '--' ~('\n')* (('\n')|(.EOF)) ->skip;

MUL_OCOMMENT	: '(*' -> pushMode(COMMENT), skip;
MUL_CCOMMENT	: '*)' {reportError("Unmatched *)");};
ERR0			: '(*EOF' {reportError("EOF in comment");};

INVALID_CHAR	: . {invalidChar();};

mode COMMENT;
OPEN_COMMENT	: '(*' -> pushMode(IN_COMMENT), skip;
CLOSE_COMMENT	: '*)' -> popMode, skip;
COMMENT_ERR0	: '(*'EOF {reportError("EOF in comment");};
COMMENT_ERR		: .EOF {reportError("EOF in comment");};
ANY_CHAR		: . -> skip;

mode IN_COMMENT;
OPEN_IN_COMMENT	: '(*' -> pushMode(IN_COMMENT), skip;
CLOSE_IN_COMMENT: '*)' -> popMode, skip;
IN_COMMENT_ERR0	: '(*'EOF {reportError("EOF in comment");};
IN_COMMENT_ERR	: .EOF {reportError("EOF in comment");};
IN_COMMENT_ERR1	: '*)'EOF {reportError("EOF in comment");};
IN_ANY_CHAR		: . -> skip;


