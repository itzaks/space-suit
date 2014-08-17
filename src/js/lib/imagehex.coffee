module.exports = (file, cb) ->
  valid = (/image\/(gif|jpg|jpeg|tiff|png)$/i).test file.type

  return false if not valid

  reader = new FileReader()

  reader.onload = (e) ->
    cb(e.target.result)

  reader.readAsDataURL(file)
