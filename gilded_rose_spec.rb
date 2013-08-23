require './gilded_rose.rb'
require 'rspec'
require 'pry'

describe GildedRose do
  let(:brie)        { find_item("Brie") }
  let(:cake)        { find_item("Cake") }
  let(:elixir)      { find_item("Elixir") }
  let(:passes)      { find_item("Backstage") }
  let(:vest)        { find_item("Vest") }

  let(:sulfuras)    { find_item("Sulfuras") }

  it 'takes an array of items on initialization' do
    items = Item.new("+5 Dexterity Vest", 10, 20)

    rose = GildedRose.new(items)
    rose.items.should eql(items)
  end

  it 'has an array of items' do
    subject.items.should be_a(Array)
  end

  it '#depreciate reduces the quality of an item' do
    FakeItem = Struct.new(:quality)
    fake_item = FakeItem.new(2)
    -> { subject.depreciate(fake_item, 1) }.
      should change(fake_item, :quality).by(-1)
  end

  it '#depreciate is a noop when quality is zero' do
    FakeItem = Struct.new(:quality)
    fake_item = FakeItem.new(0)
    -> { subject.depreciate(fake_item, 1) }.
      should change(fake_item, :quality).by(0)
  end

  it '#appreciate! increases the quality of an item' do
    FakeItem = Struct.new(:quality)
    fake_item = FakeItem.new(2)
    -> { subject.appreciate!(fake_item, 1) }.
      should change(fake_item, :quality).by(1)
  end

  it '#depreciate? returns true for items that always depreciate' do
    [cake, elixir, vest].each do |item|
      subject.depreciate?(item).should be_true
    end
  end


  describe "characterization" do
    it "never decreases the quality or sell_in value of Sulfuras" do
      sulfuras.quality.should eql(80)
      sulfuras.sell_in.should eql(0)

      subject.update_quality

      sulfuras.quality.should eql(80)
      sulfuras.sell_in.should eql(0)
    end

    it "decreases the quality of items" do
      [cake, elixir, vest].each do |item|
        -> { subject.update_quality }.should change(item, :quality).by(-1)
      end
    end

    it "decreases quality of items twice as fast after the sell by date" do
      max_sell_by = items.reject { |i| i.eql?(sulfuras) }.max_by do |i|
        i.quality
      end.quality

      (max_quality + 1).times { subject.update_quality }

      [cake, elixir, passes, vest].each { |item| item.quality.should eql(0) }
    end

    it "decreases the sell_in days of all but legendary items" do
      [brie, cake, elixir, passes, vest].each do |item|
        -> { subject.update_quality }.should change(item, :sell_in).by(-1)
      end
    end

    it "never decreases the quality below zero" do
      max_quality = items.reject { |i| i.eql?(sulfuras) }.max_by do |i|
        i.quality
      end.quality

      (max_quality + 1).times { subject.update_quality }

      [cake, elixir, passes, vest].each { |item| item.quality.should eql(0) }
    end

    it "increases the quality of assets" do
      [brie, passes].each do |item|
        -> { subject.update_quality }.should change(item, :quality).by(1)
      end
    end
  end

  def find_item(name)
    items.find { |i| i.name.match(name) }
  end

  def items
    subject.instance_variable_get("@items")
  end

end

#     it "decreases the value of conjured cake twice as fast" do
#       cake.quality.should eql(6)
# 
#       subject.update_quality
# 
#       cake.quality.should eql(4)
#     end

