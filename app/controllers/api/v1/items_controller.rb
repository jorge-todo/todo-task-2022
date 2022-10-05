class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]

  def index
    @items = Item.all

    render json: @items
  end

  def show
    render json: @item
  end

  def create
    @item = Items::Creator.new(item_params).create!

    if @item.errors.empty?
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    Items::Updater.new(@item, item_params).update!

    if @item.errors.empty?
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy

    render json: "Task destroyed successfully."
  end

  private

  def set_item
    @item = Item.find(item_params[:id])

  rescue ActiveRecord::RecordNotFound
    render json: "Task not found.", status: 404 unless @item
  end

  def item_params
    params.permit( :id, :title, :description, :due_date, :priority)
  end
end