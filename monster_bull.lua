--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_bull.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonstreBull'
--  Implementation of bull monster. Derivated from clase Monster
--
--	LOG :
--  17/05/2021 	DR	New module
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants


--------------------
-- Class MonsterBull
MonsterBull = Monster:new()



-------------------------------------------------------------------------------
-- init function
--
 function MonsterBull:init(ar)
  -- ar: arene

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil

  self.son_apparition = Jeu_catchy.son_meuh
  self.type_contact = MSTR_CONTACT_FIN_MANCHE
  self.duree_vie = 15
  self.vitesse = 70 + math.random(1,40)
  self.type_depl = MSTR_DEPL_HORIZ
  self.direction = math.random(GAUCHE, DROITE)
  if self.direction == DROITE then
    self.sprite.courant = love.graphics.newImage("png/monstre-taureau-72-droite.png")
    self.largeur, self.hauteur = self.sprite.courant:getDimensions()
    self.x = ar.x - self.largeur - 20
    self.y = math.random(ar.y, ar.ymax - self.hauteur)
  else
    self.sprite.courant = love.graphics.newImage("png/monstre-taureau-72-gauche.png")
    self.largeur, self.hauteur = self.sprite.courant:getDimensions()
    self.x = ar.xmax + 20
    self.y = math.random(ar.y, ar.ymax - self.hauteur)
  end
      

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterBull:deplace(ar, jeu, dt)
  -- ar : arene
  -- jeu : jeu en cours
  
  -- Déplacement du monstre : horizontal
  --
  if self.direction == GAUCHE then
	self.x = self.x - self.vitesse * dt
		
  else
	self.x = self.x + self.vitesse * dt
		
  end
		  
end




	
