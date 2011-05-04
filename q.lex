%option yylineno
%{

#include "q.tab.h"

void error( char* komunikat ) {
	fprintf(stdout, "%s: %d\n",komunikat, yylineno );
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
			  char* napis = malloc ( sizeof(char) * strlen(yytext) ); // malloc! free w bisonie
			  strcpy( napis, yytext );
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
<def>","		{}
<def>"\n"		{
			 BEGIN( INITIAL );
			 return L_DEF_END;
			}

 /* wywolanie funkcji */
"@"			{ return L_FUNC_CALL; }
({NAPIS}|{LICZBA})(","({NAPIS}|{LICZBA}))+ {
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
.			{ error("ERR_LEX"); }

