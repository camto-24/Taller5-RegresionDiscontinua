*Taller 5




clear all
set more off


* Paths generales
global pc "C:\Users\xxxxxxx
cd "${pc}"

use "turquia.dta"



*Preparación: Eliminar el 5% de las obaservaciones aleatoriamente*

set seed 200524003

gen selecc=rbinomial(1,0.05)
drop if selecc==1


save "turquia2.dta", replace

***************
****Punto 2.a.	
*Ecuación principal, para toda la muestra, sin incluir controles y sin polinomio a lado y lado
****************
rename ilmvsm1994 X

gen X_m = X*i98
global fX X X_m

sum hischshr1520m hischshr1520f

replace hischshr1520m = hischshr1520m/100


reg hischshr1520f i98, cluster(prov_num)
outreg2 using "punto2.doc", replace nolabel title(Tabla: Impacto de partido islámico en el gobierno) ctitle(Mujer) se dec(3) keep(i98) nocons addtext(Controles, No, Ancho de banda, NA)

reg hischshr1520m i98, cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Hombre) se dec(3) keep(i98) nocons addtext(Controles, No, Ancho de banda, NA)

* 2b. Ecuación principal, para toda la muestra, con controles y con polinomio a lado y lado.
*Notas del paper: Covariates include the Islamic vote share, the number of vote-receiving parties, the share of the total population under 19 years, the share of the total population above 60, the gender ratio, log total population, dummies for municipality types, and province fixed effects
global controles vshr_islam1994 partycount lpop1994 ageshr19 ageshr60 sexr shhs merkezi merkezp subbuyuk buyuk i.prov_num

reg hischshr1520f i98 $fX $controles, cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Mujer) se dec(3) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, NA)



reg hischshr1520m i98 $fX $controles, cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Hombre) se dec(3) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, NA)
	
* 2c. Ecuación principal, para la submuestra a  h ̂ unidades alrededor del corte, con controles.
reg hischshr1520f i98 $fX $controles if inrange(X,-0.24,0.24), cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Mujer) se dec(3) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, 0.24)

reg hischshr1520m i98 $fX $controles if inrange(X,-0.24,0.24), cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Hombre) se dec(3) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, 0.24)

*2d. Ecuación principal, para la submuestra a  h ̂/2 unidades alrededor del corte, con controles.
reg hischshr1520f i98 $fX $controles if inrange(X,-0.12,0.12), cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Mujer) se dec(4) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, 0.12)

reg hischshr1520m i98 $fX $controles if inrange(X,-0.12,0.12), cluster(prov_num)
outreg2 using "punto2.doc", nolabel ctitle(Hombre) se dec(4) keep(i98) nocons addtext(Controles, Sí, Ancho de banda, 0.12)

** Pueden también explorar el comando rdplot para representar el efecto de forma
** gráfica. Y el comando rdrobust que nos da los anchos de banda óptimos (esto no lo pedimos en el taller)
rdplot hischshr1520f X, c(0) p(1) 
rdplot i89 X
rdplot hischshr1520m X, c(0) p(1)
rdrobust hischshr1520f X
*******
*Punto 4a
*********

kdensity X, kernel(epanechnikov)
graph export kdensity.jpg

*******
*Punto 4b
******

				
** Tengan en cuenta que aquí, debemos correr la regresión sin controles pero in-
** cluyendo el polinomio. 


reg i89 i98 $fX if inrange(X,-0.24,0.24), cluster(prov_num)
outreg2 using "punto4b.doc", replace nolabel ctitle(1984) se dec(4) keep(i98) nocons addtext(Controles, No, Ancho de banda, 0.24)

reg lpop1994 i98 $fX if inrange(X,-0.24,0.24), cluster(prov_num)
outreg2 using "punto4b.doc", nolabel ctitle(Logpop 1994) se dec(4) keep(i98) nocons addtext(Controles, No, Ancho de banda, 0.24)

