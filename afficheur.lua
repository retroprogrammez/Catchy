--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	afficheur.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  Classe Afficheur (une seule instance)
--  Gère le panneau d'affichage des messages
--
--
--	LOG :
--  23/04/2021	DR	Reprise du module pour le transformer en classe
--
--
--	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Afficheur = {}

-------------------------------------------------------------------------------
-- Constructeur
--
function Afficheur:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  
  -- membres
  self.x = 0
  self.y = 0
  self.largeur = 0
  self.hauteur = 0
  
  return o

end

-------------------------------------------------------------------------------
-- Fonction d'init
--
function Afficheur:init(x,y,l,h)
  self.x = x 
  self.y = y 
  self.largeur = l
  self.hauteur = h

end

-------------------------------------------------------------------------------
-- Affichage graphique
--
function Afficheur:draw(jeu)
  -- jeu : 
  local st = jeu.status
  local ar = jeu.arene
 
  if st == ST_MANCHE_ATTENTE or st == ST_MANCHE_INITIALE then
    love.graphics.printf("Appuyez sur espace pour commencer", ar.x, ar.y, ar.largeur, "center")
    
  elseif st == ST_MANCHE_EN_COURS then
    love.graphics.printf("Combat en cours", ar.x, ar.y, ar.largeur, "center")
    
  elseif st == ST_MANCHE_TERMINEE then
    love.graphics.printf("Le player "..jeu.gagnant_manche.nom.." a gagne la manche ! Presser <space> pour continuer", ar.x, ar.y, ar.largeur, "center")
      
  elseif st == ST_PARTIE_TERMINEE then
    love.graphics.setColor(170 ,50, 50)
    local x = ar.x + 100
    local y = ar.y + 200
    local l = ar.largeur - 200
    local h = 300
    love.graphics.rectangle( "fill", x, y, l, h, 15, 15)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont( Fonte_large )
    love.graphics.printf("GAME OVER : le player "..jeu.gagnant_partie.nom.." remporte la partie.", x +10, y+ 30, l, "center")
    love.graphics.printf("Voulez-vous rejouer ? (O/N)", x + 10, y + 120, l, "center")
    love.graphics.setColor(255,255,255)
    love.graphics.setFont( Fonte_normale )  
    
    
  else
    error("Erreur : valeur jeu.status = "..st.." hors plage")
  end

end
