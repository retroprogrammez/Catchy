--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_dragon.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonsterDragon'
--  Implementation of Dragon. Derivated from class Monster
--
--	LOG :
--  20/05/2021 	DR	New module
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants
MSTR_DRAGON_TEMPO_SPIT = 1		-- Tempo d'attente d'un crachat par le dragon

--------------------
-- Class 
MonsterDragon = Monster:new()

-------------------------------------------------------------------------------
-- init function
--
 function MonsterDragon:init(ar)
  -- ar: arena

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  
  self.type_contact = MSTR_CONTACT_RALENTIE
  self.duree_vie= 100
  self.vitesse = 200
  self.direction = GAUCHE
  self.type_depl = MSTR_DEPL_ZIGZAG
  self.sprite.gauche = love.graphics.newImage("png/monstre-dragon-gauche.png")
  self.sprite.droite = love.graphics.newImage("png/monstre-dragon-droite.png")
  self.sprite.courant = self.sprite.gauche
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = ar.xmax
  self.y = ar.y
  self.tempo_crache = MSTR_DRAGON_TEMPO_SPIT -- tempo avant de cracher
 

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterDragon:deplace(ar, game, dt)
  -- ar : arena
  -- game : current game
  
  -- gestion des déplacements en zigzag
  if self.direction == GAUCHE then
    self.x = self.x - self.vitesse * dt
    self.y = self.y + self.vitesse * 0.2 * dt
  else
    self.x = self.x + self.vitesse * dt
    self.y = self.y + self.vitesse * 0.2 * dt
  end
    
  if self.direction == DROITE and self.x > ar.xmax  then
    self.sprite.courant = self.sprite.gauche
    self.direction = GAUCHE
  end
  if self.direction == GAUCHE and self.x < ar.x - self.largeur then
    self.sprite.courant = self.sprite.droite
    self.direction = DROITE
  end
  
  -- gestion du crachat par le dragon (boule de feu ou flammes)
  self.tempo_crache = self.tempo_crache - dt
  if self.tempo_crache < 0 then
    -- Le dragon crache !!
    self.tempo_crache = MSTR_DRAGON_TEMPO_SPIT * (1 + math.random())
      
	local x0, y0
    if self.direction == GAUCHE then
	  x0 = self.x - 50
	  y0 = self.y + 25
	else
	  x0 = self.x + self.largeur + 50
	  y0 = self.y + 20
	end
	
	local m
	
    if math.random(1,100) < 20 then 
	  m = MonsterFirehart:new()
	  m:init(x0, y0, self.direction)
	else
	  m = MonsterFireball:new() 
	  m:init(x0, y0, self.direction)
	end
	
    game:insert_monster(m)
       
  end
		  
end




	
