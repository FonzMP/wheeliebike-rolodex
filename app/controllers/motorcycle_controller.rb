class MotorcycleController < ApplicationController

  get '/motorcycles' do
    @motorcycles = Motorcycle.all

    erb :"motorcycles/index"
  end

  get '/motorcycles/new' do
    erb :"motorcycles/create"
  end

  post '/motorcycles' do
    @motorcycle = Motorcycle.create(make: params[:make])
    if @motorcycle.save
      @motorcycle.model = params[:model] if params[:model] != ""
      @motorcycle.year = params[:year] if params[:year] != ""
      @motorcycle.size = params[:size] if params[:size] != ""

      @motorcycle.save

      current_user.motorcycles << @motorcycle
      current_user.save

      redirect '/motorcycles'
    else
      erb :"motorcycles/create"
    end
  end

  get '/motorcycles/:id' do
    @motorcycle = Motorcycle.find(params[:id])
    @bike_owner = @motorcycle.user.username

    erb :"motorcycles/show"
  end

end