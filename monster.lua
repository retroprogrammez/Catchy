--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monstre.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'Monster'
--  Implementation of a monster that can appear in the game anytime
--
--	LOG :
--  26/04/2017	DR	Creation
--  20/04/2021  DR  Changement du nom fichier sprite de DRAGON2
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants

-- Types of monster
MSTR_TYPE_BULL    =    20
MSTR_TYPE_CHOPPER =    21
MSTR_TYPE_STRANGE =    22
MSTR_TYPE_DRAGON =     23
MSTR_TYPE_DRAGON2 =    24
MSTR_TYPE_FIREBALL =   25
MSTR_TYPE_FIREHART =   26


-- Types de deplacement du monstre
MSTR_DEPL_STATIQUE = 0
MSTR_DEPL_HORIZ = 1
MSTR_DEPL_GAUCHE = 10
MSTR_DEPL_DROITE = 11
MSTR_DEPL_ZIGZAG = 3
MSTR_DEPL_PLAYER_PROCHE = 4		-- poursuite du player le + proche
MSTR_DEPL_PLAYER_CHASSEUR = 5 -- poursuite du chasseur
MSTR_DEPL_HAUT_BAS = 6        -- Du haut vers le bas

-- Comportement en cas de contact
MSTR_CONTACT_DISP = 0
MSTR_CONTACT_VIE_MOINS	= 1		-- une vie en moins
MSTR_CONTACT_FIN_MANCHE = 2		-- une vie en moins et fin de la manche
MSTR_CONTACT_SWAP = 3
MSTR_CONTACT_GEL = 4
MSTR_CONTACT_RALENTIE = 5
MSTR_CONTACT_SCORE = 6
MSTR_CONTACT_INVULNERABLE = 7
MSTR_CONTACT_VIE = 8



--------------------
-- Classe Monster
Monster = {}

--------------------------------------------------------------------------------
-- Constructor
--
function Monster:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  
  -- init des membres
  self.cat = nil
  self.fin = false
  self.duree_vie = 4    -- duree de vie (en s) valeur par defaut
  --self.sprite = {}
  --self.sprite.gauche = nil
  --self.sprite.droite = nil
  --self.sprite.courant = nil
  self.x = 0
  self.y = 0
  
  self.direction = nil
  self.vitesse = 0
  self.type_depl = MSTR_DEPL_STATIQUE
  self.type_contact = MSTR_CONTACT_DISP
  self.son_apparition = nil
  
  return o
end

-------------------------------------------------------------------------------
-- Init function
--
 function Monster:init( ar, cat, x, y, dir)
  -- ar: arene
  -- cat : categorie (ou type) de monstre
  -- dir : direction (optionnel)
  -- x, y : position (optionnelle)

  -- membres identiques avec ceux de la classe Bonus
  self.cat = cat

  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  
  self.x = x
  self.y = y
  
  self.direction = dir   
  

  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end -- fin fonction Monster:init()


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function Monster:update(ar, jeu, dt)
  -- ar : arene
  -- jeu : jeu en cours
  
  self:update_time_left(dt)
  if self.fin == true then return ; end
  self:deplace(ar, jeu, dt)
end


-------------------------------------------------------------------------------
-- function update_time_left
--
function Monster:update_time_left(dt)
 -- calcul de la duree restante et fin eventuelle
  self.duree_vie = self.duree_vie - dt
  if self.duree_vie < 0 then self.fin = true ; end

end
-------------------------------------------------------------------------------
-- Gestion des déplacements
--  
function Monster:deplace(ar, jeu, dt)  

  if self.type_depl == MSTR_DEPL_GAUCHE then
	self.x = self.x - self.vitesse * dt
		
  elseif self.type_depl == MSTR_DEPL_DROITE then
	self.x = self.x + self.vitesse * dt
		

    
  else
		-- On ne fait rien !
  end
		  
end

-------------------------------------------------------------------------------
-- Affichage graphique
--
function Monster:draw()
  love.graphics.draw(self.sprite.courant, self.x , self.y)
end

-------------------------------------------------------------------------------
-- fonction detecte qu'un player est en contact avec un monstre
--
function Monster:contact(player, pa)
  -- player : player
  -- pa : partie
  
  if Jeu_catchy:check_collision(self, player) == true then
    -- Le monstre doit disparaitre
    self.fin=true
    
    if self.type_contact == MSTR_CONTACT_FIN_MANCHE then
	  pa:fin_manche_monstre(player)
    
    elseif self.type_contact == MSTR_CONTACT_VIE_MOINS then
      Jeu_catchy.son_hachement:play()
      player:modif_vie(-1)
      
    elseif self.type_contact == MSTR_CONTACT_SWAP then
      pa:change_chasseur()
      
    elseif self.type_contact == MSTR_CONTACT_GEL then
      
    elseif self.type_contact == MSTR_CONTACT_RALENTIE then
      player:set_lenteur()
      
    elseif self.type_contact == MSTR_CONTACT_SCORE then
      player:modif_score(300)
      
    elseif self.type_contact == MSTR_CONTACT_INVULNERABLE then
      
    elseif self.type_contact == MSTR_CONTACT_VIE then
      player:modif_vie(1)
      
    else
			-- Rien à faire !!
	end
			
  end
end

	
