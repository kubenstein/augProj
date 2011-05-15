#include "globalne.y.c"

/* funkcja bledow */
void noStringVarError( long int idZmiennej ) {
	fprintf( stdout, "ERR_COMPILE: int variable never initialized: #%06x\n", idZmiennej );
	exit(1);
}



/* funkcje wyswietlajace wyrazenia */
void stringVar_assign_string( char* s1, char* s2, char* s3 ) {
	char ids1[10];
	sscanf(s1, "%*s stringZm_%s",ids1);

	printf("%s;",s1);
	printf("if( stringZm_%s ) free(stringZm_%s);",ids1,ids1);
	printf("stringZm_%s = malloc( sizeof(char) * strlen(\"%s\"));",ids1,s3);
	printf("strcpy( stringZm_%s,\"%s\");",ids1,s3);
	free(s1);
	free(s2);
	free(s3);
}


void stringVar_assign_stringVar( char* s1, char* s2, char* s3 ) {
	// ...
	free(s1);
	free(s2);
	free(s3);
}



/* funkcja inicjujaca zminna */
char* initString( long int idZmiennej ) {
	int* tablica = zmienneString;
	int* dlugosc = &zmienneStringSize;

	char* out;

		if( NEWHEAP_FOR_VARS_FLAG ) {
		tablica = funcDefZmienneString;
		dlugosc = &funcDefZmienneStringSize;
		}


		int i;
		for( i = 0; i < *dlugosc; i++ ) {
			if( tablica[i] == idZmiennej ) {

			// out
			out = malloc( sizeof(char) * 16 );
			sprintf( out, "stringZm_%06x", idZmiennej );
			return out;
			}
		}

		if( NOINITIALIZE_NEW_VARS_FLAG ) noStringVarError( idZmiennej );

	tablica[ (*dlugosc)++ ] = idZmiennej;


	// out
	out = malloc( sizeof(char) * 22 );
	sprintf( out, "char* stringZm_%06x", idZmiennej );
	return out;
}
