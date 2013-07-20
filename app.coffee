###
Module dependencies
###
express = require("express")
http = require("http")
path = require("path")
db = require("./models")

routes = require("./routes")

app = module.exports = express()

###
Configuration
###

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.cookieParser('811f9b3e237c5ea06d650b3da716ec3f')
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static(path.join(__dirname, "assets"))
app.use app.router

# development only
if app.get("env") == "development"
  app.use express.errorHandler()

###
Routes
###
# serve index and view partials
app.get("/", routes.index)
app.get("/signup", routes.signup)
app.get("/success", routes.signupSuccess)
app.get("/invites-sent", routes.invitesSent)

app.post("/users", routes.createUser)
app.post("/invite", routes.inviteUsers)

###
Run pending migrations and start server
###
db.sequelize.sync().complete (err) ->
  if err
    throw err
  else
    http.createServer(app).listen app.get("port"), ->
      console.log "Express server listening on port " + app.get("port")

