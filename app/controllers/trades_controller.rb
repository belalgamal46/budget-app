class TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @group = current_user.groups.find(params[:group_id])
    @trades = @group.trades.order(created_at: :desc)
  end
end
