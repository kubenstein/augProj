#include "globalne.y.c"

/* funkcja bledow */
void noStringVarError( long int idZmiennej ) {
	fprintf( stdout, "ERR_COMPILE: int variable never initialized: #%06x\n", idZmiennej );
	exit(1);
}


/* funkcja inicjujaca zminna */
void initString( long int idZmiennej ) {
	int* tablica = zmienneString;
	int* dlugosc = &zmienneStringSize;


		if( NEWHEAP_FOR_VARS_FLAG ) {
		tablica = funcDefZmienneString;
		dlugosc = &funcDefZmienneStringSize;
		}


		int i;
		for( i = 0; i < *dlugosc; i++ ) {
			if( tablica[i] == idZmiennej ) {

			// wyswietlenie kodu c
			printf("stringZm_%06x", idZmiennej );
			return;
			}
		}

		if( NOINITIALIZE_NEW_VARS_FLAG ) noStringVarError( idZmiennej );

	tablica[ (*dlugosc)++ ] = idZmiennej;

	// wyswietlenie kodu c
	printf("char* stringZm_%06x", idZmiennej );
}
