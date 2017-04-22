class MontagesController < ApplicationController
  def show
    @montage = Montage.find(params[:id])

    respond_to do |format|
      format.jpg do
        render text: Base64.decode64(@montage.base64)
      end
    end
  end

end
