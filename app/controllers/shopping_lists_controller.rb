class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: %i[ show edit update destroy ]

  # GET /shopping_lists or /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.all
  end

  # GET /shopping_lists/1 or /shopping_lists/1.json
  def show
    @unpurchased = @shopping_list.items.unpurchased.order(:created_at)
    @purchased = @shopping_list.items.purchased.order(:created_at)
    @item = @shopping_list.items.build
  end

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
  end

  # GET /shopping_lists/1/edit
  def edit
  end

  # POST /shopping_lists or /shopping_lists.json
  def create
    @shopping_list = ShoppingList.new(shopping_list_params)

    respond_to do |format|
      if @shopping_list.save
        format.html { redirect_to @shopping_list, notice: "買い物リストを作成しました。" }
        format.json { render :show, status: :created, location: @shopping_list }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @shopping_list.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /shopping_lists/1 or /shopping_lists/1.json
  def update
    respond_to do |format|
      if @shopping_list.update(shopping_list_params)
        format.html { redirect_to @shopping_list, notice: "買い物リストを更新しました。", status: :see_other }
        format.json { render :show, status: :ok, location: @shopping_list }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @shopping_list.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /shopping_lists/1 or /shopping_lists/1.json
  def destroy
    @shopping_list.destroy!

    respond_to do |format|
      format.html { redirect_to shopping_lists_path, notice: "買い物リストを削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_list
      @shopping_list = ShoppingList.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shopping_list_params
      params.expect(shopping_list: [ :name, :memo ])
    end
end
