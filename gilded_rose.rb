require './item.rb'

class GildedRose
  DEFAULT_ITEMS = [
    Item.new("+5 Dexterity Vest", 10, 20),
    Item.new("Aged Brie", 2, 0),
    Item.new("Elixir of the Mongoose", 5, 7),
    Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
    Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
    Item.new("Conjured Mana Cake", 3, 6)
  ]

  attr_accessor :items

  def initialize(items=DEFAULT_ITEMS)
    self.items = items
  end

  def appreciate!(item, num)
    item.quality = item.quality + num
  end

  def depreciate(item, num)
    new_value = item.quality - num
    item.quality = new_value > 0 ? new_value : 0
  end

  def depreciate?(item)
    ["Cake", "Elixir", "Vest"].any? { |n| item.name.match(n) }
  end

  def update_quality

    items.each do |item|
      if depreciate?(item)
        depreciate(item, 1)
      else
        if (item.quality < 50)
          appreciate!(item, 1)
          if (item.name == "Backstage passes to a TAFKAL80ETC concert")
            if (item.sell_in < 11)
              if (item.quality < 50)
                appreciate!(item, 1)
              end
            end
            if (item.sell_in < 6)
              if (item.quality < 50)
                appreciate!(item, 1)
              end
            end
          end
        end
      end
      if (item.name != "Sulfuras, Hand of Ragnaros")
        item.sell_in = item.sell_in - 1;
      end
      if (item.sell_in < 0)
        if depreciate?(item)
          depreciate(item, 2)
        end
        if (item.name != "Aged Brie")
          if (item.name != "Backstage passes to a TAFKAL80ETC concert")
            if (item.quality > 0)
              if (item.name != "Sulfuras, Hand of Ragnaros")
                depreciate(item, 1)
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if (item.quality < 50)
            appreciate!(item, 1)
          end
        end
      end
    end
  end

end
