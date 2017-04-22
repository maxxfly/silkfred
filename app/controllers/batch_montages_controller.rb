class BatchMontagesController < ApplicationController

  def new
    @batch_montage = BatchMontage.new
  end

  def create
    require 'csv'
    @batch_montage = BatchMontage.new(status: "todo")

    if params[:file]
      CSV.foreach(params[:file].path) do |row|
        @batch_montage.montages.build( photo_url_1: row[0],
                                       photo_url_2: row[1],
                                       status: "todo" )
      end

      @batch_montage.save

      redirect_to batch_montage_url(@batch_montage)
    end
  end

  def show
    @batch_montage = BatchMontage.find(params[:id])
    respond_to do |format|
      format.json do
        render json: @batch_montage.to_json
      end

      format.csv do
        send_data @batch_montage.to_csv, file_name: "export.csv"
      end

      format.html do
        render
      end
    end
  end


end
