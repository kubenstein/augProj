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

