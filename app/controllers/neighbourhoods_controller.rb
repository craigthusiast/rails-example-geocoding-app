class NeighbourhoodsController < ApplicationController
  before_action :set_neighbourhood, only: [:show, :update, :destroy]

  # GET /neighbourhoods
  def index
    @neighbourhoods = Neighbourhood.all

    # URL example http://localhost:3000/neighbourhoods?max_home_price=400000&min_home_price=300000&ranked_by=home_price
    if params[:max_home_price].present? # URL example http://localhost:3000/neighbourhoods?max_home_price=400000
      @neighbourhoods = @neighbourhoods.where('home_price <= ?', params[:max_home_price])
    end

    if params[:min_home_price].present? # URL example http://localhost:3000/neighbourhoods?max_home_price=400000
      @neighbourhoods = @neighbourhoods.where('home_price >= ?', params[:min_home_price])
    end

    if params[:ranked_by].present?  # URL example http://localhost:3000/neighbourhoods?ranked_by=name
      @neighbourhoods = @neighbourhoods.order(params[:ranked_by].to_sym => :desc)
    end

    if params[:coords].present?
      # Unlike the queries we saw earlier, the line below overwrites
      # the @neighbourhoods variable. It will return only the nearest
      # neighbourhood, without combining with the other filters.
      # URL example http://localhost:3000/neighbourhoods?coords=[43.6580377,-79.483626]
      @neighbourhoods = Location.nearest_neighbourhood(params[:coords])
      # binding.pry
    end


    render json: @neighbourhoods

    # render json: JSON.pretty_generate(@neighbourhoods)
    # respond_to do |format|
    #   # type http://localhost:3000/neighbourhoods into browser bar to render the format.json below
    #   # OR use regular link_to by adding defaults: { format: 'json' } to the route
    #   format.json { render json: JSON.pretty_generate(@neighbourhoods) }
    # end

  end

  # GET /neighbourhoods/1
  def show
    render json: @neighbourhood
  end

  # POST /neighbourhoods
  def create
    @neighbourhood = Neighbourhood.new(neighbourhood_params)

    if @neighbourhood.save
      render json: @neighbourhood, status: :created, location: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /neighbourhoods/1
  def update
    if @neighbourhood.update(neighbourhood_params)
      render json: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # DELETE /neighbourhoods/1
  def destroy
    @neighbourhood.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighbourhood
      @neighbourhood = Neighbourhood.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def neighbourhood_params
      params.require(:neighbourhood).permit(:name, :num_businesses, :home_price)
    end
end
