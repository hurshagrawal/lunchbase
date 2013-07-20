###
  GET home page.
###

exports.index = (req, res) ->
  res.render("index")

exports.createUser = (req, res) ->
  global.db.User.create(req.params.user).success ->
    res.render('success')


