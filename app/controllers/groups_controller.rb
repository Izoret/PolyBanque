class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :quit, :invite_user, :transactions_algorithm ]

  def index
    @groups = Current.user.groups
  end

  def show
    @operations = @group.operations
  end

  def transactions_algorithm
    @trace = []
    @steps = []

    @trace[0] = {}

    @group.users.each do |user|
      @trace[0][user] = user.get_balance_in_group @group
    end

    n = 0
    until (@steps[n] = "Parfait !") and @trace[n].values.all? { |v| v == 0 } do
      puts "FUCK YOU"
      richest = @trace[n].max_by { |_, v| v }
      poorest = @trace[n].min_by { |_, v| v }

      @steps[n] = "#{poorest[0].username} paye #{-poorest[1]} € à #{richest[0].username}"

      @trace[n + 1] = @trace[n].dup
      @trace[n + 1][poorest[0]] -= poorest[1]
      @trace[n + 1][richest[0]] += poorest[1]

      n += 1
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
