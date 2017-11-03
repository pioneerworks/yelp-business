require 'spec_helper'

RSpec.describe Yelp::Business do
  it 'has a version number' do
    expect(Yelp::Business::VERSION).not_to be nil
  end

  context 'class methods' do
    let(:token) { 'some-random-token' }
    describe '.configure ' do
      before do
        Yelp.access_token = nil # set directly
        # now set via configure
        Yelp::Business.configure do |config|
          config.access_token = token
        end
      end

      subject(:yelp) { Yelp }
      its(:access_token) { should eq token }
    end

    describe '.business_id_from' do
      let(:url) { 'https://www.yelp.com/biz/gary-danko-san-francisco' }
      let(:id) { 'gary-danko-san-francisco' }
      subject { described_class.business_id_from(url) }
      it { is_expected.to eq id }
    end
  end

  context 'instance methods' do
    let(:business_id) { 'gary-danko-san-francisco' }
    let(:business_url) { "https://www.yelp.com/biz/#{business_id}" }
    let(:api_url) { "https://api.yelp.com/v3/businesses/#{business_id}" }
    let(:token) { 'ABC123' }

    subject(:business) { described_class.new(business_id) }

    before { Yelp.access_token = token }

    context '#initialize' do
      context 'from business ID' do
        its(:business_url) { should eq business_url }
        its(:business_id) { should eq business_id }
        its(:api_url) { should eq api_url }
        its(:access_token) { should eq token }
      end
    end

    context 'with the actual JSON call stubbed out' do
      let(:json_fixture) { File.read('spec/fixtures/gary-danko.json') }
      let(:hash) { JSON.load(json_fixture) }

      before do
        allow_any_instance_of(described_class).
          to receive(:api_fetch).and_return(hash)

        business.get
        expect(hash['name']).to eq 'Gary Danko'
      end

      context 'data method forwarding' do
        its(:name) { should eq 'Gary Danko' }
      end

      context '#get_remote_json' do
        let(:business_id) { 'gary-danko-san-francisco' }
        let(:url) { business.api_url }
        let(:bearer_token) { business.send(:bearer_token) }

        context 'with invalid access token' do
          before { Yelp.access_token = token }
          its(:access_token) { should eq token }
          it 'returns unauthorized' do
            expect(HTTP.auth(bearer_token).get(url).code).to eq 401
          end
        end
      end
    end

    if ENV['YELP_ACCESS_TOKEN']
      context 'with a real access token' do
        before { Yelp.access_token = ENV['YELP_ACCESS_TOKEN'] }

        context 'valid business' do
          before { business.get }
          let(:business_id) { 'gary-danko-san-francisco' }
          its(:review_count) { should be > 4200 }
        end

        context 'invalid business' do
          let(:business_id) { '24324324' }
          before { expect(business).to receive(:error).at_least(2).times }
          it 'should raise BusinessNotFoundError' do
            expect { business.get }.to raise_error (Yelp::BusinessNotFoundError)
          end
        end

        context 'get_reviews' do
          before { business.get_reviews }

          let(:business_id) { 'gary-danko-san-francisco' }

          its(:reviews) { should be_an_instance_of(Array) }
        end
      end
    end
  end
end
