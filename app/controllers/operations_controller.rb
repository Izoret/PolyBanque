class OperationsController < ApplicationController
  def index
    @operations = Operation.where group: user_group_id_in_arg
  end

  private

  def user_group_id_in_arg
    Current.user.groups.find(params[:group_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Groupe introuvable."
  end
end
