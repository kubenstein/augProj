#include <stdio.h>
#include <stdlib.h>

/* stos zmiennych intowych */
int zmienneInt[1000];
int zmienneIntSize = 0;

int funcDefZmienneInt[1000];
int funcDefZmienneIntSize = 0;

int czyNowyStos = 0;

void initInt( long int idZmiennej ) {
	int* tablica = zmienneInt;
	int* dlugosc = &zmienneIntSize;


		if( czyNowyStos ) {
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
	tablica[ (*dlugosc)++ ] = idZmiennej;
	printf("int intZm_%06x", idZmiennej );
}

void nowyStos() {
	funcDefZmienneIntSize = 0;
	czyNowyStos = 1;
}


void globalnyStos() {
	czyNowyStos = 0;
}



