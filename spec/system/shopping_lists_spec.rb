require 'rails_helper'

RSpec.describe "買い物リスト", type: :system do
  describe "一覧から新規作成する" do
    it "作成した買い物リストが詳細画面に表示される" do
      visit shopping_lists_path
      click_on "リストを新規作成"

      fill_in "リスト名", with: "週末の買い物"
      fill_in "メモ", with: "牛乳とパンを買う"
      click_on "登録する"

      expect(page).to have_content "買い物リストを作成しました。"
      expect(page).to have_content "週末の買い物"
      expect(page).to have_content "牛乳とパンを買う"
    end

    it "名前が空のときは作成できず、エラーが表示される" do
      visit new_shopping_list_path

      fill_in "メモ", with: "牛乳とパンを買う"
      click_on "登録する"

      expect(page).to have_content "リスト名を入力してください"
      expect(ShoppingList.count).to eq 0
    end
  end

  describe "削除する" do
    it "詳細画面から削除すると一覧から消える" do
      ShoppingList.create!(name: "週末の買い物", memo: "牛乳とパンを買う")

      visit shopping_lists_path
      click_on "このリストを見る"
      click_on "このリストを削除"

      expect(page).to have_content "買い物リストを削除しました。"
      expect(page).to have_no_content "週末の買い物"
    end
  end
end
