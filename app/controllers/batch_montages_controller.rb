class BatchMontagesController < ApplicationController

  def new
    @batch_montage = BatchMontage.new
  end

  def create
    require 'csv'
    @batch_montage = BatchMontage.new(status: "todo")

    if params[:file]
      content_file = File.read(params[:file].path)

      if content_file.index(';')
        separator = ';'
      elsif  content_file.index("\t")
        separator = "\t"
      else
        separator = ','
      end

      begin
        CSV.parse(content_file, {:col_sep => separator}) do |row|
          @batch_montage.montages.build( photo_url_1: row[0],
                                         photo_url_2: row[1],
                                         status: "todo" )
        end

        @batch_montage.save
        flash[:error] = nil
        redirect_to batch_montage_url(@batch_montage)
      rescue
        flash[:error] = "Can't parse the CSV file"
        render :new
      end

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
