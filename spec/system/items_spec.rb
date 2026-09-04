require 'rails_helper'

RSpec.describe "品目", type: :system do
  let(:shopping_list) do
    ShoppingList.create!(name: "週末の買い物", memo: "牛乳とパンを買う")
  end

  describe "詳細画面から追加する" do
    it "追加した品目が一覧に表示される" do
      visit shopping_list_path(shopping_list)

      fill_in "品目名", with: "キャベツ"
      click_on "登録する"

      expect(page).to have_content "品目を追加しました。"
      expect(page).to have_content "キャベツ"
    end

    it "名前が空のときは追加できず、エラーが表示される" do
      visit shopping_list_path(shopping_list)

      click_on "登録する"

      expect(page).to have_content "品目名を入力してください"
      expect(shopping_list.items.count).to eq 0
    end
  end

  describe "詳細画面から削除する" do
    it "削除した品目が一覧から消える" do
      shopping_list.items.create!(name: "キャベツ")

      visit shopping_list_path(shopping_list)
      click_on "この品目を削除"

      expect(page).to have_content "品目を削除しました。"
      expect(page).to have_no_content "キャベツ"
    end
  end

  describe "詳細画面から購入状態を切り替える" do
    it "☐ を押すと購入済みセクションに移動する" do
      shopping_list.items.create!(name: "キャベツ")

      visit shopping_list_path(shopping_list)
      click_on "☐"

      expect(page).to have_content "品目の購入状態を更新しました。"
      expect(page).to have_content "☑"
    end

    it "☑ を押すと未購入セクションに戻る" do
      shopping_list.items.create!(name: "キャベツ", purchased: true)

      visit shopping_list_path(shopping_list)
      click_on "☑"

      expect(page).to have_content "品目の購入状態を更新しました。"
      expect(page).to have_content "☐"
    end
  end

  describe "買い物リストごと削除する" do
    it "リストを削除すると品目も消える" do
      shopping_list.items.create!(name: "キャベツ")

      visit shopping_list_path(shopping_list)
      click_on "このリストを削除"

      expect(page).to have_content "買い物リストを削除しました。"
      expect(Item.count).to eq 0
    end
  end
end
