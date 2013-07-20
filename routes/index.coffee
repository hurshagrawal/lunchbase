###
  GET home page.
###

exports.index = (req, res) ->
  res.render("index")

exports.createUser = (req, res) ->
  user = null
  # Create the user
  global.db.User.create(req.params.user).then((createdUser) ->
    user = createdUser

    # Query for or create the company
    companyId = req.params.company.id
    if companyId
      global.db.Company.find(companyId)
    else
      global.db.Company.create(req.params.company)
  ).then((company) ->
    # Associate the company and user
    user.setCompany(company)
  ).then (success, error) ->
    if success
      res.render('success')
    else if error
      res.render('404')
