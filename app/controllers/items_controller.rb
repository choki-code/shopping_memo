class ItemsController < ApplicationController
  before_action :set_shopping_list
  def create
    @item = @shopping_list.items.build(item_params)

    if @item.save
      redirect_to @shopping_list, notice: "Item was successfully created."
    else
      @unpurchased = @shopping_list.items.unpurchased.order(:created_at)
      @purchased = @shopping_list.items.purchased.order(:created_at)
      render "shopping_lists/show", status: :unprocessable_content
    end
  end

  def update
    @item = @shopping_list.items.find(params.expect(:id))
    @item.update!(purchased_params)

    redirect_to @shopping_list, notice: "Item was successfully updated."
  end

  def destroy
    @item = @shopping_list.items.find(params.expect(:id))
    @item.destroy!

    redirect_to @shopping_list, notice: "Item was successfully destroyed.", status: :see_other
  end

  private

  def set_shopping_list
    @shopping_list = ShoppingList.find(params.expect(:shopping_list_id))
  end

  def item_params
    params.expect(item: [ :name ])
  end

  def purchased_params
    params.expect(item: [ :purchased ])
  end
end
