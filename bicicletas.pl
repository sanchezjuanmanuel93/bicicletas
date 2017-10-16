:-dynamic(caracteristica/2).
:-dynamic(info/2).
:-dynamic(tipo/2).

:-dynamic(si/1).
:-dynamic(no/1).


inicio:- preguntaMenu.

preguntaMenu:- abrir,
               writeln('Bienvenido al sistema de recomendacion de bicicletas'),
               writeln('Que desea hacer: 1- Solicitar una recomendacion, 2- Salir'),
               read(R),
               menu(R).

menu(1):- info(CodigoTipo, ListaCaracteristicas), validaAtributos(ListaCaracteristicas), validaBicicleta(CodigoTipo, ListaCaracteristicas).
menu(1):- writeln('No tenemos ninguna bicicleta adecuada para usted.').
menu(_):- writeln('Gracias por utilizar nuestro Sistema Experto').

% Hacemos dos reglas:
% - Una que agarra una bicicleta y va comparando la lista de
% caracteristicas
% - Otra q sirve para realizar la pregunta de la comparacion de cada
% atributo de una bicicleta

validaAtributos([]).
validaAtributos([H|_]):- no(H), !, fail.
validaAtributos([_|T]):- validaAtributos(T).

validaBicicleta(CodigoTipo,[]):- writeln('La bicicleta recomendada es: '), writeBicicleta(CodigoTipo), preguntaMenu.
validaBicicleta(CodigoTipo,[H|T]):- validaProxPregunta(H, CodigoTipo),!, validaBicicleta(CodigoTipo, T).

% Busca por cada uno de los atributos, si se respondio por si o por no.
% Si encuentra el atributo en la lista de SI, debe buscar la proxima pregunta
% Si encuentra el atributo en la lista de No, debe eliminar la bicicleta y busca por la proxima bicicleta.
% Si no esta en ninguna de las dos, pregunta el atributo.
validaProxPregunta(Caracteristica, _):- si(Caracteristica).
validaProxPregunta(Caracteristica, _):- no(Caracteristica),!, fail.
validaProxPregunta(Caracteristica, CodigoTipo):- pregunta(Caracteristica, CodigoTipo).

% Esta regla hace la pregunta sobre una caracteristica de una bicicleta y devuelve true si la tiene y sino falla
pregunta(CodigoCaracteristica, CodigoTipo):-
                caracteristica(CodigoCaracteristica, DescripcionCaracteristica),
                write(DescripcionCaracteristica),
                writeln('?'),
                writeln('Ingrese respuesta (s o n)'),
                read(Respuesta),
                validaResp(Respuesta, CodigoCaracteristica, CodigoTipo).

guardaSi(X):- asserta(si(X)). %Guarda un registro de si('caracteristica')
guardaNo(X):- asserta(no(X)). %Guarda un registro de no('caracteristica')

validaResp('s',CodigoCaracteristica ,_):- guardaSi(CodigoCaracteristica).
validaResp(Respuesta, CodigoCaracteristica, CodigoTipo):- Respuesta \= 'n', writeln('Ingrese la respuesta correctamente (s o n)'), read(Respuesta), validaResp(Respuesta,CodigoCaracteristica, CodigoTipo).
validaResp('n', CodigoCaracteristica, _):- guardaNo(CodigoCaracteristica), fail.

writeBicicleta(CodigoTipo):- write('Codigo: '),
                             writeln(CodigoTipo),
                             tipo(CodigoTipo, DescripcionTipo),
                             writeln(DescripcionTipo).

abrir:- retractall(caracteristica(_,_)),
        retractall(info(_,_)),
        retractall(tipo(_,_)),
        retractall(si(_)),
        retractall(no(_)),
        consult("C:/TP4/bicicletas/bd_caracteristica.pl"),
        consult("C:/TP4/bicicletas/bd_info"),
        consult("C:/TP4/bicicletas/bd_tipo.pl").
