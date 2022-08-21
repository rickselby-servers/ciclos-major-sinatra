# frozen_string_literal: true

# Helper functions for sinatra
module Helpers
  def gallery_images
    Dir["./public/img/gallery/#{@gallery[:slug]}/*"]
      .select { |f| File.file?(f) }
      .map { |p| p.delete_prefix './public' }
      .sort
  end

  def logged_in?
    session.key?(:user) && !session.fetch(:user).empty?
  end

  def nl2br(string)
    string.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />") if string
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
