class FullProtectedResourcesController < ApplicationController
  before_action :verify_authorized!, only: :show
  before_action :verify_authorized!, only: :index

  def index
    render plain: 'index'
  end

  def show
    render plain: 'show'
  end
end
