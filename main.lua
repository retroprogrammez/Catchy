--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	main.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--  Fonctions principales de love2D
--
--	LOG :
--  26/04/2017	DR	Creation
--  07/05/2021	DR	Reprise complete suite au développement de la classe Game
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- DEPENDANCES
--
require("page_accueil")
require("game")
require("board")
require("afficheur")
require("arene")
require("math")
require("player")
require("bonus")
require("monster")
require("monster_bull")
require("monster_chopper")
require("monster_strange")
require("monster_dragon")
require("monster_dragon2")
require("monster_fireball")
require("monster_firehart")
require("wall")
require("minuteur")

--------------------------------------------------------------------------------
-- CONSTANTES GLOBALES DU PROJET
--
-- Direction des players
GAUCHE, DROITE, HAUT, BAS = 1, 2, 3, 4
-- Taille fenêtre
WIN_LARGEUR, WIN_HAUTEUR = 1280, 1024
-- Marges 
MARGE_SUP, MARGE_INF, MARGES_GAUCHE, MARGE_DROITE = 25, 50, 10, 10
-- Distance entre board et arene
DELTA_BOARD = 10

TMAX_CHASSEUR = 10


--------------------------------------------------------------------------------
-- variables globales
--
Jeu_catchy = nil


--------------------------------------------------------------------------------
-- Chargement au démarrage
--
function love.load()
  -- initialisation du jeu
  Jeu_catchy = Game:new()
  Jeu_catchy:init()
  
  Accueil_jeu = true
  Page_accueil:init()
  
end

--------------------------------------------------------------------------------
-- Mise à jour cyclique
--
function love.update(dt)
  local v, i
  math.randomseed( os.time() )
  -- gestion de la partie en cours
  Jeu_catchy:update(dt)
  

end -- fin update()

--------------------------------------------------------------------------------
-- Affichage graphique
--
function love.draw()
  
  if Accueil_jeu == true then
    Page_accueil:draw(Jeu_catchy.player1, Jeu_catchy.player2)
    return
  end
  
  -- Affichage du plateau
  Jeu_catchy:draw()
 

end

--------------------------------------------------------------------------------
-- Gestion du clavier
--
function love.keypressed(key)
  
  if key =="space" and Accueil_jeu == true then
    Page_accueil:fin()
    Page_accueil = nil
    Accueil_jeu = false
    
  else
    Jeu_catchy:keypressed(key)
	if Jeu_catchy.status == ST_PARTIE_REINIT then
	  Jeu_catchy = nil
	  Jeu_catchy = Game:new() ; Jeu_catchy:init()
    end
  end
end

