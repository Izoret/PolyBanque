class GroupsController < ApplicationController
  def index
    @groups = Current.user.groups
  end

  def show
    @group = user_group_in_query
  end

  def new
    @group = Group.new
  end

  def quit
    @group = user_group_in_query
    @group.users.delete(Current.user)

    destroy @group if @group.users.empty?

    redirect_to groups_path
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

  def invite_user
    group = user_group_in_query
    user_param = params[:user]
    user = User.find_by(email_address: user_param) || User.find_by(username: user_param)

    if user.nil?
      redirect_to group_path(group), alert: "Utilisateur introuvable."
    elsif group.users.include?(user)
      redirect_to group_path(group), alert: "Cet utilisateur est déjà membre du groupe."
    else
      group.users << user
      redirect_to group_path(group), notice: "Utilisateur invité avec succès."
    end
  end

  private

  def user_group_in_query
    Current.user.groups.find(params[:id])
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
