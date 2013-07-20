unless global.hasOwnProperty('db')
  Sequelize = require('sequelize')

  if process.env.DATABASE_URL
    match = process.env.DATABASE_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)
    sequelize = new Sequelize match[5], match[1], match[2],
      dialect: 'postgres'
      protocol: 'postgres'
      port: match[4]
      host: match[3]

  else
    sequelize = new Sequelize 'lunchbase_development', 'lunchbase', '',
      dialect: 'postgres'
      protocol: 'postgres'

  global.db =
    Sequelize: Sequelize
    sequelize: sequelize
    User: sequelize.import(__dirname + "/user")
    Company: sequelize.import(__dirname + "/company")
    LunchEvent: sequelize.import(__dirname + "/lunch_event")
    LunchMatch: sequelize.import(__dirname + "/lunch_match")


  global.db.User
    .belongsTo(global.db.Company)
    .belongsTo(global.db.LunchMatch)

  global.db.Company
    .hasMany(global.db.User)

  global.db.LunchMatch
    .belongsTo(global.db.LunchEvent)
    .hasMany(global.db.User)

  global.db.LunchEvent
    .hasMany(global.db.LunchMatch)

module.exports = global.db
