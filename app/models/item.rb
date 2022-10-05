# frozen_string_literal: true

class Item < ApplicationRecord
  validates :title, presence: true
end
