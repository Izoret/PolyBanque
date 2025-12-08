class OperationsController < ApplicationController
  before_action :set_operation, only: [ :edit, :update, :destroy ]
  before_action :set_group, only: [ :new, :create ]

  def new
    @operation = Operation.new
    @operation.group = @group
    @operation.author = Current.user

    @group.users.each do |user|
      @operation.participations.build(user: user)
    end
  end

  def create
    @operation = Operation.new(operation_params)
    @operation.author = Current.user
    @operation.group = @group
    @operation.date = Date.today

    if @operation.save
      redirect_to @group, notice: "Opération bien créée."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @operation.update(operation_params)
      redirect_to edit_operation_path(@operation), notice: "Opération bien mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @operation.group.operations.delete @operation
    @operation.destroy

    redirect_to @operation.group
  end

  private

  def set_group
    @group = Current.user.groups.find(params[:group_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Groupe introuvable."
  end

  def set_operation
    @operation = Operation.find params[:id]

    raise ActiveRecord::RecordNotFound unless @operation.group.in?(Current.user.groups)
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Opération introuvable."
  end

  def operation_params
    params.require(:operation).permit(
      :name,
      :date,
      :author_id,
      :total_amount,
      participations_attributes: [ :id, :user_id, :amount_share ]
    )
  end
end
