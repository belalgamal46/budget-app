class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all.where(user_id: current_user.id)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      flash[:notice] = 'Group was successfully created.'
      redirect_to groups_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :icon)
  end
end
