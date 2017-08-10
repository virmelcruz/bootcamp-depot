require 'rails_helper'

describe 'Checkout Process', type: :feature do
	describe 'Cart Page' do
		context 'when there are products in the store' do
			let!(:product) { FactoryGirl.create(:product, title: 'TicketBase generic ticket') } #use let for variables
			let!(:product) { FactoryGirl.create(:product, id: 123, title: 'TicketBase generic ticket2') } #use let for variables

			before do
				visit '/'
				find_button(id: 'product123').click
			end
			
			it 'displays the products in the cart' do
				expect(page).to have_content 'TicketBase generic ticket2'
			end
		end
	end
end