#include "globalne.y.c"

/* funkcja bledow */
void noVarsError( long int idZmiennej ) {
	fprintf( stdout, "ERR_COMPILE: int variable never initialized: #%06x\n", idZmiennej );
	exit(1);
}



/* stosy zmiennych intowych */
int zmienneInt[1000];
int zmienneIntSize = 0;

int funcDefZmienneInt[1000];
int funcDefZmienneIntSize = 0;



/* funkcje zmiany stosow */
void nowyStos() {
	funcDefZmienneIntSize = 0;
	NEWHEAP_FOR_VARS_FLAG = 1;
}


void globalnyStos() {
	NEWHEAP_FOR_VARS_FLAG = 0;
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
			printf("intZm_%06x", idZmiennej );
			return;
			}
		}

		if( NOINITIALIZE_NEW_VARS_FLAG ) noVarsError( idZmiennej );

	tablica[ (*dlugosc)++ ] = idZmiennej;
	printf("int intZm_%06x", idZmiennej );
}
