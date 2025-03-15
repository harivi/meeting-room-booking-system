class DashboardsController < ApplicationController
  before_action :authenticate_user!  

  def admin
    redirect_to root_path, alert: "Access Denied" unless current_user.role == "admin"
  end

  def employee
    redirect_to root_path, alert: "Access Denied" unless current_user.role == "employee"
    # render layout: "employee_layout"
  end
end
