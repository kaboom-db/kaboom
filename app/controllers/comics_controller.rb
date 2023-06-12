class ComicsController < ApplicationController
  before_action :set_comic, only: %i[ show edit update destroy ]

  # GET /comics or /comics.json
  def index
    @comics = Comic.all
  end

  # GET /comics/1 or /comics/1.json
  def show
  end

  # GET /comics/new
  def new
    @comic = Comic.new
  end

  # GET /comics/1/edit
  def edit
  end

  # POST /comics or /comics.json
  def create
    @comic = Comic.new(comic_params)

    respond_to do |format|
      if @comic.save
        format.html { redirect_to comic_url(@comic), notice: "Comic was successfully created." }
        format.json { render :show, status: :created, location: @comic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comics/1 or /comics/1.json
  def update
    respond_to do |format|
      if @comic.update(comic_params)
        format.html { redirect_to comic_url(@comic), notice: "Comic was successfully updated." }
        format.json { render :show, status: :ok, location: @comic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comics/1 or /comics/1.json
  def destroy
    @comic.destroy

    respond_to do |format|
      format.html { redirect_to comics_url, notice: "Comic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comic
      @comic = Comic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comic_params
      params.require(:comic).permit(:aliases, :api_detail_url, :issue_count, :summary, :description, :cv_id, :cover_image, :name, :start_year)
    end
end
