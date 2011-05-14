%option yylineno
%{

#include "q.tab.h"

void flexError() {
	fprintf(stdout, "FLEX_ERR: unknown token at line: %d\n", yylineno );
	exit(1);
}
%}


WCIECIE [ \t]*
CYFRA [0-9]
CYFRAHEX [0-9a-fA-F]
HEXTRI {WCIECIE}"#"{CYFRAHEX}{CYFRAHEX}{CYFRAHEX}{CYFRAHEX}{CYFRAHEX}{CYFRAHEX}{WCIECIE}
LICZBA "&"
STRING1 \"[^\"]*\"
STRING2 \'[^\']*\'
NAPIS {STRING1}|{STRING2}

%s def
%%

 /* komentarze */
{WCIECIE}"/*".*"*/" 	{}
{WCIECIE}"//"[^"\n"]*	{}

 /* zmienne */
"%"			{ return L_STRING_VAR; }
"#"			{ return L_INT_VAR; }

 /* wartosci */ 
{NAPIS}			{
			  int len = strlen( yytext );
			  char* napis = malloc( sizeof(char) * (len-1) ); // malloc! free w bisonie!
				int i = 0;
				for( i=1; i<=len-2; i++ ) // wyciecie napisu z cudzyslowow
				napis[i-1] = yytext[i];
			  napis[len-1] = '\0';
			  yylval.string = napis;
			  return L_STRING;
			}
{LICZBA}		{ return L_INT; }


 /* identyfikatory */
"[c:"{HEXTRI}"]"	{
			  sscanf( yytext, "[c:#%06x]",&yylval.color );
			  return L_COLOR_START;
			}
"[/c]"			{
			  yylval.color = 0;
			  return L_COLOR_END;
			}


 /* deklaracje */
"def"			{
			 BEGIN( def );
			 return L_FUNC_START;
			}
"while"			{
			 BEGIN( def );
			 return L_WHILE_START;
			}
<def>"\n"		{
			 BEGIN( INITIAL );
			 yyless(0);
			 return L_DEF_END;
			}
"end"			{ return L_END; }


 /* wywolanie funkcji */
"@"			{
			 BEGIN( def );
			 return L_FUNC_CALL;
			}


 /* operatory */
"="			{ return '='; }
"<"			{ return '<'; }
">"			{ return '>'; }
"+"			{ return '+'; }
"-"			{ return '-'; }
"*"			{ return '*'; }
"/"			{ return '/'; }


 /* znak nowej linii */
"\n"			{ return '\n'; }


 /* smietnik */
{WCIECIE}		{}
";"			{}
.			{ flexError(); }

