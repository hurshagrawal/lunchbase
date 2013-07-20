module.exports = (sequelize, DataTypes) ->
  sequelize.define "User",
    name:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notNull: true
    email: 
      type: DataTypes.STRING
      validate:
        notNull: true
    isCreator: 
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: false
      validate:
        notNull: true


