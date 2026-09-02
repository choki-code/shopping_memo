require 'rails_helper'

RSpec.describe "shopping_lists/show", type: :view do
  before(:each) do
    assign(:shopping_list, ShoppingList.create!(
      name: "Name",
      memo: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
