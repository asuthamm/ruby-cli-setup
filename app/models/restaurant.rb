# app > models > restaurant.rb
class Restaurant < ActiveRecord::Base
  has_many :reviews
  has_many :customers, through: :reviews

  def avg_rating
    ratings = self.reviews.reload.map { |restaurant| restaurant.rating }
    count = ratings.count
    (ratings.sum * 1.0/ count).round(1)
  end
end