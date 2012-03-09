class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if ((params[:ratings] == nil && session[:sort_by]!= nil) || (params[:ratings] == nil && session[:selected_ratings]!=nil))
      redirect_to movies_path({:ratings => session[:selected_ratings], :sort_by => session[:sort_by]})
    end
    @movies = Movie.order(params[:sort_by]).all
    @all_ratings = @movies.collect{|m| m.rating}.uniq.sort
    @selected_ratings = Hash.new
    if params[:ratings] != nil
      @movies = @movies.select{|m| params[:ratings].keys.include?(m.rating)}
      @selected_ratings = params[:ratings]
    end
    session[:sort_by] = params[:sort_by]
    session[:selected_ratings] = params[:ratings]
    if params[:sort_by] == "title"
      @title = "hilite"
    end
    if params[:sort_by] == "release_date"
      @release_date = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
