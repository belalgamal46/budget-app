class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all.where(user_id: current_user.id)
  end
end
