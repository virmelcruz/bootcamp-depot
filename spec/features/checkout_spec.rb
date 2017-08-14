require 'rails_helper'

describe 'Checkout Process', type: :feature do
	describe 'Cart Page' do
		context 'when there is 1 product in the store' do
			let!(:product) { FactoryGirl.create(:product, title: 'TicketBase generic ticket') } #use let for variables

			before do
				visit '/'
				click_button 'Add to Cart'
			end
			
			it 'displays the products in the cart' do
				expect(page).to have_content 'TicketBase generic ticket'
			end

			it 'displays the quantity of the prodcuts' do
				expect(page).to have_content '1 ×'
			end

			it 'displays the total of the cart' do
				expect(page).to have_content 'Total P5.00'
			end

			context 'and the user presses the Empty Cart button' do

				before do
					click_button 'Empty cart'
					page.driver.accept_js_confirms!
				end
				
				it 'it empties the cart', js: true do
					expect(page).to have_content 'Cart was successfully emptied.'
				end

			end
		end

		context 'when there are multiple products in the store' do
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