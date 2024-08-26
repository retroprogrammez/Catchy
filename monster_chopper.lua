--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	monster_chopper.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'MonsterChopper'
--  Implementation of chopper monster. Derivated from clase Monster
--
--	LOG :
--  17/05/2021 	DR	New module
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants


--------------------
-- Class 
MonsterChopper = Monster:new()

-------------------------------------------------------------------------------
-- init function
--
 function MonsterChopper:init(ar)
  -- ar: arena

  self.fin = false
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil

  self.son_apparition = Jeu_catchy.son_apparition_hachy
  self.type_contact = MSTR_CONTACT_VIE_MOINS
  self.duree_vie= 10
  self.vitesse = 70
  self.type_depl = MSTR_DEPL_PLAYER_PROCHE
  self.sprite.courant = love.graphics.newImage("png/monstre-hacheur-48.png")
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = math.random(ar.x, ar.xmax - self.largeur)
  self.y = math.random(ar.y, ar.ymax - self.hauteur)
      

  -- son d'apparition du monstre
  if self.son_apparition ~= nil then self.son_apparition:play() ; end
  
end


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function MonsterChopper:deplace(ar, jeu, dt)
  -- ar : arena
  -- jeu : jeu en cours
  
  local target -- player cible du monstre
  -- determination de la cible
  local d1 = Jeu_catchy:carre_distance(self, jeu.player1)
  local d2 = Jeu_catchy:carre_distance(self, jeu.player2)
    
   if d1 < d2 then target = jeu.player1 ; else target = jeu.player2 ; end
      
    -- on se rapproche de la cible
  if self.x > target.x then
    self.x = self.x - self.vitesse * dt
  else
    self.x = self.x + self.vitesse * dt
  end

  if self.y > target.y then
    self.y = self.y - self.vitesse * dt
  else
    self.y = self.y + self.vitesse * dt
  end
		  
end




	
