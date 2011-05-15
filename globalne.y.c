#include <stdio.h>
#include <stdlib.h>

#ifndef GLOBALNE_GUARD
#define GLOBALNE_GUARD


/* globalne zmienne */
int NOINITIALIZE_NEW_VARS_FLAG = 0;	// czy w przypadku braku zmiennej tworzyc nowa
int NEWHEAP_FOR_VARS_FLAG = 0;		// czy odkladac zadeklarowane zmienne na nowym stosie



/* globalne funkcje */
void p( const char* k ) { printf(k); }
void p_s() { p(";\n");	}
void p_p() { p(",");	}



/* stosy zmiennych */
int zmienneString[1000];
int zmienneStringSize = 0;

int funcDefZmienneString[1000];
int funcDefZmienneStringSize = 0;

int zmienneInt[1000];
int zmienneIntSize = 0;

int funcDefZmienneInt[1000];
int funcDefZmienneIntSize = 0;



/* funkcje zmiany stosow */
void nowyStos() {
	funcDefZmienneIntSize = 0;
	funcDefZmienneStringSize = 0;
	NEWHEAP_FOR_VARS_FLAG = 1;
}


void globalnyStos() {
	NEWHEAP_FOR_VARS_FLAG = 0;
}

#endif
