require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  describe 'GET #index' do
    it 'renders the :index template' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns new Badge to @badge' do
      get :index
      expect(assigns(:badge)).to be_a(Badge)
    end


  end
end
