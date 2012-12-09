class StickersController < ApplicationController
  # GET /stickers
  # GET /stickers.json
  def index
    @stickers = Sticker.all
    @activated = Sticker.where(:activated => 1)
    @verified = Sticker.where(:verified => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stickers }
    end
  end

    def activate
    @sticker = Sticker.find(params[:id])

    respond_to do |format|
      if @sticker.update_attributes(:activated => 1)
        format.html { redirect_to "/stickers/activate_index", notice: 'Sticker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sticker.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate_index
    @stickers = Sticker.all
    @activated = Sticker.where(:activated => 1)
    @verified = Sticker.where(:verified => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stickers }
    end
  end


  # GET /stickers/1
  # GET /stickers/1.json
  def show
    @sticker = Sticker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sticker }
    end
  end

  # GET /stickers/new
  # GET /stickers/new.json
  def new
    @sticker = Sticker.new
    if current_user.has_role? :admin
      redirect_to "/admin/stickers/new"
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sticker }
    end
  end

  # GET /stickers/1/edit
  def edit
    @sticker = Sticker.find(params[:id])
  end

  # POST /stickers
  # POST /stickers.json
  def create
    @sticker = Sticker.new(params[:sticker])

    respond_to do |format|
      if @sticker.save
        format.html { redirect_to @sticker, notice: 'Sticker was successfully created.' }
        format.json { render json: @sticker, status: :created, location: @sticker }
      else
        format.html { render action: "new" }
        format.json { render json: @sticker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stickers/1
  # PUT /stickers/1.json
  def update
    @sticker = Sticker.find(params[:id])

    respond_to do |format|
      if @sticker.update_attributes(params[:sticker])
        format.html { redirect_to @sticker, notice: 'Sticker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sticker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stickers/1
  # DELETE /stickers/1.json
  def destroy
    @sticker = Sticker.find(params[:id])
    @sticker.destroy

    respond_to do |format|
      format.html { redirect_to stickers_url }
      format.json { head :no_content }
    end
  end

  def import
    
  end

  def upload_import
    uploaded_io = params[:file] 
    filename = Rails.root.join('public', 'uploads', 'tmp', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @log = []
    book = Spreadsheet.open filename
    sheet1 = book.worksheet 0
    i = -1
    sheet1.each do |row|
      i+=1
      attributes = { :product_id => row[0],
                     :code => row[1]
                   }
      begin
        Sticker.create!(attributes)
        @log << "Line #{i+1} - Successfully imported - Attributes: #{attributes.inspect}"
      rescue Exception => e
        @log << "Line #{i+1} - Error importing #{e.inspect} - Attributes: #{attributes.inspect}"
      end
    end
  end  


end

