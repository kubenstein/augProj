%option yylineno
%{
void error( char* komunikat ) {
	fprintf(stdout, "%s: %d\n",komunikat, yylineno );
}
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
"%"			{ printf("<ZMIENNA_STRINGOWA />" ); }
"#"			{ printf("<ZMIENNA_LICZBOWA />" ); }

 /* wartosci */ 
{NAPIS}			{ printf("<NAPIS:%s />", yytext ); }
{LICZBA}		{ printf("<LICZBA:%s />", yytext ); }


 /* identyfikatory */
"[c:("{DEC_LICZBA}","{DEC_LICZBA}","{DEC_LICZBA}")]"	{
			 int r,g,b;
			 sscanf( yytext, "[c:(%d,%d,%d)]",&r,&g,&b );
			 printf("<COLOR:(%d,%d,%d)>", r,g,b ); 
			}
"[/c]"			{ printf("</ COLOR>"); }


 /* deklaracje */
"def"			{
			 BEGIN( def );
			 printf("<defFunc>" );
			}
"while"			{
			 BEGIN( def );
			 printf("<while>" );
			}
<def>","		{}
<def>"\n"		{
			 BEGIN( INITIAL );
			 printf("</ def>" );
			}

 /* wywolanie funkcji */
"@"			{ printf("<funccall />"); }


 /* operatory */
"="			{ printf("="); }
"=="			{ printf("=="); }
"<"			{ printf("<"); }
">"			{ printf(">"); }
"+"			{ printf("+"); }
"-"			{ printf("-"); }
"*"			{ printf("*"); }
"/"			{ printf("/"); }

 /* smietnik */
{WCIECIE}		{}
.			{ error("ERR_LEX"); }

%% 
  
int main() {
	yylex();
	return 0;
}

