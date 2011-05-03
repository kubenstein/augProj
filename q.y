%{
#include <stdio.h>
#define YYSTYPE long int
%}

%token L_STRING_VAR L_INT_VAR
%token L_STRING L_INT
%token L_COLOR_START L_COLOR_END
%token L_FUNC_START L_WHILE_START L_DEF_END
%token L_FUNC_CALL
%start input
%%

input:
	| input '\n'
	| input L_COLOR_START		{ printf("colorStart: %x\n", yylval); }
	| input exp
	| input L_COLOR_END		{ printf("colorEnd\n"); }
	;


exp:	  L_FUNC_CALL			{ printf("funcCALL\n"); }
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
