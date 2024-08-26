--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	game.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  Main class of the game
--
--
--	LOG :
--  02/05/21	DR	Creation du module
--
--
--	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Game = {}

-- CONSTANTES PROPRES A LA CLASSE
-- Etat (status) de la partie
ST_MANCHE_INITIALE = 1
ST_MANCHE_ATTENTE  = 2
ST_MANCHE_EN_COURS = 3
ST_MANCHE_TERMINEE = 4
ST_PARTIE_TERMINEE = 5
ST_PARTIE_REINIT   = 6


-- Types d'objet Extra ; monstre ou bonus
EXTRA_CAT_BONUS = 1
EXTRA_CAT_MONSTRE = 2

--------------------------------------------------------------------------------
-- Constructor
--
function Game:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  
  -- members
  self.all_extra = {}		-- table contenant tous les extras en cours (bonus, monstres, etc.)
  self.all_murs = {}		-- table contenant tous les murs
  self.barre_temps = {}  	-- Barregraphe du temps restant
  self.arene     = nil
  self.board1    = nil
  self.board2    = nil
  self.player1   = nil
  self.player2   = nil
  self.afficheur = nil
  
  return o
end

--------------------------------------------------------------------------------
-- Init function
--
function Game:init()
  --------------------
  -- Init sons + musique
   --------------------
  self.son_bascule = love.audio.newSource("wav/bascule.wav", "static")
  self.son_catchy = love.audio.newSource("wav/perdu.wav", "static")
  self.son_meuh = love.audio.newSource("wav/meuh.wav", "static")
  self.son_souffle_dragon = love.audio.newSource("wav/souffle-dragon.ogg", "static")
  self.son_hachement = love.audio.newSource("wav/hachement.ogg", "static")
  self.son_apparition_hachy = love.audio.newSource("wav/apparition-hachy.ogg", "static")
  
  self.musique_fond = love.audio.newSource("wav/Electronika.mp3", "static")
  self.musique_fond:setVolume(0.4)
  self.musique_intro = love.audio.newSource("wav/Belinda.mp3", "static")
  self.musique_intro:setVolume(0.7)
  --------------------
  -- init graphics
   --------------------
  -- configuration de l'affichage
  love.graphics.setDefaultFilter("nearest","nearest")
  love.window.setTitle("Super jeu !!!")
  love.window.setMode(WIN_LARGEUR, WIN_HAUTEUR)
  
  Fonte_large = love.graphics.newFont(24)
  Fonte_normale = love.graphics.newFont(16)
  love.graphics.setFont(Fonte_normale)
  
  --------------------
  -- Init du plateau 
  --------------------
  -- definition des tableaux d'affichage de chaque player
  self.board1 = Board:new() ; self.board1:init(GAUCHE)
  self.board2 = Board:new() ; self.board2:init(DROITE)
  
  -- Arène où se déplacent les joueurs
  self.arene = Arene:new() ; self.arene:init(self.board1, self.board2)
  
  -- creation des murs
  local m = Wall:new() ; m:init(self.arene)
  self.all_murs = m
  
  -- Zone d'affichage de messages
  self.afficheur = Afficheur:new()
  self.afficheur:init(self.arene.x + 100, self.arene.y + 100, 300, 100)
  
  -- Definition du barregraphe des temps
  self.barre_temps = { x = self.arene.x + 20 ; y = self.arene.ymax + 10 ; largeur = self.arene.largeur - 40 ; hauteur = 15 } 

  -- creation des deux personnages
  self.player1 = Player:new() ; self.player1:init(self.arene, "Albert", self.board1)
  self.player2 = Player:new() ; self.player2:init(self.arene, "Alphonse", self.board2)
  
  ----------------------
  -- init de la partie
  ----------------------
  self.status = ST_MANCHE_INITIALE          -- Etat (status) de la partie
  self.gagnant_partie = nil                 -- gagnant de la partie / pointe sur un player
  self.gagnant_manche = nil                 -- idem pour la manche
  
  self.timers = {}                          -- conteneur des minuteurs
  self.timers.chasseur = Minuteur:new() ; self.timers.chasseur:lance(TMAX_CHASSEUR)
  self.timers.bonus    = Minuteur:new() ;
  self.timers.monstres = Minuteur:new() ;
   
  self.flag_reinit = false        -- flag indiquant qu'il faut réinitialiser la partie
  
  self.extra = {}
  self.extra[EXTRA_CAT_BONUS] = {
    cat = EXTRA_CAT_BONUS;        
    proba_defaut = 15;            -- probabilite (en %) par defaut d'avoir un bonus a chaque tirage
    t_min = 2;                    -- duree minimum entre appation d'un bonus (en s)
    timer = self.timers.bonus  
  }
  self.extra[EXTRA_CAT_BONUS].proba = self.extra[EXTRA_CAT_BONUS].proba_defaut
  self.extra[EXTRA_CAT_BONUS].timer:lance(self.extra[EXTRA_CAT_BONUS].t_min)
    
  self.extra[EXTRA_CAT_MONSTRE] = {
    cat = EXTRA_CAT_MONSTRE;
    proba_defaut = 50;
    t_min = 3;
    timer = self.timers.monstres
  }
  self.extra[EXTRA_CAT_MONSTRE].proba = self.extra[EXTRA_CAT_MONSTRE].proba_defaut
  self.extra[EXTRA_CAT_MONSTRE].timer:lance(self.extra[EXTRA_CAT_MONSTRE].t_min)
  
