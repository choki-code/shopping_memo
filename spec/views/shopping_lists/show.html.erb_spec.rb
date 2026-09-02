require 'rails_helper'

RSpec.describe "shopping_lists/show", type: :view do
  let(:shopping_list) do
    ShoppingList.create!(name: "週末の買い物", memo: "牛乳とパンを買う")
  end
  let!(:milk) { shopping_list.items.create!(name: "牛乳") }
  let!(:bread) { shopping_list.items.create!(name: "パン") }

  before(:each) do
    # コントローラの show が用意しているものと同じ 3 つを渡す。
    # view spec はコントローラを通らないため、ここで揃えないと nil になる
    assign(:shopping_list, shopping_list)
    assign(:items, shopping_list.items.order(:created_at))
    assign(:item, shopping_list.items.build)
  end

  it "買い物リストの名前とメモを表示する" do
    render

    expect(rendered).to match(/週末の買い物/)
    expect(rendered).to match(/牛乳とパンを買う/)
  end

  it "品目を追加した順に表示する" do
    render

    expect(rendered).to match(/牛乳/)
    expect(rendered).to match(/パン/)
    expect(rendered.index("牛乳")).to be < rendered.index("パン")
  end

  it "品目ごとに宛先の異なる削除ボタンを表示する" do
    render

    assert_select "form[action=?]", shopping_list_item_path(shopping_list, milk)
    assert_select "form[action=?]", shopping_list_item_path(shopping_list, bread)
  end

  it "フォーム用に用意した未保存の品目を一覧に混ぜない" do
    render

    # 未保存の Item が一覧に出ると、名前が空で宛先 id を持たない削除ボタンが
    # 1 つ増える。その削除ボタンの action は追加フォームと同じ URL になるため、
    # この URL を持つ form が 1 つ（＝追加フォームだけ）であることを確かめる
    assert_select "form[action=?]", shopping_list_items_path(shopping_list), count: 1
  end

  it "品目の追加フォームを表示する" do
    render

    assert_select "form[action=?][method=?]", shopping_list_items_path(shopping_list), "post" do
      assert_select "input[name=?]", "item[name]"
    end
  end
end
