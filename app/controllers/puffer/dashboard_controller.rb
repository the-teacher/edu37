class Puffer::DashboardController < Puffer::DashboardBase
  # login
  before_filter :login_required
end
