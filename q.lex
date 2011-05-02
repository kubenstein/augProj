%option yylineno
%{
void error( char* komunikat ) {
	fprintf(stdout, "%s: %d\n",komunikat, yylineno );
}
%}


WCIECIE [ \t]*
CYFRA [0-9]
LICZBA {WCIECIE}{CYFRA}+{WCIECIE}
STRING1 \"[^\"]*\"
STRING2 \'[^\']*\'
NAPIS {STRING1}|{STRING2}

%s deffunc defwhile
%%

 /* komentarze */
{WCIECIE}"/*".*"*/" 	{}
{WCIECIE}"//".*"\n"	{}

 /* zmienne */
"%"			{ printf("<ZMIENNA_STRINGOWA />" ); }
"#"			{ printf("<ZMIENNA_LICZBOWA />" ); }

 /* wartosci */ 
{NAPIS}			{ printf("<NAPIS:%s />", yytext ); }
"&"			{ printf("<LICZBA:%s />", yytext ); }


 /* identyfikatory */
"[c:("{LICZBA}","{LICZBA}","{LICZBA}")]"	{
			 int r,g,b;
			 sscanf( yytext, "[c:(%d,%d,%d)]",&r,&g,&b );
			 printf("<COLOR:(%d,%d,%d)>", r,g,b ); 
			}
"[/c]"			{ printf("</ COLOR>"); }


 /* deklaracja funkcji */
"def"			{
			 BEGIN( deffunc );
			 printf("<funcdef>" );
			}
<deffunc>","		{}
<deffunc>"\n"		{ 
			 BEGIN( INITIAL );
			 printf("</ funcdef>" );
			}


 /* wywolanie funkcji */
"@"			{ printf("<funccall />"); }


 /* deklaracja while */
"while"			{
			 BEGIN( defwhile );
			 printf("<while>" );
			}
<defwhile>","		{}
<defwhile>"\n"		{ 
			 BEGIN( INITIAL );
			 printf("</ while>" );
			}

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

