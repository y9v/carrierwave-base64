RSpec.describe Carrierwave::Base64::Base64StringIO do
  %w[application/vnd.openxmlformats-officedocument.wordprocessingml.document
     image/jpeg application/pdf audio/mpeg].each do |content_type|
    context "correct #{content_type} data" do
      let(:data) do
        "data:#{content_type};base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q=="
      end

      let(:file_extension) do
        MIME::Types[content_type].last.preferred_extension
      end

      subject { described_class.new data, 'file' }

      it 'determines the file format from the Data URI content type' do
        expect(subject.file_extension).to eql(file_extension)
      end

      it 'should respond to :original_filename' do
        expect(subject.original_filename).to eql("file.#{file_extension}")
      end

      it 'calls a function that returns the file_name' do
        method = ->(u) { u.username }
        base64_string_io = described_class.new(
          data, method.curry[User.new(username: 'batman')]
        )
        expect(base64_string_io.file_name).to eql('batman')
      end

      it 'accepts a string as the file name as well' do
        model = described_class.new data, 'string-file-name'
        expect(model.file_name).to eql('string-file-name')
      end

      it 'issues deprecation warning when string given for file name' do
        str = ->(u) { u.username }.curry[User.new(username: 'batman')]
        expect do
          described_class.new(data, str).file_name
        end.to warn('Deprecation')
      end

      it 'does NOT issue deprecation warning when Proc given for file name' do
        prc = -> { 'String' }
        expect do
          described_class.new(data, prc).file_name
        end.not_to warn('Deprecation')
      end
    end
  end

  context 'invalid image data' do
    it 'raises an ArgumentError if Data URI content type is missing' do
      expect do
        described_class.new('/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q==', 'file')
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end

    it 'raises ArgumentError if base64 data eql (null)' do
      expect do
        described_class.new('data:image/jpeg;base64,(null)', 'file')
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end
  end
end
