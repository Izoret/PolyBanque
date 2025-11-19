class OperationsController < ApplicationController
  def index
    @operations = Operation.where group: user_group_id_in_query
  end

  def edit
    @operation = operation_in_query
  end

  def update
    @operation = operation_in_query
    if @operation.update(operation_params)
      redirect_to edit_operation_path @operation
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_group_id_in_query
    Current.user.groups.find(params[:group_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Groupe introuvable."
  end

  def operation_in_query
    operation = Operation.find params[:id]

    raise ActiveRecord::RecordNotFound unless operation.group.in?(Current.user.groups)

    operation
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Opération introuvable."
  end

  def operation_params
    params.require(:operation).permit(
      :name,
      :date,
      :total_amount,
      participations_attributes: [ :id, :user_id, :amount_share ]
    )
  end
end
