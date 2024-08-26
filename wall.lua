--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	wall.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'Wall'
--  Implementation of a single wall
--
--	LOG :
--  28/04/2017	DR	Creation
--  TODO: Several variations of the wall
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants

-- Class
Wall = {}

-------------------------------------------------------------------------------
-- Constructor
--
function Wall:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

-------------------------------------------------------------------------------
-- Init function
--
 function Wall:init(ar)
  -- ar: arena
  
  -- members
  self.fin = false
  self.duree_vie = 100    -- duree de vie (en s) valeur par defaut
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  self.x = ar.x + ar.largeur / 2
  self.y = ar.y + 250
  self.largeur = 10
  self.hauteur = ar.hauteur - 800
  
end


-------------------------------------------------------------------------------
-- Mise à jour cyclique
--
function Wall:update(ar, pa, dt)
  -- ar : arene
  -- pa : partie
  
  -- calcul de la duree restante et fin eventuelle
  self.duree_vie = self.duree_vie - dt
  if self.duree_vie < 0 then self.fin = true ; end
  
end

-------------------------------------------------------------------------------
-- Affiche des éléments graphiques
--
function Wall:draw()
  love.graphics.setColor(243,147,232)
  love.graphics.rectangle("fill", self.x , self.y, self.largeur, self.hauteur, 3, 3)
  love.graphics.setColor(255, 255, 255)
end

-------------------------------------------------------------------------------
-- Detection qu'un player est en contact
--
function Wall:contact(player)
  -- player : player
  
  if Jeu_catchy:check_collision(self, player) == true then
    --self.fin=true
    player.x = player.x_prec
    player.y = player.y_prec

    
    
  end
end