require 'spec_helper'

describe Ghee::API::Gists do
  subject { Ghee.new(ACCESS_TOKEN) }

  def should_be_a_gist(gist)
    gist['description'].should be_instance_of(String)
    gist['url'].should include('https://api.github.com/gists/')
    gist['user']['url'].should include('https://api.github.com/users/')
    gist['created_at'].should_not be_nil
    gist['files'].should be_instance_of(Hash)
    gist['files'].size.should > 0
  end

  describe "#gists" do
    it "should return gists for authenticated user" do
      VCR.use_cassette('gists') do
        gists = subject.gists
        gists.size.should > 0
        should_be_a_gist(gists.first)
      end
    end

    describe "#public" do
      it "should return public gists" do
        VCR.use_cassette('gists.public') do
          gists = subject.gists.public
          gists.size.should > 0
          should_be_a_gist(gists.first)
        end
      end
    end

    describe "#starred" do
      it "should return starred gists" do
        VCR.use_cassette('gists.starred') do
          gists = subject.gists.starred
          gists.size.should > 0
          should_be_a_gist(gists.first)
        end
      end
    end
  end
end