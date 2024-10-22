# frozen_string_literal: true

module FormHelper
  def user_facing_errors(item)
    return if item.errors.empty?

    render "shared/errors", item: item
  end
end
