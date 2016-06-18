# carrierwave-base64 changelog

## 2.3.0

  - Added `:file_name` option for `mount_base64_uploader` method. All base64 uploads for this attribute will use the given filename for the stored file. The `:file_name` option should not contain the file extention (it will be taken from the content type of base64 string). (@HarenBroog, thanks for the idea)
