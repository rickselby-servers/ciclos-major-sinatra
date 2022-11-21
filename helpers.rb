# frozen_string_literal: true

# Helper functions for sinatra
module Helpers
  def all_text
    DB[:text_history].where(current: true).all.to_h { |v| [v[:key], v[:text]] }
  end

  def gallery_images
    Dir["./public/img/gallery/#{@gallery[:slug]}/*"]
      .select { |f| File.file?(f) }
      .map { |p| p.delete_prefix './public' }
      .sort
  end

  def get_text(key, default = key)
    settings.text.fetch(key, default)
  end

  def logged_in?
    session.key?(:user) && !session.fetch(:user).empty?
  end

  def price_list(prices, days)
    list = []
    total = 0
    price = 0
    (1..days).each do |day|
      price = prices[day] if prices.key? day
      total += price
      list.push({ day: day, price: price.to_f, total: total.to_f })
    end
    list
  end

  def price_list_per_day(prices, days)
    list = []
    price = 0
    (1..days).each do |day|
      price = prices[day] if prices.key? day
      list.push({ day: day, price: price.to_f, total: (price * day).to_f })
    end
    list
  end
end
