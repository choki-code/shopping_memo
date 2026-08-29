require 'rails_helper'

RSpec.describe "shopping_lists/edit", type: :view do
  let(:shopping_list) {
    ShoppingList.create!(
      name: "MyString",
      memo: "MyText"
    )
  }

  before(:each) do
    assign(:shopping_list, shopping_list)
  end

  it "renders the edit shopping_list form" do
    render

    assert_select "form[action=?][method=?]", shopping_list_path(shopping_list), "post" do

      assert_select "input[name=?]", "shopping_list[name]"

      assert_select "textarea[name=?]", "shopping_list[memo]"
    end
  end
end
