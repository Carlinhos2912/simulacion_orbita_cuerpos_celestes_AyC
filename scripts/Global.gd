extends Node

# 📌 Constantes importantes 
const UA_M= 1.496e11
const DAYS_SEC= 86400


const GRAVITATORY = 0.002959122083


"""
 # OG	  |		    SI			 |	Relativo
=============================================
 Masa	  |	  Masa del sol(kg)	 | 	 1 SM
		  |		  1.989e30		 |
=============================================
Distancia |	Unidad Astronomica(m)|	1 UA
		  |	      1.496e11	     |
=============================================
Tiempo	  | 	  Dias? (s)		 | 	1 D
		  |	  86400.00		 	 |
"""


# 🐊 Derivadas 
const DIST_UNIT = UA_M/100
const TIME_UNIT = 86400
const VELOCITY_UNIT = DIST_UNIT/TIME_UNIT
const MASS_UNIT = 1.989e30 
const GAME_UNIT = 25


const SCALE_FACTOR = DIST_UNIT
