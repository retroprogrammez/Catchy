--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	bonus.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Class 'Bonus'
--  Cette classe gère d'un bonus apparaissant de façon aléatoire
--
--	LOG :
--  26/04/2017	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constantes propres a la classe

-- Type de bonus
BONUS_TYPE_SWAP = 1
BONUS_TYPE_SCORE = 2
BONUS_TYPE_TELE = 3
BONUS_TYPE_VIE = 4
BONUS_TYPE_VITE = 5

-- Classe Bonus
Bonus = {}

-------------------------------------------------------------------------------
-- Constructor
--
function Bonus:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

-------------------------------------------------------------------------------
-- Init function
--
 function Bonus:init( ar, cat, surp)
  -- ar: arene
  -- cat : categorie (bonus ou monstre)
  -- surp : surprise si valeur a true
  
  -- membres identiques avec ceux de la classe Monstre
  self.cat = cat
  self.fin = false
  self.duree_vie = 4    -- duree de vie (en s) valeur par defaut
  self.sprite = {}
  self.sprite.gauche = nil
  self.sprite.droite = nil
  self.sprite.courant = nil
  
  -- membres spécifiques
  self.surprise = surp
  
  
  if self.surprise == true then
    self.sprite.courant = love.graphics.newImage("png/bonus-surprise.png")
  else
    if cat == BONUS_TYPE_SWAP then
      self.sprite.courant = love.graphics.newImage("png/bonus-swap.png")
    elseif cat == BONUS_TYPE_SCORE then
      self.sprite.courant = love.graphics.newImage("png/bonus-score.png")
    elseif cat== BONUS_TYPE_TELE then
      self.sprite.courant = love.graphics.newImage("png/bonus-tele.png")
    elseif cat == BONUS_TYPE_VIE then
      self.sprite.courant = love.graphics.newImage("png/bonus-vie.png")
    elseif cat == BONUS_TYPE_VITE then
      self.sprite.courant = love.graphics.newImage("png/bonus-vitesse.png")
    else
      error("Bonus:init() : categorie "..cat.." de bonus inconnue")
    end
  end
  self.largeur, self.hauteur = self.sprite.courant:getDimensions()
  self.x = math.random(ar.x, ar.xmax - self.largeur)
  self.y = math.random(ar.y, ar.ymax - self.hauteur)
  
end -- fin fonction Bonus:init()


-------------------------------------------------------------------------------
-- Calcul cyclique
--
function Bonus:update(ar, pa, dt)
  -- ar : inutilisé pour les bonus (ne pas supprimer)
  -- pa : idem
  
  -- calcul de la duree restante et fin eventuelle
  self.duree_vie = self.duree_vie - dt
  if self.duree_vie < 0 then self.fin = true ; end
  
end

-------------------------------------------------------------------------------
-- Affichage graphique
--
function Bonus:draw()
  love.graphics.draw(self.sprite.courant, self.x , self.y)
end

-------------------------------------------------------------------------------
-- fonction detecte qu'un player est en contact avec Bonus
--
function Bonus:contact(player, jeu)
  -- player : player
  -- jeu : jeu en cours
  
  if Jeu_catchy:check_collision(self, player) == true then
    self.fin=true
    
    if self.cat == BONUS_TYPE_SWAP then
      jeu:change_chasseur()
	  
    elseif self.cat == BONUS_TYPE_SCORE then
      player:modif_score(100)
      player.board:set_bonus("Score !")
	  
    elseif self.cat == BONUS_TYPE_TELE then
      player:move_random(jeu.arene)
      player.board:set_bonus("Téléportation !")
	  
    elseif self.cat == BONUS_TYPE_VIE then
      player.board:set_bonus("Bonus vie !")
      player:modif_vie(1)
	  
    elseif self.cat == BONUS_TYPE_VITE then
      player.board:set_bonus("Supervitesse !")
      player:set_supervitesse()
	  
    else
      error("Erreur valeur Bonus.type = "..self.cat.." hors plage")  
    end
    
  end
end

