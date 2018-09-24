module Carrierwave
  module Base64
    # Exception that gets raised when base64 encoded string
    # is of unknown MIME type
    class UnknownMimeTypeError < ::ArgumentError; end
  end
end
