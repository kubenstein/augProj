#include <stdio.h>
#include <stdlib.h>

// struktura funkcji
typedef struct {
	long int idFunkcji;
	long int parametryId[1000];
	int parametryTyp[1000]; // 0 int; 1 string; -1 koniec listy
} funkcja;


funkcja temp;


void resetTemp() {
	temp.idFunkcji = -1;
	temp.parametryTyp[0] = -1;
}


/* stos funkcji */
funkcja funkcje[1000];
int funkcjeSize = 0;


/* funkcje tworzace funkcje */
void startDefFunc( long int idFunkcji ) {
	resetTemp();
	temp.idFunkcji = idFunkcji;

	// wyswietlenie kodu C
	printf( "void function_%06x( ",idFunkcji );
}


// TODO: sprawdzenie czy juz nie ma takiego parametru
void addParamDefFunc( long int idZmiennej, int typ ) {
	int i = 0;
		while( temp.parametryTyp[ i ] != -1 ) i++; // znajdz koniec
	temp.parametryId[ i ] = idZmiennej;
	temp.parametryTyp[ i ] = typ;
	temp.parametryTyp[ i+1 ] = -1;

	// wyswietlenie kodu C
	printf(", ");
}

// ToDO: sprawdzanie tez po parametrach
void endDefFunc() {
		int i;
		for( i = 0; i < funkcjeSize; i++ ) {
			if( funkcje[ i ].idFunkcji == temp.idFunkcji ) { // taka samo idFunkcji
			exit(-1);
			}
		}

	// nie ma takiej funkcji - dodajemy
	funkcje[ funkcjeSize++ ] = temp;

	// wyswietlenie kodu C
	printf("void* nArg) {\n");

	// restartTempa
	resetTemp();
}

