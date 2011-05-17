#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef GLOBALNE_GUARD
#define GLOBALNE_GUARD


/* globalne zmienne */
int NOINITIALIZE_NEW_VARS_FLAG = 0;	// czy w przypadku braku zmiennej tworzyc nowa
int NEWHEAP_FOR_VARS_FLAG = 0;		// czy odkladac zadeklarowane zmienne na nowym stosie



/* globalne funkcje */
void p( const char* k ) { printf(k); }
void p_s() { p(";\n");	}

char* rs( const char* in ) {
	char* out = malloc( sizeof(char) * strlen( in ) ); // bison zrobi free
	strcpy( out, in );
	return out;
}

char* ri( long int in ) {
	char temp[50];
	sprintf( temp, "%d", in );

	char* out = malloc( sizeof(char) * strlen( temp ) ); // bison zrobi free
	strcpy( out, temp );
	return out;
}



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


/* wyswietlanie poczatku pliku i konca */
void header() {
printf("\
#include <stdio.h>	\n\
#include <stdlib.h>	\n\
#include <string.h>	\n\n\
\
\
\
void function_ffff00( char* str, void* v ) {	\n\
	printf(\"%cs\",str);	\n\
}	\n\
	\n\
void function_ffff00( long int liczba, void* v ) {	\n\
	printf(\"%c06x\",liczba);	\n\
}	\n\
	\n\
int main() {\n",'%','%');
}

void footer() {
	printf("return 0;\n}\n");
}
#endif
