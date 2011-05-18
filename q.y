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
%type <string> logicOpr
%%

input:
	| input exp input
	| input '\n'
	;


exp:	  pustaInstrukcja
	| stringVar assign string 				{ stringVar_assign_string($1,$2,$3); }
	| stringVar assign stringVarDecl			{ stringVar_assign_stringVar($1,$2,$3); }
	| intVar assign int					{ intVar_assign_int($1,$2,$3); }
	| intVar assign intVarDecl				{ intVar_assign_intVar($1,$2,$3); }
	| funcDef
	| whileDef
	| funcExec
	| end							{ p_s(); }
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


 /* deklaracja funkcji */
funcDef:	L_COLOR_START funcDef_ L_COLOR_END funcDefArgs L_DEF_END	{ endDefFunc(); }
funcDef_:			L_FUNC_START			{ nowyStos(); startDefFunc( yylval.color); }
funcDefArgs:
		| stringVar 	{ addStringParamDefFunc( $1 );}	funcDefArgs
		| intVar 	{ addIntParamDefFunc( $1 ); }	funcDefArgs
		| pustaInstrukcja				funcDefArgs
		;

 /* block end */
end:		L_COLOR_START end_ L_COLOR_END
		| end_
		;
end_:				L_END				{ p("}"); globalnyStos(); }


 /* deklaracja petli */
whileDef:	L_COLOR_START whileDef_ L_COLOR_END whileCon L_DEF_END	{ endWhile(); }
		| whileDef_ whileCon L_DEF_END			{ endWhile(); }
		;
whileDef_:			L_WHILE_START			{ startWhile(); }
whileCon:	  intCon
		| stringCon
		;


intCon:		  intVar logicOpr intVar			{ int_comparator_int($1,$2,$3); }
		| intVar logicOpr int				{ int_comparator_int($1,$2,$3); }
		| int logicOpr intVar				{ int_comparator_int($1,$2,$3); }
		| int logicOpr int				{ int_comparator_int($1,$2,$3); }
		;


stringCon:	  stringVar compare stringVar			{ string_compare_string($1,$2,$3); }
		| stringVar compare string			{ string_compare_string($1,$2,$3); }
		| string compare stringVar			{ string_compare_string($1,$2,$3); }
		;

logicOpr: 	  compare					{ $$ = $1; }
		| lessThen					{ $$ = $1; }
		| moreThen					{ $$ = $1; }
		;


/* wywolanie funkcji */
funcExec:	L_COLOR_START funcExec_ L_COLOR_END funcParam L_DEF_END	{ endCallFunc(); }
funcExec_:			L_FUNC_CALL			{ startCallFunc( yylval.color ); }
funcParam:
		| stringVar 	{ addStringVarParamCallFunc( $1 ); }	funcParam
		| intVar 	{ addIntVarParamCallFunc( $1 ); }	funcParam
		| string 	{ addStringParamCallFunc( $1 ); }	funcParam
		| int	 	{ addIntParamCallFunc( $1 ); }		funcParam
		| pustaInstrukcja					funcParam
		;
%%

int yyerror( char* komunikat ) {
	fprintf(stderr, "ERR_BISON: %s at line: %d\n", komunikat, yylloc.first_line );
	exit(1);
}


int main() {
	header();
	yyparse();
	footer();
}
