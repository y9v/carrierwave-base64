require "spec_helper"

RSpec.describe Carrierwave::Base64::Base64StringIO do
  context "correct image data" do
    let(:image_data) { "data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }
    subject { described_class.new image_data }

    it "determines the image format from the Dara URI scheme" do
      expect(subject.image_format).to eql("jpg")
    end

    it "should respond to :original_filename" do
      expect(subject.original_filename).to eql("image.jpg")
    end
  end

  context "incorrect image data" do
    it "raises an ArgumentError if Data URI scheme format is missing" do
      expect do
        described_class.new("/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q==")
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end
  end
end
