--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_fireball.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonstreFireball'
--  Implementation of "monster" fireball (spit by dragon).
--  Derivated from clase Monster
--
--	LOG :
--  17/05/2021 	DR	New module
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants


--------------------
-- Class MonstreFireball
MonsterFireball = Monster:new()



-------------------------------------------------------------------------------
-- init function
--
 function MonsterFireball:init( x, y, dir)

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  
  self.x = x
  self.y = y
  self.direction = dir   

  self.son_apparition = Jeu_catchy.son_souffle_dragon
  self.type_contact = MSTR_CONTACT_FIN_MANCHE
  self.duree_vie = 5
  self.vitesse = 350
  if self.direction == GAUCHE then
    self.sprite.courant = love.graphics.newImage("png/boule-feu-gauche.png")
	self.type_depl = MSTR_DEPL_GAUCHE
  elseif self.direction == DROITE then
	self.sprite.courant = love.graphics.newImage("png/boule-feu-droite.png")
	self.type_depl = MSTR_DEPL_DROITE
  else
	error("Direction inconnue :"..self.direction)
  end
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = self.x - self.largeur / 2

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterFireball:deplace(ar, jeu, dt)
  -- ar : arene
  -- jeu : jeu en cours
  
  -- Déplacement horizontal
  --
  if self.direction == GAUCHE then
	self.x = self.x - self.vitesse * dt	
  else
	self.x = self.x + self.vitesse * dt
  end
		  
end




	
