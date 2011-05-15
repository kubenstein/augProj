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

%type <color> intVar
%type <color> stringVar
%%

input:
	| input exp {p(" ");} input
	| input '\n'
	;


exp:	  pustaInstrukcja
	| stringVar assign string 				{ p_s(); }
	| intVar assign int					{ p_s(); }
	| funcDef
	| whileDef
	| funcExec						{ p_s(); }
	| end							{ p_s(); }
	;


pustaInstrukcja: L_COLOR_START L_COLOR_END

 /* zmienne i wartosci */
stringVar:	L_COLOR_START stringVar_ L_COLOR_END		{ $$ = $1; }
stringVar_:			L_STRING_VAR			{ initString( yylval.color ); }


intVar:	  	L_COLOR_START intVar_ L_COLOR_END		{ $$ = $1; }
intVar_:			L_INT_VAR			{ initInt( yylval.color ); }


string:		L_COLOR_START string_ L_COLOR_END
		| string_
		;
string_:			L_STRING			{ printf("\"%s\"", yylval.string); free( yylval.string) }


int:		L_COLOR_START int_ L_COLOR_END
int_:				L_INT				{ printf("%d", yylval.color); }

 /* operatory */
assign:		L_COLOR_START assign_ L_COLOR_END
		| assign_
		;
assign_:			'='				{ p(" = "); }


compare:	L_COLOR_START compare_ L_COLOR_END
		| compare_
		;
compare_:			'='				{ p(" == "); }


lessThen:	L_COLOR_START lessThen_ L_COLOR_END
		| lessThen_
		;
lessThen_:			'<'				{ p(" < "); }


moreThen:	L_COLOR_START moreThen_ L_COLOR_END
		| moreThen_
		;
moreThen_:			'>'				{ p(" > "); }


 /* deklaracja funkcji */
funcDef:	L_COLOR_START funcDef_ L_COLOR_END funcDefArgs L_DEF_END	{ globalnyStos(); endDefFunc(); }
funcDef_:			L_FUNC_START			{ nowyStos(); startDefFunc( yylval.color); }
funcDefArgs:
		| stringVar 	{ addParamDefFunc( $1, 1); }	funcDefArgs
		| intVar 	{ addParamDefFunc( $1, 0); }	funcDefArgs
		| pustaInstrukcja				funcDefArgs
		;


 /* deklaracja petli */
whileDef:	L_COLOR_START whileDef_ L_COLOR_END whileCon L_DEF_END	{ endWhile(); }
		| whileDef_ whileCon L_DEF_END			{ endWhile(); }
		;
whileDef_:			L_WHILE_START			{ startWhile(); }
whileCon:	  conExp logicOpr conExp
conExp:		  intVar
		| int
		;
logicOpr: 	  compare
		| lessThen
		| moreThen
		;


 /* block end */
end:		L_COLOR_START end_ L_COLOR_END
		| end_
		;
end_:				L_END				{ p("}"); globalnyStos(); }

 /* wywolanie funkcji */
funcExec:	L_COLOR_START funcExec_ L_COLOR_END funcParam L_DEF_END	{ endCallFunc(); }
funcExec_:			L_FUNC_CALL			{ startCallFunc( yylval.color ); }
funcParam:
		| stringVar 	{ addParamCallFunc( $1, 1); }	funcParam
		| intVar 	{ addParamCallFunc( $1, 0); }	funcParam
		| string 	{ addParamCallFunc( 0, 1); }	funcParam
		| int	 	{ addParamCallFunc( 0, 0); }	funcParam
		| pustaInstrukcja				funcParam
		;
%%

int yyerror( char* komunikat ) {
	fprintf(stdout, "ERR_BISON: %s at line: %d\n", komunikat, yylloc.first_line );
	exit(1);
}


int main() {
	yyparse();
}
