%{
#include <stdio.h>
#define YYSTYPE long int
long int color = 0;
%}

%token L_STRING_VAR L_INT_VAR
%token L_STRING L_INT
%token L_COLOR_START L_COLOR_END
%token L_FUNC_START L_WHILE_START L_DEF_END
%token L_FUNC_CALL
%start input
%%

input:
	| input '\n'			{ printf(";\n"); }
	| input L_COLOR_START		{ /*printf("colorStart: %x\n", yylval);*/ color = yylval; } // jesli nie color!=0 to error
	| input exp
	| input L_COLOR_END		{ /*printf("colorEnd\n");*/ color = 0; }
	;


exp:	  int
	| string
	| '='				{ printf("="); }
	;


int:	  L_INT_VAR			{ printf("int intZm_%x", color); } // jesli nie ma takiej zmiennej to "int" na poczatku
	| L_INT				{ printf("0x%x", color); }
	;


string:	  L_STRING_VAR			{ printf("string stringZm_%x", color); } // jesli nie ma takiej zmiennej to "string" na poczatku
	| L_STRING			{ printf("%s", (char*)yylval); free((char*)yylval); }
	;

%%

int yyerror( char* komunikat ) {
	printf("ERR_BISON: %s\n", komunikat );
}

int main() {
	if ( yyparse() )
	fprintf( stderr, "Successful parsing.\n" );
	else
	fprintf( stderr, "error found.\n" );
}
