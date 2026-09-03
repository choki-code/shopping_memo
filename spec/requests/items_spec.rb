require 'rails_helper'

RSpec.describe "/shopping_lists/:shopping_list_id/items", type: :request do
  let(:shopping_list) { ShoppingList.create!(name: "週末の買い物", memo: "牛乳とパンを買う") }
  let(:valid_attributes) { { name: "牛乳" } }

  # name に presence バリデーションがあるので、空にすると無効になる
  let(:invalid_attributes) { { name: "" } }

  describe "POST /create" do
    context "有効なパラメータの場合" do
      it "品目が1件増える" do
        expect {
          post shopping_list_items_url(shopping_list), params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it "URL で指定した買い物リストに紐づけて作成する" do
        post shopping_list_items_url(shopping_list), params: { item: valid_attributes }

        expect(Item.last.shopping_list).to eq(shopping_list)
      end

      it "買い物リストの詳細画面にリダイレクトする" do
        post shopping_list_items_url(shopping_list), params: { item: valid_attributes }

        expect(response).to redirect_to(shopping_list_url(shopping_list))
      end
    end

    context "無効なパラメータの場合" do
      it "品目が増えない" do
        expect {
          post shopping_list_items_url(shopping_list), params: { item: invalid_attributes }
        }.not_to change(Item, :count)
      end

      # リダイレクトすると @item が捨てられ、何が悪かったのか画面に出せない。
      # 詳細画面をその場で描き直し、422 を返していることを確かめる
      it "422 を返し、詳細画面をエラー付きで描き直す" do
        post shopping_list_items_url(shopping_list), params: { item: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("prohibited this item from being saved")
      end
    end
  end

  describe "PATCH /update" do
    it "未購入の品目を購入済みに変える" do
      item = shopping_list.items.create!(valid_attributes)

      patch shopping_list_item_url(shopping_list, item), params: { item: { purchased: true } }

      expect(item.reload.purchased).to be(true)
    end

    it "買い物リストの詳細画面にリダイレクトする" do
      item = shopping_list.items.create!(valid_attributes)

      patch shopping_list_item_url(shopping_list, item), params: { item: { purchased: true } }

      expect(response).to redirect_to(shopping_list_url(shopping_list))
    end

    context "許可してない属性を混ぜて送った場合" do
      it "nameは書き変わらない" do
        item = shopping_list.items.create!(valid_attributes)

        patch shopping_list_item_url(shopping_list, item), params: { item: { purchased: true, name: "書き換え" } }

        expect(item.reload.name).to eq("牛乳")
        expect(item.purchased).to be(true)
      end
    end

    context "URL のリストに属さない品目を指定した場合" do
      it "404 を返し、購入状態を変えない" do
        other_list = ShoppingList.create!(name: "平日の買い物")
        other_item = other_list.items.create!(name: "卵")

        patch shopping_list_item_url(shopping_list, other_item), params: { item: { purchased: true } }

        expect(response).to have_http_status(:not_found)
        expect(other_item.reload.purchased).to be(false)
      end
    end
  end

  describe "DELETE /destroy" do
    it "品目が1件減る" do
      item = shopping_list.items.create!(valid_attributes)

      expect {
        delete shopping_list_item_url(shopping_list, item)
      }.to change(Item, :count).by(-1)
    end

    # DELETE に 302 を返すと Turbo が同じメソッドでリダイレクト先へ行こうとするため、
    # 303 See Other（次は GET で取り直せ）である必要がある
    it "303 で買い物リストの詳細画面にリダイレクトする" do
      item = shopping_list.items.create!(valid_attributes)

      delete shopping_list_item_url(shopping_list, item)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(shopping_list_url(shopping_list))
    end

    # URL の :shopping_list_id を見ずに Item.find で探すと、他のリストの品目まで
    # 削除できてしまう。親から辿って探していることを固定する
    context "URL のリストに属さない品目を指定した場合" do
      it "404 を返し、削除しない" do
        other_list = ShoppingList.create!(name: "平日の買い物")
        other_item = other_list.items.create!(name: "卵")

        expect {
          delete shopping_list_item_url(shopping_list, other_item)
        }.not_to change(Item, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
