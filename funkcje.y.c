#include "globalne.y.c"

/* zmienna determinujaca czy wykonywana funkcja to funkcja zolta */
int YELLOW_FUNC_FLAG = 0;


/* struktura funkcji */
typedef struct {
	long int idFunkcji;
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
	temp.parametryTyp[ i ] = typ;
	temp.parametryTyp[ i+1 ] = -1;

	// wyswietlenie kodu C
		if( typ ) printf("char* stringZm_%06x,", idZmiennej );
		else	  printf("int intZm_%06x,", idZmiennej );
}


void addIntParamDefFunc( char* idString ) {
	unsigned int idZmiennej;
	sscanf( idString,"%*['int intZm']_%06x", &idZmiennej );
	addParamDefFunc( idZmiennej, 0 );
	free( idString );
}


void addStringParamDefFunc( char* idString ) {
	unsigned int idZmiennej;
	sscanf( idString,"%*['char* stringZm']_%06x", &idZmiennej );
	addParamDefFunc( idZmiennej, 1 );
	free( idString );
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

		if( idFunkcji == 0xffff00 ) YELLOW_FUNC_FLAG = 1;
		else
		// wyswietlenie kodu C
		printf("function_%06x(", idFunkcji );
}


void addParamCallFunc( char* stringParametru, int typ ) {
		int i = 0;
		while( temp.parametryTyp[ i ] != -1 ) i++; // znajdz koniec
	temp.parametryTyp[ i ] = typ;
	temp.parametryTyp[ i+1 ] = -1;


		// wyswietlanie kodu c dla uprzywilejowanej zoltej funkcji
		if( YELLOW_FUNC_FLAG ) {
			if( typ ) printf("function_ffff00_s( %s );\n", stringParametru );
			else	  printf("function_ffff00_i( %s );\n", stringParametru );
		} else

		// wyswietlenie kodu C
		printf("%s,", stringParametru );
}


void addIntVarParamCallFunc( char* idString ) {
	addParamCallFunc( idString, 0 );
	free( idString );
}


void addStringVarParamCallFunc( char* idString ) {
	addParamCallFunc( idString, 1 );
	free( idString );
}


void addIntParamCallFunc( char* wartoscInta ) {
	addParamCallFunc( wartoscInta, 0 );
	free( wartoscInta );
}


void addStringParamCallFunc( char* wartoscStringa ) {
	addParamCallFunc( wartoscStringa, 1 );
	free( wartoscStringa );
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

	NOINITIALIZE_NEW_VARS_FLAG = 0;

		// akceptowanie uprzywilejowanej zoltej funkcji
		if( YELLOW_FUNC_FLAG ) {
		ok = 1;
		YELLOW_FUNC_FLAG = 0;
		} else
		// wyswietlenie kodu C
		printf("NULL);\n");

	if( !ok ) noFuncError( temp.idFunkcji ); // funkcja nie zostala znaleziona
}

