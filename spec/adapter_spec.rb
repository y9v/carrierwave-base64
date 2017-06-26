RSpec.describe Carrierwave::Base64::Adapter do
  describe '.mount_base64_uploader' do
    let(:uploader) { Class.new CarrierWave::Uploader::Base }

    context 'mongoid models' do
      let(:mongoid_model) do
        MongoidModel.mount_base64_uploader(:image, uploader)
        MongoidModel.new
      end

      it 'does not call will_change' do
        expect do
          mongoid_model.image = 'test.jpg'
        end.not_to raise_error
      end
    end

    context 'models without file_name option for the uploader' do
      subject do
        User.mount_base64_uploader(:image, uploader)
        User.new
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
          ).to eq file_path('../uploads', 'image.jpeg')
        end
      end
    end

    context 'models with file_name options for the uploader' do
      subject do
        User.mount_base64_uploader(
          :image, uploader, file_name: ->(u) { u.username }
        )
        User.new(username: 'batman')
      end

      it 'mounts the uploader on the image field' do
        expect(subject.image).to be_an_instance_of(uploader)
      end

      context 'when file_name is a string' do
        it 'issues a deprecation warning' do
          expect do
            User.mount_base64_uploader(
              :image, uploader, file_name: 'file_name'
            )
          end.to warn('Deprecation')
        end
      end

      context 'when file_name is a proc' do
        it 'does NOT issue a deprecation warning' do
          expect do
            User.mount_base64_uploader(
              :image, uploader, file_name: ->(u) { u.username }
            )
          end.not_to warn('Deprecation')
        end
      end

      context 'normal file uploads' do
        before(:each) do
          sham_rack_app = ShamRack.at('www.example.com').stub
          sham_rack_app.register_resource(
            '/test.jpg', file_path('fixtures', 'test.jpg'), 'images/jpg'
          )
          subject[:image] = 'test.jpg'
        end

        it 'sets will_change for the attribute on activerecord models' do
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
          ).to eq file_path('../uploads', 'batman.jpeg')
        end

        it 'sets will_change for the attribute' do
          expect(subject.changed?).to be_truthy
        end

        context 'with additional instances of the mounting class' do
          let(:another_subject) do
            another_subject = User.new(username: 'robin')
            another_subject.image = File.read(
              file_path('fixtures', 'base64_image.fixture')
            ).strip
            another_subject
          end

          it 'should invoke the file_name proc upon each upload' do
            subject.save!
            another_subject.save!
            another_subject.reload
            expect(
              another_subject.image.current_path
            ).to eq file_path('../uploads', 'robin.jpeg')
          end
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

        it 'keeps the file when setting the attribute to existing value' do
          expect(File.exist?(subject.reload.image.file.file)).to be_truthy
          subject.update!(image: subject.image.to_s)
          expect(File.exist?(subject.reload.image.file.file)).to be_truthy
        end

        it 'removes files when remove_* is set to true' do
          subject.remove_image = true
          subject.save!
          expect(subject.reload.image.file).to be_nil
        end
      end
    end
  end

  describe '.mount_base64_uploaders' do
    let(:uploader) { Class.new CarrierWave::Uploader::Base }

    context 'when model set filename with lambda' do
      subject do
        Email.mount_base64_uploaders(:attachments, uploader,
                                     file_name: ->(u) { u.subject })
        Email.new(
          subject: 'hello',
          attachments: [
            File.read(file_path('fixtures', 'base64_image.fixture')).strip,
            File.read(file_path('fixtures', 'base64_image.fixture')).strip
          ]
        )
      end

      it 'mounts the uploader on the image field' do
        expect(subject.attachments).to be_an_instance_of(Array)
      end

      it 'creates a file' do
        subject.save!
        subject.reload
        expect(
          subject.attachments[0].current_path
        ).to eq file_path('../uploads', 'hello_1.jpeg')

        expect(
          subject.attachments[1].current_path
        ).to eq file_path('../uploads', 'hello_2.jpeg')
      end

      it 'sets will_change for the attribute' do
        expect(subject.changed?).to be_truthy
      end
    end

    context 'when model set filename as string' do
      subject do
        Email.mount_base64_uploaders(:attachments, uploader,
                                     file_name: 'file')
        Email.new(
          attachments: [
            File.read(file_path('fixtures', 'base64_image.fixture')).strip,
            File.read(file_path('fixtures', 'base64_image.fixture')).strip
          ]
        )
      end

      it 'mounts the uploader on the image field' do
        expect(subject.attachments).to be_an_instance_of(Array)
      end

      it 'creates a file' do
        subject.save!
        subject.reload
        expect(
          subject.attachments[0].current_path
        ).to eq file_path('../uploads', 'file_1.jpeg')

        expect(
          subject.attachments[1].current_path
        ).to eq file_path('../uploads', 'file_2.jpeg')
      end

      it 'sets will_change for the attribute' do
        expect(subject.changed?).to be_truthy
      end
    end
  end
end