end


-------------------------------------------------------------------------------
-- fonction de mise à jour des traitements
--
function Game:update(dt)

  if self.status ~= ST_MANCHE_EN_COURS then return ; end

  if self.flag_reinit == true then
    -- Initialisation à faire en début de manche
    self.flag_reinit = false
    
    -- suppression des bonus & monstres
    self.all_extra = {}
    
    -- teleportation des players  
    self.player1.perdu = false
    self.player2.perdu = false
    self.player1:move_random(self.arene)
    self.player2:move_random(self.arene)
    -- on change le chasseur
    self:change_chasseur()
    
  end
  
  -- gestion du temps restant pour le chasseur
  if self.timers.chasseur:update(dt) == true then
    self:change_chasseur()
  end
    
  -- gestion d'apparition des bonus et monstres
  self:cree_extra(self.extra[EXTRA_CAT_BONUS], dt)
  self:cree_extra(self.extra[EXTRA_CAT_MONSTRE], dt)
  
  -- gestion des mouvements des personnages
  self.player1:update(self.arene, dt)
  self.player2:update(self.arene, dt)
  
  -- gestion de tempo des board (pour affichage msg bonus)
  self.player1.board:tempo_bonus(dt)
  self.player2.board:tempo_bonus(dt)
  
  -- mise a jour des bonus et monstres
  for _,v in ipairs(self.all_extra) do
    v:update(self.arene, self,  dt)
  end
    
  -- detection de collison des players avec murs...
  self.all_murs:contact(self.player1)
  self.all_murs:contact(self.player2)
  
  -- detection de collision des players avec bonus & monstres
  for _,v in ipairs(self.all_extra) do
    v:contact(self.player1, self)
    v:contact(self.player2, self)
  end
  
  -- detection de collision entre players
  if Jeu_catchy:check_collision(self.player1, self.player2) == true then self:fin_manche_player() 
  end 
  
  -- destruction des extra en fin de vie
  for i,v in ipairs(self.all_extra) do
    if v.fin == true then
      table.remove(self.all_extra, i)
    end
  end

end -- fin update()

-------------------------------------------------------------------------------
-- fonction de mise à jour des éléments graphiques
--
function Game:draw()

  -- Affichage de l'arene
  love.graphics.setColor(255,255,255,255)
  self.arene:draw()

  -- Affichage boards des personnages
  self.board1:draw(self.player1)
  self.board2:draw(self.player2)

  -- affichage des murs
  self.all_murs:draw()
  
  -- Affichage des joueurs
  self.player1:draw()
  self.player2:draw()
  
  -- Affichage des bonus et monstres
  local b
  for _,b in ipairs(self.all_extra) do
    b:draw()
   end


