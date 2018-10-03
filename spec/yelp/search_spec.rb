require 'spec_helper'

RSpec.describe Yelp::Search do
  context 'instance methods' do
    let(:token) { 'ABC123' }

    subject(:search_client) { described_class.new(search_params) }

    if ENV['YELP_ACCESS_TOKEN']
      context 'with a real access token' do
        before { Yelp.access_token = ENV['YELP_ACCESS_TOKEN'] }

        context 'when params are present' do
          let(:search_params) { "location=#{zip_code}" }
          let(:zip_code) { '94110' }

          it 'does a thing' do
            expect(search_client.search['businesses'][0]['location']['zip_code']).to eq(zip_code)
          end
        end
      end
    end
  end
end
