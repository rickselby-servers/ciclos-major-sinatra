# frozen_string_literal: true

# Helper functions for sinatra
module Helpers
  def gallery_images
    Dir["./public/img/gallery/#{@gallery[:slug]}/*"]
      .select { |f| File.file?(f) }
      .map { |p| p.delete_prefix './public' }
      .sort
  end

  def gallery_thumbnails
    Dir["./public/img/gallery/#{@gallery[:slug]}/thumb/*"]
      .map { |p| p.delete_prefix './public' }
      .sort
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
end
