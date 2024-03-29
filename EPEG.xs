#ifdef __cplusplus
extern "C"
{
	#endif
	#include "EXTERN.h"
	#include "perl.h"
	#include "XSUB.h"
	#ifdef __cplusplus
}
#endif

static char *CLASS = 0;



//
//	Epeg Headers
//

#include </usr/local/include/Epeg.h>


static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}



//
//	Constants
//

static double
constant(char *name, int len, int arg)
{
    errno = EINVAL;
    return 0;
}



//
//	Wrapper
//

MODULE = EPEG		PACKAGE = EPEG		


double
constant(sv,arg)
    PREINIT:
		STRLEN len;
    INPUT:
		SV * sv
		char * s = SvPV(sv, len);
		int arg
    CODE:
		RETVAL = constant(s,len,arg);
    OUTPUT:
		RETVAL


Epeg_Image *
epeg_file_open( filename )
	const char * filename;
	PREINIT:
		int h, w;
	CODE:
		CLASS = "Epeg_Image";
		RETVAL = (Epeg_Image *)epeg_file_open( filename );
	OUTPUT:
		RETVAL


Epeg_Image *
epeg_memory_open( data, dataLen );
	unsigned char * data;
	int dataLen;
	CODE:
		CLASS = "Epeg_Image";
		RETVAL = (Epeg_Image *)epeg_memory_open( data, dataLen );
	OUTPUT:
		RETVAL


void
epeg_size_get( img )
	Epeg_Image * img;
	PREINIT:
		int h, w;
	PPCODE:
		epeg_size_get( img, &w, &h );
		XPUSHs( sv_2mortal( newSViv( w ) ) );
		XPUSHs( sv_2mortal( newSViv( h ) ) );


void
epeg_decode_size_set( img, w, h )
	Epeg_Image * img;
	int w;
	int h;
	CODE:
		epeg_decode_size_set( img, w, h );


void
epeg_decode_colorspace_set( img, colorspace )
	Epeg_Image * img;
	int colorspace;
	CODE:
		epeg_decode_colorspace_set( img, colorspace );
	

const char *
epeg_comment_get( img )
	Epeg_Image * img;
	CODE:
		RETVAL = epeg_comment_get( img );
	OUTPUT:
		RETVAL


void
epeg_comment_set( img, comment )
	Epeg_Image * img;
	const char *comment
	CODE:
		epeg_comment_set( img, comment );


void
epeg_quality_set( img, quality )
	Epeg_Image * img;
	int quality;
	CODE:
		epeg_quality_set( img, quality );


void
epeg_get_data( img )
	Epeg_Image * img;
	PREINIT:
		unsigned char * pOut = NULL;
		int outSize = 0;
	PPCODE:
		epeg_memory_output_set( img, &pOut, &outSize );
		epeg_encode( img );
		PUSHs(sv_2mortal(newSVpv( pOut, outSize )));
		free(pOut);


void
epeg_write_file( img, filename )
	Epeg_Image * img;
	const char * filename;
	CODE:
		epeg_file_output_set( img, filename );
		epeg_encode( img );


void
epeg_close( img )
	Epeg_Image * img;
	CODE:
		epeg_close( img );
