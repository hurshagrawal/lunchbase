Q = require 'q'
path = require 'path'

# Compiles email templates
emailTemplates = require 'email-templates'
templatesDir = path.resolve('./templates')

# Converts templates to MIME
MailComposer = require("mailcomposer").MailComposer
mc = new MailComposer

# Sends emails
Mailgun = require('mailgun').Mailgun
mg = new Mailgun('key-11s1fahgq5wyiarfki7wjiwvz-f-33d7')

###
Routes
###

exports.index = (req, res) ->
  res.render("index")

exports.signup = (req, res) ->
  res.render("signup")

exports.signupSuccess = (req, res) ->
  res.render("signup_success")

exports.invitesSent = (req, res) ->
  res.render("invites_sent")

exports.createUser = (req, res) ->
  user = null
  # Create the user
  global.db.User.create(req.param('user')).then((createdUser) ->
    user = createdUser
    res.cookie 'lunchbase',
      id: user.getDataValue('id')
      name: user.getDataValue('name')
    ,
      signed: true

    # Query for or create the company
    companyId = req.param('company').id
    if companyId
      global.db.Company.find(companyId)
    else
      global.db.Company.create(req.param('company'))
  ).then((company) ->
    # Associate the company and user
    user.setCompany(company)
  ).then (success, error) ->
    # Send confirmation email and render success
    if success
      sendConfirmationEmail(user).then ->
        res.redirect('/success')
    else if error
      res.render('404')


exports.inviteUsers = (req, res) ->
  emails = req.param('emails').match(/(\w[-._+\w]*\w@\w[-._\w]*\w\.\w{2,3})/g)
  subject = req.param('subject')
  body = req.param('body')

  debugger

  name = req.signedCookies.lunchbase?.name
  if name
    from = "#{name} <noreply@lunchbase.com>"
  else
    from = "Lunchbase <noreply@lunchbase.com>"

  sendTextEmail(from, emails, subject, body).then ->
    res.redirect('/invites-sent')


###
Emails
###

sendConfirmationEmail = (user) ->
  to = [ user.getDataValue('email') ]
  subject = 'Thanks for signing up!'
  locals =
    name: user.getDataValue('name')
  sendEmail(to, subject, 'confirmation', locals)

sendEmail = (to, subject, templateName, locals) ->
  deferred = Q.defer()
  emailTemplates templatesDir, (err, template) ->
    template templateName, locals, (err, html, text) ->
      from = 'Lunchbase <noreply@lunchbase.com>'

      mc.setMessageOption({ from: from, to: to, subject: subject, html: html })
      mc.buildMessage (err, message) ->
        mg.sendRaw from, to, message, ->
          deferred.resolve()

  deferred.promise

sendTextEmail = (from, to, subject, body) ->
  deferred = Q.defer()
  mg.sendText from, to, subject, body, ->
    deferred.resolve()

  deferred.promise

