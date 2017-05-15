class MetalController < ActionController::Metal
  include AbstractController::Callbacks
  include ActionController::Head
  include Capcoauth::Rails::Helpers

  before_action :verify_authorized!

  def index
    self.response_body = { ok: true }.to_json
  end
end
