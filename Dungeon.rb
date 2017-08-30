class Dungeon
  attr_accessor :step, :input

  def initialize
    @player = Hero.new
    @step = 0
  end

  def play
    puts "\n\nWelcome to the ultra deadly dungeon! Move to room #10 to escape!"

    until @step == 10 || @player.dead
      display_room
      action_list
    end

    validate_result
  end

  def validate_result
    if @step == 10
      puts "\n\n\nYou finished the dungeon!"
      puts 'You finished with ' + @player.gold.to_s + ' gold!'
    elsif @player.hp <= 0
      puts "\n\n\nYou died. Please play again."
    end
  end

  def action_list
    puts "Would you like to move to the next room?(y/n)"
    @input = gets.chomp
    if @input == 'y'
      @step += 1
      random_act
    end
  end

  def random_act
    array = [0, 1, 2]
    rando = array.sample
    if rando == 0
      puts "\n\n\n"
      puts 'You encountered no monsters! Thank the lord.'
    elsif rando == 1
      puts "\n\n\n"
      puts 'You encountered a gnome!'
      gnome = Gnome.new
      @player.fight_monster(gnome)
    elsif rando == 2
      puts "\n\n\n"
      puts 'You encountered a fucking dragon!'
      dragon = Dragon.new
      @player.fight_monster(dragon)
    end
  end

  def display_room
    puts "\nYou are currently in room #" + step.to_s
  end
end

class Character
  def dead
    return true if @hp <= 0
    false
  end

  def take_damage(n)
    @hp -= n
  end
end

class Hero < Character
  attr_accessor :hp, :gold, :hit

  def initialize
    @hp = 10
    @hit = (1..8).to_a
    @gold = 0
  end
  
  def fight_monster(monster)
    runaway = false
    until monster.dead || runaway == true || dead
      puts "\nWhat would you like to do?"
      puts "(1) Hit the monster"
      puts "(2) Run away"
      input = gets.chomp

      if input == '2'
        runaway = true
      end

      if input == '1'
        monster_hit = @hit.sample
        monster.take_damage(monster_hit)
        if !monster.dead
          self_hit = monster.hit.sample
          self.take_damage(self_hit)
        end
        puts "\n\n\n*You inflicted " + monster_hit.to_s + " damage to the monster!"
        puts '*You took ' + self_hit.to_s + " damage back from the monster!" if !monster.dead
        puts '*You are at: ' + @hp.to_s + ' life'
      end
    end

    if runaway == true
      puts "\n\n\nYou ran the fuck away!"
    elsif monster.dead
      take_gold(monster)
      puts 'You slayed the vicious monster! Good work hero.'
      puts 'You stole ' + monster.gold.to_s + ' gold and are now at ' + @gold.to_s + ' total gold!'
    end
  end

  def take_gold(monster)
    @gold += monster.gold
  end

end

class Gnome < Character
  attr_accessor :hp, :gold, :hit

  def initialize
    @hp = 3
    @gold = rand(1..5)
    @hit = (1..2).to_a
  end
end

class Dragon < Character
  attr_accessor :hp, :gold, :hit

  def initialize
    @hp = 10
    @gold = rand(10..20)
    @hit = (1..5).to_a
  end
end

dungeon = Dungeon.new
dungeon.play

# #Instructions
#The player must take 10 steps to escape the dungeon. On each step, the player might encounter a monster.
#One third of the time, the player will encounter a gnome. One third of the time, the player will encounter a dragon.
#One third of the time, there will be no monster.
#If there is a monster, the player can choose to fight or run away. If the player fights and wins,
#the player gets the monster's gold.
#The player starts with 10 hit points. Each time the player is hit by a monster, the player loses hit points.
#If the player's hit points reach 0 before escaping the dungeon, the game is over and the player loses.
#The player does 1 to 8 hit points of damage with each hit
#Each gnome encountered starts with 3 hit points, has 1 to 5 gold gold,
#and does 1 to 2 hit points of damage each time it attacks..
#Each dragon starts with 10 hit points, has 10 to 20 gold, and does 1 to 5 points of damage.
#
#Each encounter with a monster consists of a series of turns. For each turn,
#the player can fight, or run away. If the player chooses to fight, damage is calculated for the monster.
#The monster retaliates and damage is calculated for the player. Then, the next turn starts and the player may choose to fight or run away again.
#If the player chooses to run away, they move one step closer to the dungeon exit without getting hurt, but without getting any gold.
#
# When the player escapes, the program displays the total gold collected.
