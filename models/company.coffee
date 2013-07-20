module.exports = (sequelize, DataTypes) ->
  sequelize.define "Company",
    name:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notNull: true
    address:
      type: DataTypes.TEXT
      allowNull: false
      validate:
        notNull: true
    lat:
      type: DataTypes.INTEGER
    long:
      type: DataTypes.INTEGER


