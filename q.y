%{
#include <stdio.h>
#include "logic.y.c"
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
%token L_END
%start input
%%

input:
	| input exp {printf(" ");} input
	| input '\n'
	;


exp:	  pustaInstrukcja
	| stringVar assign string 				{ printf(";\n"); }
	| intVar assign int					{ printf(";\n"); }
	| funcDef
	| whileDef
	| funcExec						{ printf(";\n"); }
	| end							{ printf(";\n"); }
	;


pustaInstrukcja: L_COLOR_START L_COLOR_END

 /* zmienne i wartosci */
stringVar:	L_COLOR_START stringVar_ L_COLOR_END
stringVar_:			L_STRING_VAR			{ printf("string strZm_%06x", yylval.color); }


intVar:	  	L_COLOR_START intVar_ L_COLOR_END
intVar_:			L_INT_VAR			{ initInt( yylval.color ); }


string:		L_COLOR_START string_ L_COLOR_END
string_:			L_STRING			{ printf("\"%s\"", yylval.string); free( yylval.string) }


int:		L_COLOR_START int_ L_COLOR_END
int_:				L_INT				{ printf("%d", yylval.color); }

 /* operatory */
assign:		L_COLOR_START assign_ L_COLOR_END
		| assign_
		;
assign_:			'='				{ printf(" = "); }


compare:	L_COLOR_START compare_ L_COLOR_END
		| compare_
		;
compare_:			'='				{ printf(" == "); }


lessThen:	L_COLOR_START lessThen_ L_COLOR_END
		| lessThen_
		;
lessThen_:			'<'				{ printf(" < "); }


moreThen:	L_COLOR_START moreThen_ L_COLOR_END
		| moreThen_
		;
moreThen_:			'>'				{ printf(" > "); }


 /* deklaracja funkcji */
funcDef:	L_COLOR_START funcDef_ L_COLOR_END funcDefArgs L_DEF_END	{ printf("void* nArg) {\n"); }
funcDef_:			L_FUNC_START			{ printf("void function_%06x( ", yylval.color); nowyStos(); }
funcDefArgs:
		| stringVar 	{ printf(","); } funcDefArgs
		| intVar 	{ printf(","); } funcDefArgs
		| pustaInstrukcja		 funcDefArgs
		;


 /* deklaracja petli */
whileDef:	L_COLOR_START whileDef_ L_COLOR_END whileCon L_DEF_END	{ printf(") {\n"); }
whileDef_:			L_WHILE_START			{ printf("while( "); }
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
end_:				L_END				{ printf("}"); globalnyStos(); }

 /* wywolanie funkcji */
funcExec:	  zeroArgsFunc


zeroArgsFunc:	L_COLOR_START zeroArgsFunc_ L_COLOR_END
zeroArgsFunc_:			L_FUNC_CALL			{ printf("function_%06x()", yylval.color); }

%%

int yyerror( char* komunikat ) {
	printf("ERR_BISON: %s\n", komunikat );
}

int main() {
	yyparse();
}
