# frozen_string_literal: true

# Helper functions for sinatra
module Helpers
  def all_text
    DB[:text_history].where(current: true).all.to_h { |v| [v[:key], v[:text]] }
  end

  def gallery_images
    Dir["./public/img/gallery/#{@gallery[:slug]}/*"]
      .select { |f| File.file?(f) }
      .map { |p| p.delete_prefix "./public" }
      .sort
  end

  def get_text(key, default = key)
    settings.text.fetch(key, default)
  end

  def logged_in?
    session.key?(:user) && !session.fetch(:user).empty?
  end

  def format_bike_file_name(name)
    name.downcase.tr(" /+", "-").squeeze("-")
  end

  def format_data_name(name)
    name.to_s.capitalize.tr("_", " ")
  end
end
