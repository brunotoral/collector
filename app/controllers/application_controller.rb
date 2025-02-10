# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  private

  def paginate(collection)
    @pagy, paginated_collection = pagy(collection)

    paginated_collection
  end

  def api_paginate(collection)
    pagy, paginated_collection = pagy(collection, limit: 2)

    { data: paginated_collection, pagy: pagy_metadata(pagy) }
  end
end
