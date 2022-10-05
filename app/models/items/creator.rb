# frozen_string_literal: true

# Items::Creator takes only allowed params to create items
class Items::Creator
  def initialize(params)
    @params = params
    @errors = []
    @item = Item.new
  end

  def create!
    @item.title = @params[:title]
    @item.description = @params[:description]
    @item.priority = @params[:priority]
    @item.due_date = @params[:due_date]
    @errors += @item.errors.full_messages unless @item.save

    @item
  end
end
