:-dynamic(info/2).
:-dynamic(modelo/2).
:-dynamic(marca/2).
:-dynamic(origen/2).
:-dynamic(tipo/2).
:-dynamic(rodado/2).
:-dynamic(si/1).
:-dynamic(no/1).


inicio:-preguntaMenu.

preguntaMenu:-abrir, writeln('Bienvenido al sistema de recomendación de bicicletas'),
	 writeln('Que desea hacer: 1-Solicitar una recomendación, 2-Informar una compra, 3-Salir'),read(R), menu(R).

menu(1):- info(X,L), nl,validaAtributos(L), validaBicicleta(X,L).
menu(1):- writeln('No tenemos ninguna bicicleta adecuada para usted.'), preguntaMenu.
menu(2):- informarCompra.
menu(_):- writeln('Gracias por utilizar nuestro Sistema Experto').

informarCompra.

% hacemos dos reglas una que agarra una bicicleta y va comparando la
% lista de caracteristicas y otra q sirve para realizar la pregunta de
% la comparacion de cada atributo de una bicicleta

validaAtributos([]).
validaAtributos([H|_]):- no(H),!, fail.
validaAtributos([_|T]):- validaAtributos(T).

validaBicicleta(X,[]):- writeln('La bicicleta recomendada es: '), writeBicicleta(X), preguntaMenu.
validaBicicleta(X,[H|T]):- validaProxPregunta(H,X),!, validaBicicleta(X,T).

% Busca por cada uno de los atributos, si se respondio por si o por no.
% Si encuentra el atributo en la lista de SI, debe buscar la proxima
% pregunta,
% Si encuentra el atributo en la lista de No, debe eliminar la bebida y
% busca por la proxima bebida.
% Si no esta en ninguna de las dos, pregunta el atributo.
validaProxPregunta(X,_):- si(X).
%%validaProxPregunta(X,_):- no(X),!, fail.
validaProxPregunta(X,B):- pregunta(X,B).
%esta funcion hace la pregunta sobre una caracteristica de una bebida y devuelve true si la tiene y sino falla (faltaria completarla)

pregunta(H,B):- caracteristica(H, D),write(D),writeln('?'),writeln('s/n h:Hipotesis'), read(R), validaResp(R,H,B).

%ver como hacemos para q ocn R nos devuelva true o false dependiendo lo que conteste
guardaSi(X):- asserta(si(X)). %Guarda un registro de si('atributo')
guardaNo(X):- asserta(no(X)). %Guarda un registro de si('atributo')

validaResp('s',X,_):- guardaSi(X).
validaResp('h',S,B):- writeln('La hipotesis hasta el momento es: '), writeBicicleta(B),	!,pregunta(S,B).
validaResp(X,B,A):- X\='n',writeln('Ingrese s,n,h'), read(R), validaResp(R,B,A).
validaResp('n',X,_):- guardaNo(X), fail.

writeBicicleta(X):- write('Codigo:'),writeln(X),tipo(X, T), writeln(T), origen(X, O), writeln(O), marca(X, MAR), writeln(MAR), modelo(X, MOD), writeln(MOD), rodado(X, R), writeln(R).

abrir:- retractall(info(_,_)), retractall(si(_)), retractall(no(_)),
	consult("C:/TP4/bd_bicicletas.pl"),consult("C:/TP4/bd_modelo.pl"),consult("C:/TP4/bd_marca.pl"),consult("C:/TP4/bd_origen.pl")
        ,consult("C:/TP4/bd_tipo.pl"),consult("C:/TP4/bd_rodado"),consult("C:/TP4/bd_info").

