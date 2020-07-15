class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :user_is_owner, only: [:edit, :update, :destroy]

  # CONTANTS
  DOGS_PER_PAGE = 5
  RECENT_LIKES_TIMEFRAME = 1.hour.ago.utc

  # GET /dogs
  # GET /dogs.json
  def index
    @page_number = params[:page]&.to_i || 1
    @sort = params[:sort] == "true"

    query = Dog.left_joins(:likes).group(:id)
    if @sort
      query = query.order("sum(case when likes.liked = true and likes.updated_at > '#{RECENT_LIKES_TIMEFRAME}' then 1 else 0 end) desc")
    end

    @dogs = query.order(updated_at: :DESC, id: :DESC)
                 .limit(DOGS_PER_PAGE).offset((@page_number - 1) * DOGS_PER_PAGE)
                 .select("dogs.*, sum(case when likes.liked = true then 1 else 0 end) as likes_count, sum(case when likes.liked = true and likes.updated_at > '#{RECENT_LIKES_TIMEFRAME}' then 1 else 0 end) as last_hour")

    @total_pages = (Dog.count.to_f / DOGS_PER_PAGE).ceil
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @liked_by_user = Like.find_by(user_id: current_user&.id, likeable_id: @dog.id, likeable_type: 'Dog')&.liked
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.user = current_user if current_user.present?

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end

    # Do redirect to show if actions are being attempted on other owner's dogs
    def user_is_owner
      unless @dog.present? && @dog.user_id === current_user.id
        redirect_to @dog, notice: "You cannot edit other owner's dogs."
      end
    end
end
