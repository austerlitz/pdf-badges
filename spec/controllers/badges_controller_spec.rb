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

  describe 'POST #create' do
    let(:valid_params) {{badge: build(:badge).as_json}}
    let(:invalid_params) {{badge: build(:badge, paper_size: 'wrong').as_json}}

    context 'with valid params' do
      it 'creates a badge' do
        post :create, params: valid_params
        expect(response.headers['Content-Type']).to match 'application/pdf'
      end
    end

    context 'with invalid params' do
      it 'rerenders a form' do
        post :create, params: invalid_params
        expect(response.headers['Content-Type']).to match 'text/html'
        expect(response).to render_template :index
      end
    end
  end
end
