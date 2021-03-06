class ContestsController < ApplicationController

  require 'video_convert_job'

  def index
    @contests = Contest.order(created_at: :desc).page(params[:page])
  end

  def show
    #include_all_helpers
    id = params[:id]
    @contest = Contest.find(id)
    #@clients = Client.all
    @videos = Video.where(contest_id: id, video_status_id: 2).order(created_at: :desc).page(params[:page])
    @original_videos = Video.where(contest_id: id).order(created_at: :desc).page(params[:page])
  end

  def destroy
    id = params[:id]

    begin
      Contest.destroy(id)
      flash[:success] = "The contests was deleted"
    rescue => ex
      logger.error ex.message
      flash[:error] = "An error has occur trying to delete the contest [#{ex.message}]"
    end
    redirect_to '/mycontests'
  end

  def update
    begin
      contest = Contest.find(params[:id])
      contest.update(contest_parameters)
      flash[:success] = "The contest was updated successfully"
    rescue => ex
      logger.error ex.message
      flash[:error] = "An error has occur trying to update the contest"
    end

    redirect_to "/mycontests"
  end

  def create
    user = User.find(params[:contest][:user_id])
    user.contests.create(contest_parameters)
    redirect_to "/mycontests"
  end

  def contest_parameters
    params.require(:contest).permit(:name, :description, :media, :url, :start_date, :end_date, :award_description)
  end

  def edit
    @contest = Contest.find(params[:id])
  end

  def browse

  end

  def mycontests
    @contests = Contest.where(:user_id => session[:user_logged_id]).order(created_at: :desc).page(params[:page])
    render 'contests/index'
  end

  def upload_video
    begin
      contest = Contest.find(params[:video][:contest_id])
      video_status = VideoStatus.find_by_order(1)
      video = Video.create(video_params)
      video.video_status_id = video_status.id
      video.contest_id = contest.id
      video.save
      flash[:success] = "The video was uploaded and is " + video_status.name + " we'll contact you as soon as the video is ready to watch"
    rescue => ex
      logger.error ex.message
      flash[:error] = ex.message
    end
    # begin
    #   video = Video.upload(params[:video])
    #   Delayed::Job.enqueue(VideoConvertJob.new(video.id))
    #   flash[:success] = "The video was uploaded and is " + video_status.name + " we'll contact you as soon as the video is ready"
    # rescue => ex
    #   logger.error ex.message
    #   flash[:error] = ex.message
    # end
    redirect_to contest
  end

  private

    def video_params
      params.require(:video).permit(:first_name, :last_name, :email, :message, :video)
    end


  def custom_url
    contest = Contest.where(url: params[:custom_url])[0]
    if contest != nil
      redirect_to contest
    else
      redirect_to root_path
    end
  end
end
