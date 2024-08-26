--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	page_accueil.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Module d'affichage de la page d'accueil du jeu 
--
--	LOG :
--  28/04/2017	DR	Creation
--  20/04/2021  DR  Ajout du monstre Draghy et des bonus
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Page_accueil = {}

--------------------------------------------------------------------------------
-- initialisation
--
function Page_accueil:init()
  Jeu_catchy.musique_intro:play()
  
  self.sprite_titre = love.graphics.newImage("png/titre-catchy.png")
  -- variables pour l'affichage des players
  self.x_pl1 = 400  -- position x du player 1
  self.x_pl2 = 600
  self.dir_player = DROITE
  self.vit_player = 5
  
  -- variables de gestion de l'affichage des monstres
  self.liste_monstres = {
	{"Draghy", "monstre-dragon-2.png"},
	{"Crachy",  "monstre-dragon-droite.png"},
	{"Zarbhy",  "monstre-biz-48.png"},
	{"Hachy",   "monstre-hacheur-48.png"},
	{"Meuhouhy", "monstre-taureau-72-droite.png"}
  }
  self.sprite_monstres = {}
  

  local i
  for i = 1, #self.liste_monstres do
    self.sprite_monstres[i] = love.graphics.newImage("png/"..self.liste_monstres[i][2])
  end
  
  self.largeur_monstre = 200  -- largeur d'affichage pour un monstre
  self.x_monstre_init = - self.largeur_monstre * #self.liste_monstres
  self.x_monstre = self.x_monstre_init
  
  
    -- variables de gestion des bonus
  self.liste_bonus = {
	{"Surprise", "bonus-surprise.png"},
	{"Vie", "bonus-vie.png"},
	{"Score", "bonus-score.png"},
	{"Téléportation", "bonus-tele.png"},
	{"Vitesse", "bonus-vitesse.png"},
	{"Changeur", "bonus-swap.png"}
  }
  self.sprite_bonus = {}
  
    for i = 1, #self.liste_bonus do
    self.sprite_bonus[i] = love.graphics.newImage("png/"..self.liste_bonus[i][2])
  end
  
  self.largeur_bonus = 160  -- largeur d'affichage pour un bonus
  self.x_bonus = WIN_LARGEUR
end

--------------------------------------------------------------------------------
-- Permet de faire disparaitre la page d'accueil
--
function Page_accueil:fin()
  Jeu_catchy.musique_intro:stop()
end

--------------------------------------------------------------------------------
-- affiche la page d'accueil
--
function Page_accueil:draw(p1,p2)

  love.graphics.setColor(10/255, 120/255, 185/255)
  local x = 0 
  local y = 0
  local l = WIN_LARGEUR
  local h = WIN_HAUTEUR
  
  local sprite = nil
  
  local sp_h = 0
  local sp_l = 0
  
  love.graphics.rectangle( "fill", x, y, l, h)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont( Fonte_large )
  x = 20
  y = y + 10
  
  sp_l, sp_h = self.sprite_titre:getDimensions()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.sprite_titre, x +10 , y )
  
  y = y + sp_h + 20
  love.graphics.setFont( Fonte_normale)
  love.graphics.setColor(170/255, 250/255, 170/255)
  love.graphics.printf("Un jeu crée par Titouan, Eliot et Dominique Rioual", x+150, y, l, "left")
  
  y = y + 120
  love.graphics.setFont( Fonte_large)
  love.graphics.setColor(194/255, 1, 193/255)
  love.graphics.printf("Avec deux players ...", x, y, l, "left")
  
  -- affichage des player
  -------------------------
  love.graphics.setColor(1, 1 ,1, 1)
  if self.dir_player == DROITE then
    love.graphics.draw(p1.sprite.droite, self.x_pl1, y)
    love.graphics.draw(p2.sprite.droite, self.x_pl2, y)
  else
    love.graphics.draw(p1.sprite.gauche, self.x_pl1, y)
    love.graphics.draw(p2.sprite.gauche, self.x_pl2, y)
  end
  
  y = y + p2.hauteur + 10
  love.graphics.setColor(194/255, 1, 193/255)
  love.graphics.printf(p1.nom, self.x_pl1, y, l, "left")
     
  love.graphics.setColor(1, 76/255, 134/255)
  love.graphics.printf(p2.nom, self.x_pl2, y, l, "left")
  
  if self.dir_player == DROITE then
    self.x_pl1 = self.x_pl1 + self.vit_player
    self.x_pl2 = self.x_pl2 + self.vit_player
  else
    self.x_pl1 = self.x_pl1 - self.vit_player
    self.x_pl2 = self.x_pl2 - self.vit_player
  end
  
  if self.x_pl1 > 700 then self.dir_player = GAUCHE ;end
  if self.x_pl1 < 350 then self.dir_player = DROITE ;end
  
  y = y + 70
  
  -- Affichage des monstres 
  love.graphics.setColor(243/255, 147/255, 232/255)
  love.graphics.printf("Et des monstres !!!", x, y, l, "left")
  y = y + 170
  love.graphics.setColor(1, 1, 1, 1)
  
  local i
  for i = 1, #self.liste_monstres do
    local x0 = self.x_monstre + (i-1) * self.largeur_monstre
    local sprite = self.sprite_monstres[i]
    sp_l, sp_h = sprite:getDimensions()
    love.graphics.draw(sprite, x0 + (self.largeur_monstre - sp_l) / 2  , y  - sp_h - 10)
    love.graphics.printf(self.liste_monstres[i][1], x0, y  , self.largeur_monstre, "center")
  end
  
  self.x_monstre = self.x_monstre + 2
  if self.x_monstre > WIN_LARGEUR then 
    self.x_monstre = self.x_monstre_init
  end
  
  y = y + 100
  love.graphics.setColor(243/255,147/255,232/255)
  love.graphics.printf("....pour vous aider attrapez les bonus !", x + 300, y, l, "left")
  
  -- Affichage des Bonus qui défilent de droite à gauche
  y = y + 120
  love.graphics.setColor(1, 1, 1, 1)
  for i = 1, #self.liste_bonus do
    local x0 = self.x_bonus + (i-1) * self.largeur_bonus
    local sprite = self.sprite_bonus[i]
    sp_l, sp_h = sprite:getDimensions()
    love.graphics.draw(sprite, x0 + (self.largeur_bonus - sp_l) / 2  , y  - sp_h - 10)
    love.graphics.printf(self.liste_bonus[i][1], x0, y  , self.largeur_bonus, "center")
  end
  
  self.x_bonus = self.x_bonus - 2
  if self.x_bonus < - (self.largeur_bonus * #self.liste_bonus)  then
	self.x_bonus = WIN_LARGEUR
  end
  
  y = y + 200
  love.graphics.setFont( Fonte_normale)
  love.graphics.printf("(...Pressez la barre d'espace pour commencer...)", x + 300, y, l, "left")
  love.graphics.setColor(255,255,255)
  love.graphics.setFont( Fonte_normale )
end

