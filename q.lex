%option yylineno
%{
void error( char* komunikat ) {
	fprintf(stdout, "%s: %d\n",komunikat, yylineno );
}


// def tokenow, pozniej przeniose do bisona
enum leksem {
	L_STRING_VAR,
	L_INT_VAR,
	L_STRING,
	L_INT,
	L_COLOR_START,
	L_COLOR_END,
	L_FUNC_START,
	L_WHILE_START,
	L_DEF_END,
	L_FUNC_CALL
  };
%}


WCIECIE [ \t]*
CYFRA [0-9]
DEC_LICZBA {WCIECIE}{CYFRA}+{WCIECIE}
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
"%"			{ printf("<ZMIENNA_STRINGOWA />" );	return L_STRING_VAR; }
"#"			{ printf("<ZMIENNA_LICZBOWA />" );	return L_INT_VAR; }

 /* wartosci */ 
{NAPIS}			{ printf("<NAPIS:%s />", yytext );	return L_STRING; }
{LICZBA}		{ printf("<LICZBA:%s />", yytext );	return L_INT; }


 /* identyfikatory */
"[c:("{DEC_LICZBA}","{DEC_LICZBA}","{DEC_LICZBA}")]"	{
			 int r,g,b;
			 sscanf( yytext, "[c:(%d,%d,%d)]",&r,&g,&b );
			 printf("<COLOR:(%d,%d,%d)>", r,g,b ); 
								return L_COLOR_START;
			}
"[/c]"			{ printf("</ COLOR>");			return L_COLOR_END; }


 /* deklaracje */
"def"			{
			 BEGIN( def );
			 printf("<defFunc>" );
								return L_FUNC_START;
			}
"while"			{
			 BEGIN( def );
			 printf("<defWhile>" );
								return L_WHILE_START;
			}
<def>","		{}
<def>"\n"		{
			 BEGIN( INITIAL );
			 printf("</ def>" );
								return L_DEF_END;
			}

 /* wywolanie funkcji */
"@"			{ printf("<funccall />");		return L_FUNC_CALL; }
({NAPIS}|{LICZBA})(","({NAPIS}|{LICZBA}))+ {
			 printf("<funccall:%s />", yytext);
								return L_FUNC_CALL;
			}

 /* operatory */
"="			{ printf("=");				return '='; }
"<"			{ printf("<");				return '<'; }
">"			{ printf(">");				return '>'; }
"+"			{ printf("+");				return '+'; }
"-"			{ printf("-");				return '-'; }
"*"			{ printf("*");				return '*'; }
"/"			{ printf("/");				return '/'; }

 /* smietnik */
{WCIECIE}		{}
";"			{}
.			{ error("ERR_LEX"); }

%% 
  
int main() {
		while(1) yylex();
	return 0;
}

