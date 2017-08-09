require 'rails_helper'
#scenarios
#1. Presence
#2. Validity
#3. Format
describe Product do
	#describe === contrext
	describe 'validations' do #describe use when to group an object or test
		context 'when Title is blank' do #context use to describe condition under of it
			let(:product) { FactoryGirl.build(:product, title: '')} #builld instantiate new object without save

			it 'becomes invalid' do
				expect(product.valid?).to be false
			end

			it 'returns an error message' do
				product.save
				expect(product.errors.count).to eq 1
			end
		end

		context 'when Title already exists' do
			let!(:product) { FactoryGirl.create(:product, title: 'Shirt' )}
			let(:product2) { FactoryGirl.build(:product, title: 'Shirt' )}

			it 'becomes invalid' do
				expect(product2.valid?).to be false
			end

			it 'retuns an error message' do
				product2.save
				expect(product2.errors.count).to eq 1
			end

		end
	end
end