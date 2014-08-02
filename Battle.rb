class Unit

  attr_accessor :stat,:name

  def initialize(name, stat, action)
    @name = name
    @stat = UnitStat.new(stat)
    @action = BattleAction.new(action)
  end

  def attack!(unit)
    raise "not implemented"
  end

  def damage!(dmg)
    for key in dmg.keys
      if dmg.has_key?(key)
        temp_dmg = @stat.get(key) - dmg[key]
        if temp_dmg < 0
          temp_dmg = 0
        end
        @stat.set(key, temp_dmg)
      end
    end
  end

  # need refactor...
  def cost!(cost)
    for key in dmg.keys
      if dmg.has_key?(key)
        temp_dmg = @stat.get(key) - dmg[key]
        @stat.set(key, temp_dmg)
      end
    end
  end

  def status
    return "\n%s\n%s\n%s" % [@name,"-"*10, @stat.get_status_str]
  end

  def get_dex
    return @stat.get(:DEX)
  end

  def alive?
    if (@stat.get :HP) <= 0
      return false
    end
    return true
  end

end

class Hero < Unit
  def attack!(unit)
    action = @action.getAction
    self.damage!(action.cost)
    return action.dmg.call(@stat, unit.stat)
  end
end

class Enemy < Unit
  def attack!(unit)
    action = @action.getAction
    self.damage!(action.cost)
    return action.dmg.call(@stat, unit.stat)
  end
end

class BattleAction

  class Result
    attr_accessor :cost, :dmg

    def initialize(cost, dmg)
      @cost = cost
      @dmg = dmg
    end
  end

  def self.result(cost, dmg)
    return Result.new(cost, dmg)
  end

  # need validate?
  def initialize(actions)
    @pattern = actions
  end

  def getAction
    key = @pattern.keys.shuffle[0]
    return @pattern[key]
  end

end

class UnitStat
  def initialize(hash)
    @stat_max = {
        HP: 100,
        MP: 100,
        EXP: 100
    }

    @stat = {
        HP: 100,
        MP: 100,
        EXP: 100,
        LV: 1,
        STR: 70,
        DEF: 50,
        DEX: 40
    }

    set_stat(hash)

  end

  def set_max(key, value)
    if not @stat_max.has_key?(key)
      raise key +"is not member of stat_max"
    end

    @stat_max[key] = value

  end

  def set(key, value)
    if not @stat.has_key?(key)
      raise key +"is not member of stat"
    end

    if value < 0
      raise "cannot set negative value"
    end

    if @stat_max.has_key?(key) and value > @stat_max[key]
      @stat[key] = @stat_max[key]
      return
      # raise "cannot set value grater than max"
    end

    temp_value = value
    if @stat[key] < value
      temp_value = 0
    end

    @stat[key] = temp_value
  end

  def get_max(key)
    return @stat_max[key]
  end

  def get(key)
    return @stat[key]
  end

  def get_status_str
    str= ""
    for stat in @stat.keys
      str += "%s : %d" % [stat, @stat[stat]]
      if @stat_max.has_key?(stat)
        str+= " / %d" % [@stat_max[stat]]
      end
      str += "\n"
    end
    return str
  end

  def set_stat(hash)
    for stat in hash.keys

      if !@stat.has_key?(stat)
        next
      end

      if @stat_max.has_key?(stat)
        @stat_max[stat] = hash[stat]
      end
      @stat[stat] = hash[stat]
    end
  end

end

class Battle

  TURN_COST = 30

  class Turn

    attr_accessor :attacker,:defender

    def initialize(attacker, defender)
      @attacker = attacker
      @defender = defender
    end

    def start
      dmg = @attacker.attack!(@defender)
      @defender.damage!(dmg)
      return dmg
    end

    def continue?
      return @defender.alive?
    end

  end

  def initialize(attacker, defender)
    @attacker = attacker
    @attacker_cost = attacker.get_dex
    @defender = defender
    @defender_cost = defender.get_dex
    @turn = make_turn
  end

  def start

    puts "battle start!!"

    while (@turn.continue?)
      @turn = make_turn
      result = @turn.start

      if result.has_key?(:HP)
        puts "\n%s는 %s에게 %d의 데미지를 입혔다!" % [@turn.attacker.name, @turn.defender.name, result[:HP]]
        puts @attacker.status
        puts @defender.status
      else
        puts "\n%s는 %s에게 데미지를 입히지 못했다!" % [@turn.attacker.name, @turn.defender.name]
      end

    end

    puts "battle end!!"
    puts "\n%s가 %s를 쓰러뜨렸다!" % [@turn.attacker.name, @turn.defender.name]

  end

  def decrese_cost(target, target_cost)
    cost = target_cost

    if cost > TURN_COST
      cost -= TURN_COST
    else
      cost = 0
    end
    return cost
  end

  def make_turn

    if @attacker_cost == 0

    end


    if @attacker_cost >= @defender_cost
      if @defender_cost == 0
        @defender_cost = TURN_COST
      end
      @attacker_cost = decrese_cost(@attacker, @attacker_cost)
      return Turn.new(@attacker, @defender)
    else
      if @attacker_cost == 0
        @attacker_cost = TURN_COST
      end
      @attacker_cost < @defender_cost
      @defender_cost = decrese_cost(@defender, @defender_cost)
      return Turn.new(@defender, @attacker)
    end
  end

end


def main

  hero_stat = {
      HP: 150,
      MP: 150,
      DEX: 50
  }

  hero_action = {
      ATTACK: BattleAction.result({}, lambda { |self_stat, enemy_stat|
        return {HP: self_stat.get(:STR) - enemy_stat.get(:DEF)}
      }),
      HEAL: BattleAction.result({HP: -50, MP: 20}, lambda { |self_stat, enemy_stat|
        return {}
      }),
      SKILL: BattleAction.result({MP: -30}, lambda { |self_stat, enemy_stat|
        return {HP: 50}
      })
  }

  monster_action = {
      1 => BattleAction.result({}, lambda { |self_stat, enemy_stat|
        return {HP: self_stat.get(:STR) - enemy_stat.get(:DEF)}
      })
  }

  hero = Hero.new("hero", hero_stat, hero_action)
  enemy = Enemy.new("monster", {}, monster_action)

  battle = Battle.new(hero, enemy)
  battle.start

end

main