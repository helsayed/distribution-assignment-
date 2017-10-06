require "service/request_handler_service"

describe Neo::Service::RequestHandlerService do
  describe "#initialize" do
    let(:target_url) { 'https://challenge.distribusion.com' }
    let(:source) { 'blabla' }
    let(:passphrase) { 'hackmeifucan' }

    context "when initializing requeser, data is being setted to it's attributes" do
      let(:requester) { Neo::Service::RequestHandlerService.new(target_url: target_url, source: source, passphrase: passphrase) }
      it{ expect(requester.target_url).to eq('https://challenge.distribusion.com') }
      it{ expect(requester.source).to eq('blabla') }
      it{ expect(requester.passphrase).to eq('hackmeifucan') }
    end

    context "when missing data" do
      it 'through exception when missing passphrase' do
        expect do
          Neo::Service::RequestHandlerService.new(target_url: target_url, source: source)
        end.to raise_error(ArgumentError, 'missing keyword: passphrase')
      end
      it 'through exception when missing source' do
        expect do
          Neo::Service::RequestHandlerService.new(target_url: target_url, passphrase: passphrase)
        end.to raise_error(ArgumentError, 'missing keyword: source')
      end
      it 'through exception when missing target_url' do
        expect do
          Neo::Service::RequestHandlerService.new(source: source, passphrase: passphrase)
        end.to raise_error(ArgumentError, 'missing keyword: target_url')
      end
    end

    context "when sending reques with success response" do
      before(:each) do
        response = double
        response.stub(:code) { 200 }
        response.stub(:body) { "dummy success response" }
        response.stub(:headers) { {} }
        RestClient.stub(:get) { response }
      end

      it{expect(Neo::Service::RequestHandlerService.new(target_url: target_url, source: source, passphrase: passphrase).execute).to eq('dummy success response')}
    end

    context "when sending reques with failur response" do
      before(:each) do
        response = double
        response.stub(:code) { 404 }
        response.stub(:body) { "dummy failur response" }
        response.stub(:headers) { {} }
        RestClient.stub(:get) { response }
      end

      it{expect(Neo::Service::RequestHandlerService.new(target_url: target_url, source: source, passphrase: passphrase).execute).to eq('dummy failur response')}
    end
  end
end
