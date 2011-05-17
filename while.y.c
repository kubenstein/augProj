#include "globalne.y.c"

void startWhile() {
	NOINITIALIZE_NEW_VARS_FLAG = 1;

	// wyswietlenie kodu C
	printf("while( ");
}


void endWhile() {
	NOINITIALIZE_NEW_VARS_FLAG = 0;

	// wyswietlenie kodu C
	printf(" ) {\n");
}


void bulidConditionWhile( char* exp1, char* exp2, char* exp3 ) {
	printf( "%s %s %s", exp1, exp2, exp3 );
	free( exp1 );
	free( exp2 );
	free( exp3 );
}