-- Affichage baregraph temps restant
  b = self.barre_temps
  love.graphics.rectangle("line", b.x, b.y, b.largeur, b.hauteur);
  love.graphics.setColor(200,30,100)
  love.graphics.rectangle("fill", b.x, b.y, b.largeur * self.timers.chasseur:lire_prop(), b.hauteur);
  love.graphics.setColor(255,255,255,255)

-- Display messages
  self.afficheur:draw(self)

end -- end of draw()


--------------------------------------------------------------------------------
-- Fonction de creation aleatoire des bonus ou monstres (dénommés "extra")
-- Effectue un tirage aleatoire à intervalles reguliers
-- si pas de bonus, alors la probabilité est augmentée pour le coup suivant
--
function Game:cree_extra(extra, dt )
  -- pla :  plateau
  -- dt : temps 
  -- extra : data to manage bonus or monster
  
  -- tant que l'on n'a pas atteint l'écheance, pas de tirage de bonus
  if extra.timer:update(dt) == false then
    return
  end
  
  extra.timer:lance(extra.t_min)
  
  if math.random(1,100) < extra.proba then
    -- bonus ou monstre !
    -- la probabilite reprend la valeur par defaut
    extra.proba  = extra.proba_defaut	
    -- creation des bonus ou monstre
    if extra.cat == EXTRA_CAT_BONUS then
      self:cree_bonus()
    elseif extra.cat == EXTRA_CAT_MONSTRE then
      self:create_monsters()
    else
      error("fonction cree_extra() : cat inconnu")
    end
  else -- pas de bonus ; on augmente la probabilite (pour le coup suivant) 
    extra.proba = extra.proba + 10
  end -- fin if math.random 
end


-------------------------------------------------------------------------------
-- fonction de creation des bonus
--
function Game:cree_bonus()
  local i, surp
  for i = 1, math.random(1,3) do
    -- quel bonus va apparaitre ?
    -- A completer
    -- Bonus surprise ?
    if math.random( 1, 100 ) <= 30 then
      surp = true
    else
      surp = false
    end
	
	--self:insert_bonus(surp)
	local b
	b = Bonus:new() ; b:init(self.arene, math.random(BONUS_TYPE_SWAP, BONUS_TYPE_VITE), surp)
    table.insert(self.all_extra,  b)
    
  end
end

-------------------------------------------------------------------------------
-- fonction de creation des monstres
--
function Game:create_monsters()
  
  -- tirage aléatoire des monstres
  local i
  local nmax_monsters = 1
  local t_monster = math.random(MSTR_TYPE_BULL, MSTR_TYPE_DRAGON2)
 
  if t_monster == MSTR_TYPE_BULL then
    nmax_monsters = math.random(1,3)
  end
  
  for i = 1, nmax_monsters do
    self:add_monster_by_type(t_monster)
  end

end 

-------------------------------------------------------------------------------
-- Add a single new monster to the game corresponding to the type of monster
--
function Game:add_monster_by_type(t_monster)
  -- t_mon: type of monster
  local m
  
  if t_monster == MSTR_TYPE_BULL then
    m = MonsterBull:new(); m:init(self.arene)
	
  elseif t_monster == MSTR_TYPE_CHOPPER then
    m = MonsterChopper:new(); m:init(self.arene)
	
  elseif t_monster == MSTR_TYPE_STRANGE then
    m = MonsterStrange:new(); m:init(self.arene)
	
  elseif t_monster == MSTR_TYPE_DRAGON then
    m = MonsterDragon:new(); m:init(self.arene)

  elseif t_monster == MSTR_TYPE_DRAGON2 then
    m = MonsterDragon2:new(); m:init(self.arene)
	
  else
    m = Monster:new(); m:init(self.arene, t_monster)
  end
  
  table.insert(self.all_extra, m)
end 

