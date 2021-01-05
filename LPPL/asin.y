/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          2019-2020 <jbenedi@dsic.upv.es> **/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
%}

%token PARA_ PARC_ MAS_ MENOS_ POR_ DIV_
%token CTE_ 

%%

programa : listaDeclaraciones

/*****************************************************************************/

listaDeclaraciones: declaracion | listaDeclaraciones declaracion ;

/*****************************************************************************/

declaracion: declaracionVariable | declaracionFuncion ;

/*****************************************************************************/

declaracionVariable: tipoSimple id; | tipoSimple id [cte]; ;

/*****************************************************************************/

tipoSimple: int | bool ;

/*****************************************************************************/

declaracionFuncion: cabeceraFuncion bloque ;

/*****************************************************************************/

cabeceraFuncion: tipoSimple id ( parametrosFormales) ;

/*****************************************************************************/

parametrosFormales:  e |listaParametrosFormales ;

/*****************************************************************************/

listaParametrosFormales: tipoSimple id | tipoSimple id, listaParametrosFormales ;

/*****************************************************************************/

bloque: { declaracionVariableLocal listaInstrucciones return expresion ; } ;

/*****************************************************************************/

declaracionVariableLocal: e | declaracionVariableLocal declaracionVariable ;

/*****************************************************************************/

listaInstrucciones: e | listaInstrucciones instruccion ;

/*****************************************************************************/

instruccion: { listaInstrucciones } | instruccionAsignacion | instruccionSeleccion | instruccionEntradaSalida | instruccionIteracion ;

/*****************************************************************************/

instruccionAsignacion: id = expresion; | id [ expresion ] = expresion ;

/*****************************************************************************/

instruccionEntradaSalida: read (id); | id print ( expresion ) ;

/*****************************************************************************/

instruccionSeleccion: if ( expresion) instruccion else instruccion  ;

/*****************************************************************************/

instruccionIteracion: for ( expresionOpcional ; expresion; expresionOpcional ) instruccion

/*****************************************************************************/

expresionOpcional: e | expresion |id = expresion ;

/*****************************************************************************/

expresion: expresionIgualdad | expresion operadorLogico expresionIgualdad ;

/*****************************************************************************/

expresionIgualdad: expresionRelacional | expresionIgualdad operadorIgualdad expresionRelacional ;

/*****************************************************************************/

expresionRelacional: expresionAditiva | expresionRelacional operadorRelacional expresionAditiva ;

/*****************************************************************************/

expresionAditiva: expresionMultiplicativa | expresionAditiva operadorAditivo expresionMultiplicativa ;

/*****************************************************************************/

expresionMultiplicativa: expresionUnaria | expresionMultiplicativa operadorMultiplicativo expresionUnaria ;

/*****************************************************************************/

expresionUnaria: expresionSufija | operadorUnario expresionUnaria | operadorIncremento id ;

/*****************************************************************************/

expresionSufija: ( expresion ) | id operadorIncremento | id [ expresion ] | id ( parametrosActuales ) |id | constante ;

/*****************************************************************************/

parametrosActuales: e | listaParametrosActuales ;

/*****************************************************************************/

listaParametrosActuales: expresion | expresion, listaParametrosActuales ;

/*****************************************************************************/

constante: cte | true | false ;

/*****************************************************************************/

operadorLogico: && | || ;

/*****************************************************************************/

operadorIgualdad: == | != ;

/*****************************************************************************/

operadorRelacional: > | < | >= | <= ;

/*****************************************************************************/

operadorAditivo: + | - ;

/*****************************************************************************/

operadorMultiplicativo: * | / ;

/*****************************************************************************/

operadorUnario: + | - | ! ;

/*****************************************************************************/

operadorIncremento: ++ | --;




/**
    Falta: hacer BISON
    COmpilarlo y (hacer make o añadirlo a include)
**/

%%
/*****************************************************************************/
int verbosidad = FALSE;                  /* Flag si se desea una traza       */

/*****************************************************************************/
void yyerror(const char *msg)
/*  Tratamiento de errores.                                                  */
{ fprintf(stderr, "\nError en la linea %d: %s\n", yylineno, msg); }

/*****************************************************************************/
int main(int argc, char **argv) 
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{ int i, n=1 ;

  for (i=1; i<argc; ++i)
    if (strcmp(argv[i], "-v")==0) { verbosidad = TRUE; n++; }
  if (argc == n+1)
    if ((yyin = fopen (argv[n], "r")) == NULL) {
      fprintf (stderr, "El fichero '%s' no es valido\n", argv[n]) ;     
      fprintf (stderr, "Uso: cmc [-v] fichero\n");
    } 
    else yyparse();
  else fprintf (stderr, "Uso: cmc [-v] fichero\n");

  return (0);
} 
/*****************************************************************************/
