require "spec_helper"

RSpec.describe Carrierwave::Base64::Base64StringIO do
  context "correct image data" do
    let(:image_data) { "data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }
    subject { described_class.new image_data }

    it "determines the image format from the Data URI scheme" do
      expect(subject.file_format).to eql("jpg")
    end

    it "should respond to :original_filename" do
      expect(subject.original_filename).to eql("file.jpg")
    end
  end

  context "correct pdf data" do
    let(:image_data) { "data:application/pdf;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }
    subject { described_class.new image_data }

    it "determines the image format from the Data URI scheme" do
      expect(subject.file_format).to eql("pdf")
    end

    it "should respond to :original_filename" do
      expect(subject.original_filename).to eql("file.pdf")
    end
  end

  context "correct mp3 data" do
    let(:audio_data) { "data:audio/mp3;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }
    subject { described_class.new audio_data }

    it "determines the image format from the Data URI scheme" do
      expect(subject.file_format).to eql("mp3")
    end

    it "should respond to :original_filename" do
      expect(subject.original_filename).to eql("file.mp3")
    end
  end

  context "incorrect image data" do
    it "raises an ArgumentError if Data URI scheme format is missing" do
      expect do
        described_class.new("/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q==")
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end

    it "raises ArgumentError if base64 data eql (null)" do
      expect do
        described_class.new("data:image/jpg;base64,(null)")
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end
  end
end
