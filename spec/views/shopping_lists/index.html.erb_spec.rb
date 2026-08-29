require 'rails_helper'

RSpec.describe "shopping_lists/index", type: :view do
  before(:each) do
    assign(:shopping_lists, [
      ShoppingList.create!(
        name: "Name",
        memo: "MyText"
      ),
      ShoppingList.create!(
        name: "Name",
        memo: "MyText"
      )
    ])
  end

  it "renders a list of shopping_lists" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
