require 'rails_helper' #requires ruby helper, we dont require in classes kasi kasama na sa bundler yon, rails_helper = import

describe 'product page navigation', type: :feature do #we describe the test, we add type: :feature for ruby to ddetermines its not model test
  describe 'Product Creation' do #under of it will be under product creation
    context 'when user inputs is valid' do
      before do #will do before the it statement
        visit '/products'
        click_link 'New Product'
        fill_in 'Title', with: 'Shirt' #Case senstive must be the same on the form
        fill_in 'Description', with: 'good shirt'
        fill_in 'Image url', with: 'http://www.test.com/whatever.jpg'
        fill_in 'Price', with: '200'
        click_button 'Create Product'
      end

      it 'creates a product' do #must enclose with it. we just simulate the users.
        expect(page).to have_content 'Product was successfully created' #assertion
      end
    end


    #validation for each scenarios
    #1. Blank
    #2. Title is blank
    #3. Description is blank
    #4. Image URL is blank
    #5. Price is blank
    #6. Duplicate Title
    #7. Image URL validity
    #8. Price Format

    context 'when user input is invalid' do #another context for checking if the inputs is invalid
      before do
        visit '/products'
        click_link 'New Product'
      end

      context 'when the form is blank' do
        before do
          fill_in 'Title', with: 'Shirt'
          fill_in 'Description', with: 'good shirt'
          fill_in 'Image url', with: 'http://www.test.com/whatever.jpg'
          fill_in 'Price', with: '1'
        end

        context 'when all fields are completely blank' do
          before do
            fill_in 'Title', with: ''
            fill_in 'Description', with: ''
            fill_in 'Image url', with: ''
            fill_in 'Price', with: ''
            click_button 'Create Product'
          end

          it 'returns an error for all fields' do 
            expect(page).to have_content "Title can't be blank"
            expect(page).to have_content "Description can't be blank"
            expect(page).to have_content "Image url can't be blank"
            expect(page).to have_content "Price is not a number"
          end
        end

        context 'when Title is blank' do
          before do
            fill_in 'Title', with: ''
            click_button 'Create Product'
          end
          
          it 'return error for Title' do
            expect(page).to have_content "Title can't be blank"
          end

          it 'will not return an error for other fields' do
            expect(page).not_to have_content "Description can't be blank"
            expect(page).not_to have_content "Image url can't be blank"
            expect(page).not_to have_content "Price is not a number"
          end
        end

        context 'when Description is blank' do
          before do
            fill_in 'Description', with: ''
            click_button 'Create Product'
          end
          
          it 'return error for Description' do
            expect(page).to have_content "Description can't be blank"
          end

          it 'will not return an error for other fields' do
            expect(page).not_to have_content "Title can't be blank"
            expect(page).not_to have_content "Image url can't be blank"
            expect(page).not_to have_content "Price is not a number"
          end
        end

        context 'when Image URL is blank' do
          before do
            fill_in 'Image url', with: ''
            click_button 'Create Product'
          end
          
          it 'return error for Image URL' do
            expect(page).to have_content "Image url can't be blank"
          end

          it 'will not return an error for other fields' do
            expect(page).not_to have_content "Title can't be blank"
            expect(page).not_to have_content "Description can't be blank"
            expect(page).not_to have_content "Price is not a number"
          end
        end

        context 'when Price is blank' do
          before do
            fill_in 'Price', with: ''
            click_button 'Create Product'
          end
          
          it 'return error for Price' do
            expect(page).to have_content "Price is not a number"
          end

          it 'will not return an error for other fields' do
            expect(page).not_to have_content "Title can't be blank"
            expect(page).not_to have_content "Description can't be blank"
            expect(page).not_to have_content "Image url can't be blank"
          end
        end
      end

      context 'when Title already exist' do
        let!(:product) { FactoryGirl.create(:product, title: 'Shirt') } #variable declaration in rspec outside the it block

        it 'return error for Title' do
          visit '/products'
          click_link 'New Product'
          fill_in 'Title', with: 'Shirt'
          fill_in 'Description', with: 'good shirt'
          fill_in 'Image url', with: 'http://www.test.com/whatever.jpg'
          fill_in 'Price', with: '200'
          click_button 'Create Product'

          expect(page).to have_content 'Title has already been taken'
        end
      end

      context 'when Image URL is invalid' do
        it 'returns an error for Image URL' do
          visit '/products'
          click_link 'New Product'
          fill_in 'Title', with: 'Shirt'
          fill_in 'Description', with: 'good shirt'
          fill_in 'Image url', with: 'http://www.test.com/whatever.jp'
          fill_in 'Price', with: '200'
          click_button 'Create Product'

          expect(page).to have_content 'Image url must be a URL for GIF, JPG or PNG image'
        end
      end

      context 'when Price is invalid format' do
        before do
          visit '/products'
          click_link 'New Product'
          fill_in 'Title', with: 'Shirt'
          fill_in 'Description', with: 'good shirt'
          fill_in 'Image url', with: 'http://www.test.com/whatever.jp'
        end
        
        context 'and it is not a number' do
          it 'returns an error for Price' do
            fill_in 'Price', with: 'abcde'
            click_button 'Create Product'

            expect(page).to have_content 'Price is not a number'
          end
        end

        context 'and it lower than 0.01' do
          it 'returns an error for Price' do
            fill_in 'Price', with: '0'
            click_button 'Create Product'
            
            expect(page).to have_content 'Price must be greater than or equal to 0.01'
          end
        end
      end

    end
  end
end