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


#endif
