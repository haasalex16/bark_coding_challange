class LikesController < ApplicationController
  before_action :set_likeable, only: [:create]
  before_action :user_is_not_owner, only: [:create]

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes
  def create
    @like = Like.find_or_initialize_by(like_params)

    @like.liked = !@like.liked

    respond_to do |format|
      if @like.save
        format.html { redirect_to @likeable_obj }
        format.json { render :show, status: :created, location: @likeable_obj }
      else
        format.html { render :new }
        format.json { render json: @likeable_obj.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_likeable
      @likeable_obj = Kernel.const_get(params[:likeable_type]).find(params[:likeable_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.permit(:likeable_type, :user_id, :likeable_id)
    end

    # Do redirect to show if actions are being attempted on the owner's dogs
    def user_is_not_owner
      unless @likeable_obj.present? && @likeable_obj.user_id != current_user.id
        redirect_to @likeable_obj, notice: "You cannot like your own dog... How sad..."
      end
    end
end