-------------------------------------------------------------------------------
-- Insert a new monster into the extra table (monster as an input)
--
function Game:insert_monster(monster)

  table.insert(self.all_extra, monster)

end

-------------------------------------------------------------------------------
-- fonction de gestion de la fin d'une manche suite a rencontre entre deux 
-- players
function Game:fin_manche_player()
  local ar = self.arene
  local p1 = self.player1
  local p2 = self.player2
  
  self.status = ST_MANCHE_TERMINEE
  
  love.audio.pause(self.musique_fond)
  love.audio.play(self.son_catchy)
  
  if p1.chasseur == true then
    self.gagnant_manche = p1
    p1:modif_score(200)
    p2:pris()
    if p2.vies < 0 then 
      self:fin_partie()
      return
    end
    
  else
    self.gagnant_manche = p2
    p2:modif_score (200)
    p1:pris()
    if p1.vies < 0 then 
      self:fin_partie()
      return
    end
  end
end -- fin_manche_player()


-------------------------------------------------------------------------------
-- fonction de gestion de la fin d'une manche suite a rencontre avec monstre
--
function Game:fin_manche_monstre(player)
  -- player : player ayant touché le monstre
  
  self.status = ST_MANCHE_TERMINEE
  love.audio.pause(self.musique_fond)
  love.audio.play(self.son_catchy)
  
  -- recup du gagnant (l'autre player)
  if player == self.player2 then
    self.gagnant_manche = self.player1
  elseif player == self.player1 then
    self.gagnant_manche = self.player2
  else
    error ("Erreur function fin_manche_monstre() : player inconnu")
  end
  
  player:pris()
  if player.vies < 0 then 
    self:fin_partie()
  end
  
end

-------------------------------------------------------------------------------
-- fonction de gestion de la fin d'une partie
--
function Game:fin_partie()
  self.gagnant_partie = self.gagnant_manche
  self.status = ST_PARTIE_TERMINEE   
end

-------------------------------------------------------------------------------
--
function Game:change_chasseur()
  
  self.player1.chasseur = not self.player1.chasseur
  self.player2.chasseur = not self.player2.chasseur
  
  self.timers.chasseur:lance(TMAX_CHASSEUR)
  love.audio.play(self.son_bascule)
end

-------------------------------------------------------------------------------
--
function Game:keypressed(key)
  -- key : touche pressée
  local st = self.status
  
  if (st == ST_MANCHE_INITIALE) then
    if key == "space" then
	  love.audio.play(self.musique_fond)
      self.status = ST_MANCHE_EN_COURS
	end
  
  elseif (st == ST_MANCHE_ATTENTE or st == ST_MANCHE_TERMINEE) then
    if key == "space" then
	  love.audio.play(self.musique_fond)
      self.status = ST_MANCHE_EN_COURS
      self.flag_reinit = true
	end
  
  -- Si partie terminee, soit l'on quitte le jeu soit on recommence
  elseif (st == ST_PARTIE_TERMINEE ) then
    if key == "O" or key == "o" then
      self.status = ST_PARTIE_REINIT
	elseif key == "N" or key == "n" then
      love.event.quit()
    end  
  end
end

-------------------------------------------------------------------------------
-- Fonction de detection d'une collision entre deux objets rectangulaires
-- Les objets doivent avoir les variables x, y, hauteur, largeur
-- Peuvent etre des Player, des bonus, des monstres...
-- Renvoie true si collision, false sinon
function Game:check_collision(o1, o2)
  -- o1 : objet 1
  -- o2 : objet 2
  return o1.x < o2.x + o2.largeur and
         o2.x < o1.x + o1.largeur and
         o1.y < o2.y + o2.hauteur and
         o2.y < o1.y + o1.hauteur
end

-------------------------------------------------------------------------------
-- Fonction qui calcule et renvoie le carré de la distance entre deux objets
-- (players, monstres, bonus)
function Game:carre_distance(o1, o2)
  return (o1.x - o2.x)*(o1.x - o2.x) + (o1.y - o2.y)*(o1.y - o2.y)
end

