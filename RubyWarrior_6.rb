
class Player
 
 @searchLeft = false
 
  def canFight(warrior)
    if warrior.health < 15
      return false
    end
    return true
  end
  
  def checkCondition(warrior)
    
    if (warrior.feel:backward).captive?
      return "rescueBack"
    end
    
    if !@searchLeft
      return "escape"
    end    
    
    if warrior.feel.captive?
      return "rescue"
    end
    
    if warrior.feel.enemy?
      return "attack"
    end
    
    if isRangeAttack(warrior)
      if canFight(warrior)
        return "walk"
      end
      return "escape"
    end
    
    if warrior.health < 20
      return "rest"
    end
    
    return "walk"
  
  end
  
  def isRangeAttack(warrior)
    if @health != nil && @health > warrior.health
      return true
    end
    return false
  end
  
  def play_turn(warrior)
    state = checkCondition(warrior)

    
    case state
      when "rescue"
        warrior.rescue!
      when "rescueBack"
        warrior.rescue!:backward
        @searchLeft = true
      when "rest"
        warrior.rest!
      when "escape"
        warrior.walk!:backward
      when "attack"
        warrior.attack!
      when "walk"
        warrior.walk!
    end
    @health = warrior.health
    # cool code goes here
  end
end
  
