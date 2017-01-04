class PoemsController < ApplicationController
  before_action :set_poem, only: [:show, :edit, :update, :destroy]

  include PoemsHelper

  # GET /poems
  # GET /poems.json
  def index
    @poems = Poem.all
  end
  # GET /poems/1
  # GET /poems/1.json
  def show
  end

  # GET /poems/new
  def new
    @poem = Poem.new
  end

  # GET /poems/1/edit
  def edit
  end

  # POST /poems
  # POST /poems.json
  def create
    @poem = Poem.new(poem_params)  
    @poem_lines = params[:poem][:lines].split("\r\n") # poem lines
    
    respond_to do |format|
      if @poem.save && save_poem_lines(Poem.last.id, @poem_lines)
        
        format.html { redirect_to @poem, notice: 'Poem was successfully created.' }
      else
        format.html { render :new }
      end
    end
    
  end

  # PATCH/PUT /poems/1
  # PATCH/PUT /poems/1.json
  def update
    respond_to do |format|
      if @poem.update(poem_params)
        format.html { redirect_to @poem, notice: 'Poem was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /poems/1
  # DELETE /poems/1.json
  def destroy
    @poem.destroy
    respond_to do |format|
      format.html { redirect_to poems_url, notice: 'Poem was successfully destroyed.' }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poem
      @poem = Poem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poem_params
      params.require(:poem).permit(:title)
    end
end
