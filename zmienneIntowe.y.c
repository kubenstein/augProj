#include "globalne.y.c"

/* funkcja bledow */
void noIntVarError( long int idZmiennej ) {
	fprintf( stderr, "ERR_COMPILE: int variable never initialized: #%06x\n", idZmiennej );
	exit(1);
}



/* funkcje wyswietlajace wyrazenia */
void intVar_assign_int( char* s1, char* s2, char* s3 ) {
	printf("%s %s %s;\n",s1,s2,s3);
	free(s1);
	free(s2);
	free(s3);
}


void intVar_assign_intVar( char* s1, char* s2, char* s3 ) {
	intVar_assign_int(s1,s2,s3); // tak sie sklada ze wyswietla sie tak samo
	NOINITIALIZE_NEW_VARS_FLAG = 0;
}



void int_comparator_int( char* int1, char* logicOpr, char* int2 ) { //zarowno intVar jak i int
	printf( "%s %s %s", int1, logicOpr, int2 );
	free( int1 );
	free( logicOpr );
	free( int2 );
}



/* funkcja inicjujaca zminna */
char* initInt( long int idZmiennej ) {
	int* tablica = zmienneInt;
	int* dlugosc = &zmienneIntSize;

	char* out;


		if( NEWHEAP_FOR_VARS_FLAG ) {
		tablica = funcDefZmienneInt;
		dlugosc = &funcDefZmienneIntSize;
		}


		int i;
		for( i = 0; i < *dlugosc; i++ ) {
			if( tablica[i] == idZmiennej ) {

			// out
			out = malloc( sizeof(char) * 13 );
			sprintf(out, "intZm_%06x", idZmiennej );
			return out;
			}
		}

		if( NOINITIALIZE_NEW_VARS_FLAG ) noIntVarError( idZmiennej );

	tablica[ (*dlugosc)++ ] = idZmiennej;

	// out
	out = malloc( sizeof(char) * 17 );
	sprintf(out, "int intZm_%06x", idZmiennej );

	return out;
}
