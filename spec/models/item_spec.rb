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
end
