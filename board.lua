--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	board.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Classe 'Board'
--  Classe de gestion du tableau d'affichage d'un player (1 par player)
--
--	LOG :
--  28/04/2017	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Board = {}

--------------------------------------------------------------------------------
-- Constructeur
--
function Board:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

--------------------------------------------------------------------------------
-- Fonction d'init
--
function Board:init(align)
  -- align : GAUCHE ou DROITE
  -- tail board des player
  self.largeur = 200
  self.hauteur = 300
  self.x = 0
  if align == GAUCHE then
    self.x = MARGES_GAUCHE
  elseif align == DROITE then
    self.x = WIN_LARGEUR - MARGE_DROITE - self.largeur
  else
    error("Alignement du Board inconnu :"..align)
  end
  self.y = MARGE_SUP
  
  self.img_coeur = love.graphics.newImage("png/vie.png")
  
  self.duree_aff_bonus = 2
  self.timers={}
  self.timers.aff_bonus = Minuteur:new()
  Minuteur:lance(0)     -- astuce pour finir l'init du timer
  self.msg_bonus = 0    -- pas de message à l'init
  
end

--------------------------------------------------------------------------------
-- fonction d'affichage d'un message de bonus pendant une durée
--
function Board:set_bonus(msg)
  -- msg : message de bonus
  self.timers.aff_bonus:lance(self.duree_aff_bonus)
  self.msg_bonus = msg
end

--------------------------------------------------------------------------------
-- Message bonus
--
function Board:tempo_bonus(dt)
  
  if self.timers.aff_bonus:update(dt) == true then
    self.msg_bonus = ""
  end
end

--------------------------------------------------------------------------------
-- Affichage graphique
--
function Board:draw(p)
  -- p : player
  
  local marge_gauche = 10
  local hligne = 15
  local f = 1
  local xi = self.x + self.largeur - p.largeur - 15
  local yi = self.y + 5
  
  love.graphics.setLineWidth( 2 )
  love.graphics.rectangle( "line", self.x, self.y, self.largeur, self.hauteur, 15, 15 )
  love.graphics.printf(p.nom, self.x + marge_gauche, self.y + hligne / 2 , self.largeur - marge_gauche, "left", 0, f, f)
  love.graphics.draw(p.sprite.droite, xi, yi)
  if p.chasseur == true then
    love.graphics.rectangle("line", xi, yi, p.largeur, p.hauteur )
  end
  love.graphics.printf("score : "..p.score, self.x + marge_gauche, self.y + 3 * hligne, self.largeur - marge_gauche, "left", 0, f, f)
  
  local i
  for i = 0, p.vies - 1 do
    love.graphics.draw(self.img_coeur ,self.x + marge_gauche + 40 * i, self.y + 4 * hligne )
    end
  love.graphics.setLineWidth(1)
  
  -- affichage du message de bonus si nécessaire
  if self.timers.aff_bonus:lire() > 0 then
    
    love.graphics.setColor(170 ,200, 50)
    love.graphics.rectangle( "fill", self.x + marge_gauche + 10, self.y + 200, 150, 30)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.msg_bonus, self.x + marge_gauche + 20, self.y + 205 , self.largeur - marge_gauche, "left", 0, f, f)
    love.graphics.setColor(255,255,255)
  end
  
end