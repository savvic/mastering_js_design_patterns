Religion = {}

class WateryGod
WateryGod::prayTo = ->
  console.log 'pray for water'
Religion.WateryGod = WateryGod

class AncientGods
AncientGods::prayTo = ->
Religion.AncientGods = AncientGods

class DefaultGods
DefaultGods::prayTo = ->
Religion.DefaultGods = DefaultGods

# module.exports = Religion

module.exports =
  watery: WateryGod
  ancient: AncientGods
  defaults: DefaultGods
