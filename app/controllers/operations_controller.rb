class OperationsController < ApplicationController
  def new
    @group = user_group_in_query
    @operation = Operation.new

    @group.users.each do |user|
      @operation.participations.build(user: user)
    end
  end

  def create
    @group = user_group_in_query
    @operation = Operation.new(operation_params)
    @operation.author = Current.user
    @operation.group = @group

    if @operation.save
      redirect_to @group, notice: "Opération bien créée."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @operation = operation_in_query
  end

  def update
    @operation = operation_in_query
    if @operation.update(operation_params)
      redirect_to edit_operation_path(@operation), notice: "Opération bien mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @operation = operation_in_query

    @operation.group.operations.delete @operation
    @operation.destroy

    redirect_to @operation.group
  end

  private

  def user_group_in_query
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
