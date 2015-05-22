class RafflesController < ApplicationController
  #TODO: add validations to prevent create from being called via get, and raffle from being called from a non-ajax request.
  protect_from_forgery :only => [:create, :update, :destroy] 

  def index
    render :layout => false
  end

  def list
    @page_title = "Rafflr"
    @raffles = Raffle.order("created_on DESC").paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @page_title = "New Raffle"
    @raffle = Raffle.new
    @delay = 1500
  end

  def create
    @raffle = Raffle.new(raffle_params)
    @users = params[:users]
    @delay = params[:delay]
    users = @users.gsub("\r","").split("\n").map{ |u| u.strip }
    users.each do |user|
      new_user = User.new(:name => user, :raffle => @raffle, winner: false)
      @raffle.users << new_user
    end

    if @raffle.save
      set_session_variables(@raffle)
      redirect_to raffle_path(@raffle, :delay => @delay)
    else
      render :action => 'new'
    end
  end

  def show
    # TODO: maybe we should just display it if it's already been run
    # or give them the option to re-run it
    @raffle = Raffle.find(params[:id])
    @users = @raffle.users
    @delay = params[:delay]
    set_session_variables(@raffle)
    @page_title = "#{@raffle.title}"
  end

  # only called via ajax
  def raffle

    # randomize the users
    session[:users] = session[:users].sort_by { rand }
    @delay = params[:delay] || '1'
    @delay = @delay.to_i

    begin
      # haha you're a loser
      loser = session[:users].pop
      loser2id = 'null'
      if @delay < 1
        if session[:users].size > session[:number_of_winners]
          loser2id = session[:users].pop.id
        end
      end
      begin
        session[:users].each do |user|
          u = User.find(user["id"])
          u.winner = true
          u.save
        end
      end if (session[:users].size == session[:number_of_winners])

      render js: "remove_user(#{loser["id"]}, #{loser2id})"
    end if session[:users].size > session[:number_of_winners]

  end

  def test
  end

  private

  def raffle_params
    params.require(:raffle).permit(:title, :number_of_winners, :users, :delay, :commit)
  end

  def set_session_variables(raffle)
    session[:users] = []
    session[:number_of_winners] = 0
    session[:users] = raffle.users
    session[:number_of_winners] = raffle.number_of_winners.to_i
  end

end
