#encoding: utf-8
require 'spec_helper'

describe CrossLockable::TokenGenerator do
  require 'digest/sha1'

  let!(:random) { '0123456789' }
  let!(:now) do
    Time.now.tap do |now|
      Time.stub(:now).and_return(now)
    end
  end

  before { CrossLockable.lockable_secret = 'lockabletest' }

  describe ".generate_security_token" do
    before do
      Kernel.stub(:rand).and_return(random)
    end

    context "when it's not passed timestamp and random number" do
      it "generates security token" do
        token = now.to_i.to_s + random + Digest::SHA1.hexdigest(now.to_i.to_s + random + CrossLockable.lockable_secret)
        CrossLockable::TokenGenerator.generate_security_token.should eq token
      end
    end

    context "when timestamp and random number it's passed" do
      let!(:random)    { '9876543210' }
      let!(:timestamp) { 3.days.ago }

      it "generates security token with them" do
        token = timestamp.to_i.to_s + random + Digest::SHA1.hexdigest(timestamp.to_i.to_s + random + CrossLockable.lockable_secret)
        CrossLockable::TokenGenerator.generate_security_token(timestamp, random).should eq token
      end
    end
  end

  describe ".valid_token?" do

    context "when token is not valid" do
      context "with wrong secret" do
        it "should be false" do
          invalid_token = now.to_i.to_s + random + Digest::SHA1.hexdigest(now.to_i.to_s + random + 'fake_secret')
          CrossLockable::TokenGenerator.valid_token?(invalid_token).should be_false
        end
      end

      context "with wrong timestamp" do
        it "should be false" do
          invalid_token = now.to_i.to_s + random + Digest::SHA1.hexdigest('1234567890' + random + CrossLockable.lockable_secret)
          CrossLockable::TokenGenerator.valid_token?(invalid_token).should be_false
        end
      end

      context "with wrong random" do
        it "should be false" do
          invalid_token = now.to_i.to_s + random + Digest::SHA1.hexdigest(now.to_i.to_s + '1234567890' + CrossLockable.lockable_secret)
          CrossLockable::TokenGenerator.valid_token?(invalid_token).should be_false
        end
      end
    end

    context "when token is valid" do
      it "should be true" do
        valid_token = now.to_i.to_s + random + Digest::SHA1.hexdigest(now.to_i.to_s + random + CrossLockable.lockable_secret)
        CrossLockable::TokenGenerator.valid_token?(valid_token).should be_true
      end
    end
  end
end