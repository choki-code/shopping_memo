require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  let(:name) { 'テストリスト' }
  let(:memo) { 'テストメモ' }

  describe 'バリデーションの検証' do
    let(:shopping_list) { ShoppingList.new(name: name, memo: memo) }

    context '正常系' do
    it '有効である' do
      expect(shopping_list.valid?).to be(true)
    end

    context 'memoが空の場合' do
      let(:memo) { nil }
      it '有効である' do
        expect(shopping_list.valid?).to be(true)
      end
    end
  end

    context '異常系' do
      context 'nameが空の場合' do
        let(:name) { nil }

        it '無効である' do
          expect(shopping_list.valid?).to be(false)
          expect(shopping_list.errors[:name]).to include("can't be blank")
        end
      end
    end
  end

  describe 'ShoppingListが持つ情報の検証' do
    before { ShoppingList.create!(name: name, memo: memo) }

    subject { described_class.first }

    it 'ShoppingListの属性を返す' do
      expect(subject.name).to eq('テストリスト')
      expect(subject.memo).to eq('テストメモ')
    end
  end
end
