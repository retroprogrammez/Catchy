--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_dragon2.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonsterDragon2'
--  Implementation of the second Dragon. Derivated from class Monster
--
--	LOG :
--  20/05/2021 	DR	New module
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants


--------------------
-- Class 
MonsterDragon2 = Monster:new()

-------------------------------------------------------------------------------
-- init function
--
 function MonsterDragon2:init(ar)
  -- ar: arena

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  
  self.type_contact = MSTR_CONTACT_VIE_MOINS
  self.duree_vie= 10
  self.vitesse = 220
  self.direction = GAUCHE
  
  self.type_depl = MSTR_DEPL_HAUT_BAS
  self.sprite.gauche = love.graphics.newImage("png/monstre-dragon-2.png")
  self.sprite.droite = love.graphics.newImage("png/monstre-dragon-2.png")
  
  if math.random(1,100) < 50 then 
    self.direction = GAUCHE
	self.sprite.courant = self.sprite.gauche
  else 
    self.direction = DROITE
	self.sprite.courant = self.sprite.droite
  end
  
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = math.random(ar.x, ar.xmax - self.largeur)
  self.y = ar.y
 

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterDragon2:deplace(ar,game,dt)
  -- ar : arena
  -- game : current game
  
  self.y = self.y + self.vitesse * dt
end




	
