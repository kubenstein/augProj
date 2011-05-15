#include "globalne.y.c"

/* funkcja bledow */
void noIntVarError( long int idZmiennej ) {
	fprintf( stdout, "ERR_COMPILE: int variable never initialized: #%06x\n", idZmiennej );
	exit(1);
}


/* funkcja inicjujaca zminna */
void initInt( long int idZmiennej ) {
	int* tablica = zmienneInt;
	int* dlugosc = &zmienneIntSize;


		if( NEWHEAP_FOR_VARS_FLAG ) {
		tablica = funcDefZmienneInt;
		dlugosc = &funcDefZmienneIntSize;
		}


		int i;
		for( i = 0; i < *dlugosc; i++ ) {
			if( tablica[i] == idZmiennej ) {

			// wyswietlenie kodu c
			printf("intZm_%06x", idZmiennej );

			return;
			}
		}

		if( NOINITIALIZE_NEW_VARS_FLAG ) noIntVarError( idZmiennej );

	tablica[ (*dlugosc)++ ] = idZmiennej;

	// wyswietlenie kodu c
	printf("int intZm_%06x", idZmiennej );
}
