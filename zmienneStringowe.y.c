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

	printf("%s;\n",s1);
	printf("if( stringZm_%s ) free(stringZm_%s);\n",ids1,ids1);
	printf("stringZm_%s = malloc( sizeof(char) * strlen(%s));\n",ids1,s3);
	printf("strcpy( stringZm_%s,%s);\n",ids1,s3);
	free(s1);
	free(s2);
	free(s3);
}


void stringVar_assign_stringVar( char* s1, char* s2, char* s3 ) {
	stringVar_assign_string(s1,s2,s3); // odkad stringi z lexa przychodza w ciapkach wszysko jest tak samo
}


void string_compare_string( char* str1, char* compare, char* str2 ) {
	printf("strcmp( %s, %s ) != 0", str1, str2 );
	free(str1);
	free(compare);
	free(str2);
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
