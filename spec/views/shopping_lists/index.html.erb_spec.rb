require 'rails_helper'

RSpec.describe "shopping_lists/index", type: :view do
  before(:each) do
    assign(:shopping_lists, [
      ShoppingList.create!(
        name: "週末の買い物",
        memo: "牛乳とパンを買う"
      ),
      ShoppingList.create!(
        name: "平日の買い物",
        memo: "卵を買う"
      )
    ])
  end

  it "買い物リストを件数分表示する" do
    render

    # partial（_shopping_list.html.erb）が 1 件につき div をひとつ描画する
    assert_select "#shopping_lists > div", count: 2
  end

  it "各買い物リストの名前とメモを表示する" do
    render

    # 名前とメモは partial の中の div に入っている（p ではない）
    cell_selector = "#shopping_lists > div > div"
    assert_select cell_selector, text: /週末の買い物/, count: 1
    assert_select cell_selector, text: /牛乳とパンを買う/, count: 1
    assert_select cell_selector, text: /平日の買い物/, count: 1
    assert_select cell_selector, text: /卵を買う/, count: 1
  end
end
