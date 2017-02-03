# carrierwave-base64 changelog

## 2.4.0

  - The `:file_name` option accepts a lambda with an argument, to which the model instance would be passed. This allows you to set the filename based on some model attribute (@lebedev-yury).
  - The file extension for the uploaded base64 string is identified automatically, using `MIME::Types`. In case if the mime type for your upload is not identified, you need to add it, using `MIME::Types.add` (@lebedev-yury, @Quintasan, @adamcrown).
  - **Deprecation**: Setting the `:file_name` option for the uploader to a string is deprecated. It has to be set to a Proc or lambda that returns a string instead (@lebedev-yury).

## 2.3.5

  - Fixed issue with mongoid models, when `attribute_will_change!` method was called, that wasn't defined in Mongoid models (credits to @cuongnm53)

## 2.3.4

  - Installation on the windows platform is fixed.

## 2.3.3

  - Added proc support for the `:file_name` option for the `mount_base64_uploader` method. (credits to @hendricius)

## 2.3.0

  - Added `:file_name` option for `mount_base64_uploader` method. All base64 uploads for this attribute will use the given filename for the stored file. The `:file_name` option should not contain the file extention (it will be taken from the content type of base64 string). (@HarenBroog, thanks for the idea)
