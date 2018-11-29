# carrierwave-base64 changelog

## 2.8.0

 - Mime Type is now detected from file contents, falling back to the type, specified by the user. (#73, @justisb)

## 2.7.0

 - Railtie is not required by default, so the gem can be used in non Rails app (@sleepingstu)

## 2.6.1

This release fixes the issue that the public API of the gem was changed in 2.6.0, by switching from RFC 2045 to RFC 4648 standard for base64 strings.

 - Switched back to RFC 2045 standard for base64 strings (@lebedev-yury)

## 2.6.0

 - Fixed the issue with base64 string not being validated (#64, @sjdrabbani)
 - Sending a base64 string with missing or unknown MIME Type will raise `Carrierwave::Base64::UnknownMimeTypeError` (@lebedev-yury)

## 2.5.3

 - Fixed an incorrect deprecation warning that fired even with `file_name` option set to a Proc (#60, @frodsan)

## 2.5.2

 - Fixed the exception for uploads without `file_name` option set (issue #56 by @hanhdt, fix by @szajbus)

## 2.5.1

 - Fixed the issue with the filename to be set once for a model, and never updated again (@dustMason, #55)

## 2.5.0

  - The uploaded file is not deleted, when the attribute is set to the existing file name (@lebedev-yury, bug-report #51 by @jmuheim)

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
