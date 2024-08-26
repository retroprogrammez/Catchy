--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	pan.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'Pan'
--  Implementation of a 'pan de mur'
--
--	LOG :
--  24/08/2023	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constants

-- Class
Pan = {}

-------------------------------------------------------------------------------
-- Constructor
--
function Pan:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

-------------------------------------------------------------------------------
-- Init function
--
 function Pan:init(ar)
  -- ar: arena
  
  -- members
  self.actif = true
  self.duree_vie = 100    -- duree de vie (en s) valeur par defaut
  self.x0 = 0
  self.y0 = 0
  self.x1 = 0
  self.y1 = 0
  
end


-------------------------------------------------------------------------------
-- Mise à jour cyclique
--
function Pan:update(ar, pa, dt)
  -- ar : arene
  -- pa : partie
  
  -- calcul de la duree restante et fin eventuelle
  self.duree_vie = self.duree_vie - dt
  if self.duree_vie < 0 then self.fin = true ; end
  
end

-------------------------------------------------------------------------------
-- Affiche des éléments graphiques
--
function Pan:draw()
  love.graphics.setColor(243,147,232)
  love.graphics.rectangle("fill", self.x0 , self.y0, self.largeur, self.hauteur, 3, 3)
  love.graphics.setColor(255, 255, 255)
end

-------------------------------------------------------------------------------
-- Detection qu'un player est en contact
--
function Pan:contact(player)
  -- player : player
  
  if Jeu_catchy:check_collision(self, player) == true then
    --self.fin=true
    player.x = player.x_prec
    player.y = player.y_prec

    
    
  end
end