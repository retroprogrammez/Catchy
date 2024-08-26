--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_strange.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonsterStrange'
--  Implementation of strange monster. Derivated from class Monster
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
MonsterStrange = Monster:new()

-------------------------------------------------------------------------------
-- init function
--
 function MonsterStrange:init(ar)
  -- ar: arena

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil


  self.type_contact = MSTR_CONTACT_SWAP
  self.duree_vie= 100
  self.vitesse = 180
  self.type_depl = MSTR_DEPL_PLAYER_CHASSEUR
  self.sprite.courant = love.graphics.newImage("png/monstre-biz-48.png")
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = math.random(ar.x, ar.xmax - self.largeur)
  self.y = math.random(ar.y, ar.ymax - self.hauteur)
  self.cible = nil
 

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterStrange:deplace(ar, game, dt)
  -- ar : arena
  -- game : current game
  
  local target -- target of the monster (current hunter)
    
  if game.player1.chasseur == true then self.cible = game.player1 ; else self.cible = game.player2 ; end
    
  -- on se rapproche de la cible
  if self.x > self.cible.x then
    self.x = self.x - self.vitesse * dt
  else
    self.x = self.x + self.vitesse * dt
  end

  if self.y > self.cible.y then
    self.y = self.y - self.vitesse * dt
  else
    self.y = self.y + self.vitesse * dt
  end
		  
end
