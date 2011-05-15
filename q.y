%{
#include <stdio.h>
#include "globalne.y.c"
#include "zmienneIntowe.y.c"
#include "zmienneStringowe.y.c"
#include "funkcje.y.c"
#include "while.y.c"
%}

%locations

// yylval
%union {
	long int color;
	char* string;
}

%token L_STRING_VAR L_INT_VAR
%token L_STRING L_INT
%token <color> L_COLOR_START
%token L_COLOR_END
%token L_FUNC_START L_WHILE_START L_DEF_END
%token L_FUNC_CALL
%token L_END
%start input

%type <string> intVar intVar_ intVarDecl intVarDecl_
%type <string> stringVar stringVar_ stringVarDecl stringVarDecl_
%type <string> int
%type <string> string string_
%type <string> assign assign_
%type <string> compare compare_
%type <string> lessThen lessThen_
%type <string> moreThen moreThen_
%%

input:
	| input exp {p(" ");} input
	| input '\n'
	;


exp:	  pustaInstrukcja
	| stringVar assign string 				{ stringVar_assign_string($1,$2,$3); }
	| stringVar assign stringVarDecl			{ stringVar_assign_stringVar($1,$2,$3); }
	| intVar assign int					{ intVar_assign_int($1,$2,$3); }
	| intVar assign intVarDecl				{ intVar_assign_intVar($1,$2,$3); }
	;


pustaInstrukcja: L_COLOR_START L_COLOR_END

 /* zmienne i wartosci */
stringVar:	L_COLOR_START stringVar_ L_COLOR_END		{ $$ = $2; }
stringVar_:			L_STRING_VAR			{ $$ = initString( yylval.color ); }


stringVarDecl:	L_COLOR_START stringVarDecl_ L_COLOR_END	{ $$ = $2; }
stringVarDecl_:			L_STRING_VAR			{
								  NOINITIALIZE_NEW_VARS_FLAG = 1;
								  char* out = initString( yylval.color );
								  NOINITIALIZE_NEW_VARS_FLAG = 0;
								  $$ = out;
								 }


intVar:	  	L_COLOR_START intVar_ L_COLOR_END		{ $$ = $2; }
intVar_:			L_INT_VAR			{ $$ = initInt( yylval.color ); }


intVarDecl:	  	L_COLOR_START intVarDecl_ L_COLOR_END	{ $$ = $2; }
intVarDecl_:			L_INT_VAR			{
								  NOINITIALIZE_NEW_VARS_FLAG = 1;
								  char* out = initInt( yylval.color );
								  NOINITIALIZE_NEW_VARS_FLAG = 0;
								  $$ = out;
								 }


string:		L_COLOR_START string_ L_COLOR_END		{ $$ = $2; }
		| string_					{ $$ = $1; }
		;
string_:			L_STRING


int:		L_COLOR_START int_ L_COLOR_END			{ $$ = ri( $1 ); }
int_:				L_INT

 /* operatory */
assign:		L_COLOR_START assign_ L_COLOR_END		{ $$ = $2; }
		| assign_					{ $$ = rs(" = "); }
		;
assign_:			'='


compare:	L_COLOR_START compare_ L_COLOR_END		{ $$ = $2; }
		| compare_					{ $$ = rs(" == "); }
		;
compare_:			'='


lessThen:	L_COLOR_START lessThen_ L_COLOR_END		{ $$ = $2; }
		| lessThen_					{ $$ = rs(" < "); }
		;
lessThen_:			'<'


moreThen:	L_COLOR_START moreThen_ L_COLOR_END		{ $$ = $2; }
		| moreThen_					{ $$ = rs(" > "); }
		;
moreThen_:			'>'

%%

int yyerror( char* komunikat ) {
	fprintf(stdout, "ERR_BISON: %s at line: %d\n", komunikat, yylloc.first_line );
	exit(1);
}


int main() {
	yyparse();
}
