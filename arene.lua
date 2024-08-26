--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	arene.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Classe 'Arene'. 
--  Classe de gestion du terrain ou se deplacent les players.
--  Une seule instance.
--
--	LOG :
--  30/04/2017	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Arene = {}

-------------------------------------------------------------------------------
-- Constructeur
--
function Arene:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  
  -- init des parametres par defaut
  return o
end

-------------------------------------------------------------------------------
-- Calcul cyclique
--
function Arene:init(b1, b2)
  -- b1 : board player 1
  -- b2 : board player 2
  self.x = b1.x + b1.largeur + DELTA_BOARD
  self.y = MARGE_SUP
  self.largeur = b2.x - b1.x - b1.largeur - 2 * DELTA_BOARD
  self.hauteur = WIN_HAUTEUR - MARGE_SUP - MARGE_INF
  self.xmax = self.x + self.largeur
  self.ymax = self.y + self.hauteur
end

-------------------------------------------------------------------------------
-- Affichage graphique
--
function Arene:draw()
  love.graphics.setLineWidth(2)
  love.graphics.rectangle( "line", self.x, self.y, self.largeur, self.hauteur, 15, 15 )
  love.graphics.setLineWidth(1)
end

