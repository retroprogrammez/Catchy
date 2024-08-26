--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  PROJECT :	Catchy
--  
--	MODULE :	minuteur.lua
--
--	AUTHOR : Dominique Rioual
--  
--	DESCRIPTION :
--  
--	Classe 'Minuteur'
--  Cette classe implémente un minuteur (timer) à usage général
--
--	LOG :
--  01/05/2017	DR	Creation
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Constantes de cette classe


-- Class 
Minuteur = {}

--------------------------------------------------------------------------------
-- Constructeur de la classe
function Minuteur:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Minuteur:lance(duree)
  -- duree : duree du timer en secondes
  if duree >= 0 then
    self.duree = duree
    self.t_restant = duree
    self.echu = false
  else
    error("Minuteur - duree incorrecte : "..duree)
  end
  
end

function Minuteur:lire()
  return self.t_restant
end

function Minuteur:lire_prop()
  return self.t_restant  / self.duree
end

function Minuteur:update(dt)
  self.t_restant = self.t_restant - dt
  if self.t_restant < 0 then
    self.echu = true
  end
  return self.echu
end

  
