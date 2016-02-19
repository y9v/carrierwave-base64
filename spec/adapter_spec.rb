require "spec_helper"

RSpec.describe Carrierwave::Base64::Adapter do
  let(:uploader) { Class.new CarrierWave::Uploader::Base }

  describe ".mount_base64_uploader" do
    subject do
      Post.mount_base64_uploader(:image, uploader)
      Post.new
    end

    it "mounts the uploader on the image field" do
      expect(subject.image).to be_an_instance_of(uploader)
    end

    it "handles normal file uploads" do
      sham_rack_app = ShamRack.at('www.example.com').stub
      sham_rack_app.register_resource("/test.jpg", file_path("fixtures", "test.jpg"), "images/jpg")
      subject[:image] = "test.jpg"
      subject.save!
      subject.reload
      expect(subject.image.current_path).to eq file_path("../uploads", "test.jpg")
    end

    it "handles data-urls" do
      subject.image = File.read(file_path("fixtures", "base64_image.fixture")).strip
      subject.save!
      subject.reload
      expect(subject.image.current_path).to eq file_path("../uploads", "file.jpg")
    end
  end

  describe ".mount_base64_uploaders" do
    subject do
      Post.mount_base64_uploaders(:images, uploader)
      Post.new
    end

    it "handles normal file uploads" do
      sham_rack_app = ShamRack.at('www.example.com').stub
      sham_rack_app.register_resource("/test.jpg", file_path("fixtures", "test.jpg"), "images/jpg")
      subject[:images] = ["test.jpg"]
      subject.save!
      subject.reload
      expect(subject.images.first.current_path).to eq file_path("../uploads", "test.jpg")
    end

    it "handles data-urls" do
      subject.images = [File.read(file_path("fixtures", "base64_image.fixture")).strip]
      subject.save!
      subject.reload
      expect(subject.images.first.current_path).to eq file_path("../uploads", "file.jpg")
    end
  end
end
