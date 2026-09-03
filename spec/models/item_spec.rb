require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:shopping_list) { ShoppingList.create!(name: 'テストリスト') }
  let(:name) { '牛乳' }

  describe 'バリデーションの検証' do
    let(:item) { shopping_list.items.build(name: name) }

    context '正常系' do
      it '有効である' do
        expect(item.valid?).to be(true)
      end
    end

    context '異常系' do
      context 'nameが空の場合' do
        let(:name) { nil }

        it '無効である' do
          expect(item.valid?).to be(false)
          expect(item.errors[:name]).to include("can't be blank")
        end
      end

      context '買い物リストに紐づかない場合' do
        let(:item) { Item.new(name: name) }

        it '無効である' do
          expect(item.valid?).to be(false)
          expect(item.errors[:shopping_list]).to include('must exist')
        end
      end
    end
  end

  describe 'Itemが持つ情報の検証' do
    before { shopping_list.items.create!(name: name) }

    subject { described_class.first }

    it 'Itemの属性を返す' do
      expect(subject.name).to eq('牛乳')
      expect(subject.shopping_list).to eq(shopping_list)
    end
  end

  describe '買い物リストとの関連の検証' do
    before { shopping_list.items.create!(name: name) }

    it 'リストを削除すると品目も削除される' do
      expect { shopping_list.destroy }.to change(Item, :count).by(-1)
    end
  end

  describe 'purchased の既定値の検証' do
    it '新しく作った品目は未購入である' do
      item = shopping_list.items.create!(name: name)
      expect(item.purchased).to be(false)
    end
  end

  describe 'scopeの検証' do
    let!(:milk) { shopping_list.items.create!(name: '牛乳', purchased: false) }
    let!(:bread) { shopping_list.items.create!(name: 'パン', purchased: true) }

    it 'unpurchasedは未購入の品目だけを返す' do
      expect(shopping_list.items.unpurchased).to eq([ milk ])
    end

    it 'purchasedは購入済みの品目だけを返す' do
      expect(shopping_list.items.purchased).to eq([ bread ])
    end
  end
end
