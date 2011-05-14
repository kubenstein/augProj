#include "globalne.y.c"


/* stos zmiennych intowych */
int zmienneInt[1000];
int zmienneIntSize = 0;

int funcDefZmienneInt[1000];
int funcDefZmienneIntSize = 0;


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

		if( NOINITIALIZE_NEW_VARS_FLAG ) exit(-1); // brak zmiennej

	tablica[ (*dlugosc)++ ] = idZmiennej;
	printf("int intZm_%06x", idZmiennej );
}

void nowyStos() {
	funcDefZmienneIntSize = 0;
	NEWHEAP_FOR_VARS_FLAG = 1;
}


void globalnyStos() {
	NEWHEAP_FOR_VARS_FLAG = 0;
}



