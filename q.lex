%option yylineno
%{
void error( char* komunikat ) {
	fprintf(stdout, "%s: %d\n",komunikat, yylineno );
	exit(1);
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
// wartosc tokena dla bisona, tez tam bedzie przeniesione
long int yylval;
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
{NAPIS}			{ return L_STRING; }
{LICZBA}		{ return L_INT; }


 /* identyfikatory */
"[c:"{HEXTRI}"]"	{
			 sscanf( yytext, "[c:#%06x]",&yylval );
			 return L_COLOR_START;
			}
"[/c]"			{ return L_COLOR_END; }


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

%% 
  
int main() {
		while(1) yylex();
	return 0;
}

