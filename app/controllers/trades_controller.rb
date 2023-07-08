class TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @group = current_user.groups.find(params[:group_id])
    @trades = @group.trades.order(created_at: :desc)
  end

  def new
    @trade = Trade.new
    @group = Group.find(params[:group_id])
    @groups = Group.where(user_id: current_user.id)
  end

  def create
    params = trade_params
    @trade = Trade.new(name: params[:name], amount: params[:amount])
    @trade.user = current_user
    @groups_ids = params[:group_ids]
    @groups_ids.each do |group_id|
      group = Group.find(group_id) unless group_id == ''
      @trade.groups.push(group) unless group.nil?
    end

    if @trade.save
      redirect_to group_trades_path(@trade.groups.first.id), notice: 'Transaction was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def trade_params
    params.require(:trade).permit(:name, :amount, group_ids: [])
  end
end
