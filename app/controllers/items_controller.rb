class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to items_path, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_url(@item), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy

    redirect_to items_path, notice: "Task was successfully destroyed."
  end

  private

    def set_item
      @item = Item.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:title, :description, :due_date, :priority)
    end
end
