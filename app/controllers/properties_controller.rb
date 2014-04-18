require 'pry'

class PropertiesController < ApplicationController

  def index
    @properties = Property.all
    @property_filter = Property.new

    if params[:property_filter].present?
      if params[:property_filter][:rental_type] != "All"
        @properties = @properties.where(rental_type: params[:property_filter][:rental_type])
      end
      # this uses the location name not because it is location, but because there is no single field that holds a string for price.
      if params[:property_filter][:location] == "Expensive"
        @properties = @properties.where("price_day >= 5000")
      end
      if params[:property_filter][:location] == "Reasonable"
        @properties = @properties.where("price_day < 5000 AND price_day > 2000")
      end
      if params[:property_filter][:location] == "Cheap"
        @properties = @properties.where("price_day <= 2000")
      end
    end
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new property_params
    if !params[:property][:image].nil?
      picture = @property.pictures.new(:user_id => params[:property][:user_id], :property_id => @property.id)
      picture.image = params[:property][:image]
      picture.save
    end
    if @property.save
      flash[:notice] = "Your property was uploaded!  Please hold tight while we verify all the information! (Should take less than 36 months)"
      respond_to do |format|
        format.html { redirect_to property_path(@property) }
        format.js
      end
    else
      render 'new'
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    if !params[:property][:image].nil?
      picture = @property.pictures.new(:user_id => params[:property][:user_id], :property_id => @property.id)
      picture.image = params[:property][:image]
      picture.save
    end
    if @property.update(property_params)
      flash[:notice] = "Your property was updated! Thank you for keeping its information current!"
      redirect_to property_path(@property)
    else
      render 'edit'
    end
  end

private


  def property_params
    params.require(:property).permit(:name, :location, :description, :user_id, :price_day, :price_week, :price_month, :rental_type)
  end
end
