#include "globalne.y.c"

/* struktura funkcji */
typedef struct {
	long int idFunkcji;
	long int parametryId[1000];
	int parametryTyp[1000]; // 0 int; 1 string; -1 koniec listy
} funkcja;



/* funkcje bledu */
void noFuncError( long int idFunkcji ) {
	fprintf( stdout, "ERR_COMPILE: no function to call: #%06x\n", idFunkcji );
	exit(1);
}


void alreadyExistsFuncError( long int idFunkcji ) {
	fprintf( stdout, "ERR_COMPILE: function already exists: #%06x\n", idFunkcji );
	exit(1);
}



/* zmienna pomocnicza */
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
	p_p();
}

// ToDO: sprawdzanie tez po parametrach
void endDefFunc() {
		int i;
		for( i = 0; i < funkcjeSize; i++ ) {
			if( funkcje[ i ].idFunkcji == temp.idFunkcji ) { // taka samo idFunkcji
			alreadyExistsFuncError( temp.idFunkcji );
			}
		}

	// nie ma takiej funkcji - dodajemy
	funkcje[ funkcjeSize++ ] = temp;

	// wyswietlenie kodu C
	printf("void* nArg) {\n");

	// restartTempa
	resetTemp();
}



/* funkcje wywolywujace funkcje */

int czyTeSameParametry( funkcja f1, funkcja f2 ) {
		int p = 0;
		while( f1.parametryTyp[ p ] != -1 ) {
			if( f1.parametryTyp[ p ] != f2.parametryTyp[ p ] )
			return 0; // znaleziono nieidentycznosc
		p++;
		}
	return 1; // wszystkie params sa takie same
}


void startCallFunc( long int idFunkcji ) {
	resetTemp();
	temp.idFunkcji = idFunkcji;

	NOINITIALIZE_NEW_VARS_FLAG = 1;

	// wyswietlenie kodu C
	printf("function_%06x(", idFunkcji );
}


void addParamCallFunc( long int idZmiennej, int typ ) {
		int i = 0;
		while( temp.parametryTyp[ i ] != -1 ) i++; // znajdz koniec
	temp.parametryId[ i ] = idZmiennej;
	temp.parametryTyp[ i ] = typ;
	temp.parametryTyp[ i+1 ] = -1;

	// wyswietlenie kodu C
	p_p();
}


void endCallFunc() {
	int ok = 0;
		int i;
		for( i = 0; i < funkcjeSize; i++ )
			if( funkcje[ i ].idFunkcji == temp.idFunkcji )
				if( czyTeSameParametry( funkcje[ i ], temp ) ) {
				ok = 1;
				break;
				}


		if( !ok ) noFuncError( temp.idFunkcji ); // funkcja nie zostala znaleziona

	NOINITIALIZE_NEW_VARS_FLAG = 0;

	// wyswietlenie kodu C
	printf("NULL)");
}

