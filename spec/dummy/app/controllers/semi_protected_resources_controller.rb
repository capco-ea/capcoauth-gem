class SemiProtectedResourcesController < ApplicationController
  before_action :verify_authorized!, only: :index

  def index
    render plain: 'protected index'
  end

  def show
    render plain: 'non protected show'
  end
end
