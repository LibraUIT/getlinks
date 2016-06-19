class ErrorsController < ApplicationController
  def error404
    @link = Link.new
    render status: :not_found
  end
end
