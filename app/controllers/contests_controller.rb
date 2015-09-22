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
    @original_videos = Video.where(contest_id: id).order(created_at: :desc)
  end

  def destroy

  end

  def update
    contest = Contest.find(params[:id])
    contest.update(name: contest_parameters[:name], description: contest_parameters[:description], media: contest_parameters[:media], url: contest_parameters[:url], start_date: contest_parameters[:start_date], end_date: contest_parameters[:end_date], award_description: contest_parameters[:award_description])
=begin
    contest.name = contest_parameters[:name]
    contest.description = contest_parameters[:description]
    contest.media = contest_parameters[:media]
    contest.url = contest_parameters[:url]
    contest.start_date = contest_parameters[:start_date]
    contest.end_date = contest_parameters[:end_date]
    contest.award_description = contest_parameters[:award_description]
    contest.save
=end

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
    contest = Contest.find(params[:video][:contest_id])
    video_status = VideoStatus.find_by_order(1)
    begin
      video = Video.upload(params[:video])
      Delayed::Job.enqueue(VideoConvertJob.new(video.id))
      flash[:success] = "The video was uploaded and is " + video_status.name + " we'll contact you as soon as the video is ready"
    rescue => ex
      logger.error ex.message
      flash[:error] = ex.message
    end
    redirect_to contest
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
