
class Player
 
  def canFight(warrior)
    if warrior.health < 15
      return false
    end
    return true
  end
  
  def danger(warrior)
    if warrior.health < 12
      return true
    end
      return false
  end
  
  def checkCondition(warrior)
    
    (warrior.look:backward).each do |space|
      if space.enemy?
        return "walk"
      end
    end
    
    if warrior.feel.wall?
      return "pivot"
    end
    
    if (warrior.feel:backward).captive?
      return "rescueBack"
    end
    
    
    if warrior.feel.captive?
      return "rescue"
    end
    
    if warrior.feel.enemy?
      return "attack"
    end
    
    warrior.look.each do |space|
      if space.captive?
        return "walk"
      end
      if space.enemy?
        return "shoot"
      end
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
      when "shoot"
        warrior.shoot!
      when "rescue"
        warrior.rescue!
      when "pivot"
        warrior.pivot!
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
  
