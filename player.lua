--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	player.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Classe 'Player'
--  Cette classe gère un des deux joueurs qui se poursuivent
--
--	LOG :
--  26/04/2017	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constantes de cette classe

-- Class player...
Player = {}

--------------------------------------------------------------------------------
-- Constructeur
function Player:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

--------------------------------------------------------------------------------
-- Methode d'initialisation
--
function Player:init(ar, nom_player, my_board)
  -- ar :arene
  -- my_board : board affecte au player
  
  self.nom = nom_player
  self.board = my_board
  
  -- init des parametres par defaut
  self.score = 0
  self.vitesse_init = 400           	-- Vitesse initiale des players
  self.vitesse = self.vitesse_init
  self.supervitesse = false
  self.lenteur = false
  self.direction= DROITE
  
  self.timers = {}                    -- conteneur des minuteurs 
  
  self.vies_init = 3                  -- Nombre de vies initial
  self.vies_max = 4                   -- Nombre de vies max
  self.vies = self.vies_init
  self.perdu = false
  
  self.sprite = {}
  
  if self.nom == "Albert" then
    self.haut, self.bas, self.gauche, self.droite = "up", "down", "left", "right"
    self.sprite.gauche = love.graphics.newImage("png/player1-vert-48-gauche.png")
    self.sprite.droite = love.graphics.newImage("png/player1-vert-48-droite.png")
    self.sprite.courant = self.sprite.droite
    self.largeur, self.hauteur = self.sprite.courant:getDimensions()
    
    self.x = ar.x + 10
    self.y = ar.y + 10
    self.chasseur = true
    
  elseif self.nom == "Alphonse" then
    self.haut, self.bas, self.gauche, self.droite = "a", "q", "c", "v"
    self.sprite.gauche = love.graphics.newImage("png/player2-48-gauche.png")
    self.sprite.droite = love.graphics.newImage("png/player2-48-droite.png")
    self.sprite.courant = self.sprite.droite
    self.largeur, self.hauteur = self.sprite.courant:getDimensions()
    
    self.x = ar.xmax - self.largeur - 10
    self.y = ar.ymax - self.hauteur - 10
    self.chasseur = false
  
  else 
    error("Impossible d'initialiser le player inconnu : "..self.nom)
  end
  
  self.x_prec = self.x
  self.y_prec = self.y

end


--------------------------------------------------------------------------------
-- Calcul cyclique
--
function Player:update(ar, dt)
  -- ar : zone de deplacement - arene
  
  -- gestion minuteurs dont supervitesse
  if self.supervitesse == true then
    self.supervitesse = not self.timers.supervitesse:update(dt) 
    if self.supervitesse == false then
      self.vitesse = self.vitesse_init
      self.timers.supervitesse = nil
    end
  end
  if self.lenteur == true then
    self.lenteur = not self.timers.lenteur:update(dt) 
    if self.lenteur == false then
      self.vitesse = self.vitesse_init
      self.timers.lenteur = nil
    end
  end
 
  -- gestion des déplacements
  self.x_prec, self.y_prec = self.x, self.y
  if love.keyboard.isDown(self.gauche)  then
    self.x = self.x - self.vitesse * dt
    if self.x < ar.x then self.x = ar.x ; end
    self.direction=GAUCHE
    self.sprite.courant=self.sprite.gauche
  end
  
  if love.keyboard.isDown(self.droite) then
    self.x = self.x + self.vitesse * dt
    if self.x > ar.xmax - self.largeur then self.x = ar.xmax - self.largeur ; end
    self.direction=DROITE
    self.sprite.courant=self.sprite.droite
 end

  if love.keyboard.isDown(self.haut) then
    self.y = self.y - self.vitesse * dt
    if self.y < ar.y then self.y = ar.y ; end
    self.direction=HAUT
    end  
   
  if love.keyboard.isDown(self.bas) then
    self.y = self.y + self.vitesse * dt
    if self.y > ar.ymax - self.hauteur then self.y = ar.ymax - self.hauteur ;end
    self.direction=BAS
  end
end


--------------------------------------------------------------------------------
-- Passage en supervitesse
--
function Player:set_supervitesse()
  -- On annule la lenteur
  self.lenteur = false
  self.timers.lenteur = nil
  
  self.supervitesse = true
  self.timers.supervitesse = nil
  self.timers.supervitesse = Minuteur:new() ; self.timers.supervitesse:lance(5)
  self.vitesse = self.vitesse * 1.7
end

--------------------------------------------------------------------------------
-- Sortie de la supervitesse
--
function Player:set_lenteur()
  -- On annule la supervitesse 
  self.supervitesse = false
  self.timers.supervitesse = nil
  
  self.lenteur = true
  self.timers.lenteur = nil
  self.timers.lenteur = Minuteur:new() ; self.timers.lenteur:lance(5)
  self.vitesse = self.vitesse * 0.7
end

--------------------------------------------------------------------------------
-- Téléportation
--
function Player:move_random(ar)
  -- ar : zone de déplacement (Arène)
  self.x = math.random(ar.x, ar.xmax - self.largeur)
  self.y = math.random(ar.y, ar.ymax - self.hauteur)
end

--------------------------------------------------------------------------------
-- Gestion du nombre de vies
--
function Player:modif_vie(v)
  -- v : nombre de vies à ajouter ou a soustraire
  self.vies = self.vies + v
  if self.vies > self.vies_max then
    self.vies = self.vies_max
  elseif self.vies < 0 then
		self.vies = 0
	end
		
end

--------------------------------------------------------------------------------
-- Gestion du score
--
function Player:modif_score(sc)
  -- sc : score a ajouter ou a soustraire
  self.score = self.score + sc
  if self.score < 0 then
	self.score = 0
  end
		
end

--------------------------------------------------------------------------------
-- Fonction appelee lorsque le player s'est fait prendre
--
function Player:pris()
  self.perdu = true
  self.vies = self.vies - 1
end

--------------------------------------------------------------------------------
-- Affichage graphique
--
function Player:draw()
  local scale = 1
  
  if self.perdu == true then scale = 0.6 ; end
  love.graphics.draw(self.sprite.courant,self.x ,self.y, 0, scale, scale)

end
