class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :quit, :invite_user ]

  def index
    @groups = Current.user.groups
  end

  def show
    @operations = @group.operations

    @balance = (@group.users - [ Current.user ]).to_h { |user| [ user, 0 ] }

    @group.operations.each do |operation|
      if operation.author == Current.user
        operation.participations.where.not(user: Current.user).each do |participation|
          @balance[participation.user] -= (participation.amount_share || 0)
        end
      else
        operation.participations.where(user: Current.user).each do |participation|
          @balance[operation.author] += (participation.amount_share || 0)
        end
      end
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users = [ Current.user ]

    if @group.save
      redirect_to groups_path, notice: "PolyBanque créée avec succès."
    else
      render :new
    end
  end

  def quit
    @group.users.delete(Current.user)

    destroy @group if @group.users.empty?

    redirect_to groups_path
  end

  def invite_user
    user_param = params[:user]
    user = User.find_by(email_address: user_param)

    if user.nil?
      redirect_to group_path(@group), alert: "Utilisateur introuvable."
    elsif @group.users.include?(user)
      redirect_to group_path(@group), alert: "Cet utilisateur est déjà membre du groupe."
    else
      @group.users << user
      redirect_to group_path(@group), notice: "Utilisateur invité avec succès."
    end
  end

  private

  def set_group
    @group = Current.user.groups.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, alert: "Groupe introuvable."
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end

  def destroy(group)
    group.destroy
  end
end
