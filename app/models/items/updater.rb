# frozen_string_literal: true

# items::Update Item
class Items::Updater
  def initialize(item, params)
    @params = params
    @errors = []
    @item = item
  end

  def update!
    @params.each_pair do |attribute, value|
      update_attribute(attribute, value)
    end
    @errors += @item.errors.full_messages unless @item.save

    @item
  end

  private

  def update_attribute(attribute, value)
    @item[attribute] = value if value
  end
end
