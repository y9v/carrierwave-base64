RSpec.describe Carrierwave::Base64::Adapter do
  describe '.mount_base64_uploader' do
    let(:uploader) { Class.new CarrierWave::Uploader::Base }

    subject do
      Post.mount_base64_uploader(:image, uploader)
      Post.new
    end

    it 'mounts the uploader on the image field' do
      expect(subject.image).to be_an_instance_of(uploader)
    end

    context 'normal file uploads' do
      before(:each) do
        sham_rack_app = ShamRack.at('www.example.com').stub
        sham_rack_app.register_resource(
          '/test.jpg', file_path('fixtures', 'test.jpg'), 'images/jpg'
        )
        subject[:image] = 'test.jpg'
      end

      it 'sets will_change for the attribute' do
        expect(subject.changed?).to be_truthy
      end

      it 'saves the file' do
        subject.save!
        subject.reload

        expect(
          subject.image.current_path
        ).to eq file_path('../uploads', 'test.jpg')
      end
    end

    context 'base64 strings' do
      before(:each) do
        subject.image = File.read(
          file_path('fixtures', 'base64_image.fixture')
        ).strip
      end

      it 'creates a file' do
        subject.save!
        subject.reload

        expect(
          subject.image.current_path
        ).to eq file_path('../uploads', 'file.jpg')
      end

      it 'sets will_change for the attribute' do
        expect(subject.changed?).to be_truthy
      end
    end

    context 'stored uploads exist for the field' do
      before :each do
        subject.image = File.read(
          file_path('fixtures', 'base64_image.fixture')
        ).strip
        subject.save!
        subject.reload
      end

      it 'removes files when remove_* is set to true' do
        subject.remove_image = true
        subject.save!
        expect(subject.reload.image.file).to be_nil
      end
    end
  end
end
