%{
#include <stdio.h>
%}

// yylval
%union {
	long int color;
	char* string;
}

%token L_STRING_VAR L_INT_VAR
%token L_STRING L_INT
%token L_COLOR_START L_COLOR_END
%token L_FUNC_START L_WHILE_START L_DEF_END
%token L_FUNC_CALL
%start input
%%

input:
	| input exp {printf(" ");} input '\n'		{ printf(";\n"); }
	;


exp:	| stringVar assign string
	| intVar assign int
	| funcDef L_DEF_END
	;


stringVar:	L_COLOR_START stringVar_ L_COLOR_END
stringVar_:			L_STRING_VAR			{ printf("string strZm_%06x", yylval.color); }


intVar:	  	L_COLOR_START intVar_ L_COLOR_END
intVar_:			L_INT_VAR			{ printf("int intZm_%06x", yylval.color); }


string:		L_COLOR_START string_ L_COLOR_END
string_:			L_STRING			{ printf("%s", yylval.string); }


int:		L_COLOR_START int_ L_COLOR_END
int_:				L_INT				{ printf("%d", yylval.color); }

assign:		L_COLOR_START assign_ L_COLOR_END
assign_:			'='				{ printf(" = "); }


funcDef:	L_COLOR_START funcDef_ L_COLOR_END funcArgs	{ printf("void* nArg) {} "); }
funcDef_:			L_FUNC_START			{ printf("void function_%06x( ", yylval.color); }
funcArgs:
		| stringVar 	{ printf(","); } funcArgs
		| intVar 	{ printf(","); } funcArgs
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
