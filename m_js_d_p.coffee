# Mastering JS design patterns

# single responsibility principle
# ensure that each class has only one thing for which it has some responsibility

# class that looks up users from a database should itself not contain functionality to send e-mails to these users.
# That is too much responsibility.
# Complex adapters can be replaced with a composite object that will be explored later in this chapter.

log = console.log.bind(console)
fs = require 'fs'
numFile = './numbers.txt'
strFile = './string.txt'
EventEmmiter = require 'events'
server = require('http').createServer()
pry = require 'pry'

after = (ms, fn) -> setTimeout(fn, ms)


# modules
# attach an object to the global namespace

# Creational Patterns   **************************************************************************************

# Westeros = {}
# or better
Westeros = Westeros or {}

class Castle
  constructor: (@name) ->

# słowo kluczowe new, które tworzy obiekty na podstawie funkcji konstruujących

Westeros.Castle = Castle
Westeros.castle = new Westeros.Castle('castle tomek')
log Westeros.castle.name
for i of Westeros
  log i, "::", Westeros[i]

# first check if the object already exists, and use that version instead of reassigning the variable.
# This allows you to spread your definitions over a number of files - define a single class in each
# file and then bring them all together as part of the build process

# Abstract Factory -> concrete factories -> products

class KingJoffery

KingJoffery::makeDecision = ->
  log 'decision made by king Joffery'

KingJoffery::marry = ->

# for i of KingJoffery
#   log "king Joffery i is: #{i}"

class LordTywin

LordTywin::makeDecision = ->
  log 'decision made by hand lord Tywin'

# concrete factory method

class LannisterFactory

LannisterFactory::getKing = ->
  new KingJoffery()
LannisterFactory::getHandOfTheKing = ->
  new LordTywin()

# # for different family it looks like this:
# class DiffFamilyFactory
# DiffFamilyFactory::getKing = ->
#   new DiffFamilyKing()
# DiffFamilyFactory::getHandOfTheKing = ->
#   new DiffFamilyHandOfKing()

# use

class CourtSession
  constructor: (@abstractFactory, @complaintThreshold = 10) ->

CourtSession::complaintPresented = (complaint) ->
  log complaint
  if complaint.severity < @complaintThreshold
    @abstractFactory.getHandOfTheKing().makeDecision()
  else
    @abstractFactory.getKing().makeDecision()


courtSession1 = new CourtSession(new LannisterFactory, 7)
# courtSession2 = new CourtSession(new DiffFamilyFactory, 15)
log "courtSession1 complainThreshold is #{courtSession1.complaintThreshold}"
courtSession1.complaintPresented {severity: 8}
courtSession1.complaintPresented {severity: 12}

# Builder

class Event
  constructor: (@name) ->

Westeros.Event = Event

class Prize
  constructor: (@name) ->

Westeros.Prize = Prize

class Attendee
  constructor: (@name) ->

Westeros.Attendee = Attendee

class Tournament
  constructor: (events, attendees, prizes) ->
    @events = []
    @attendees = []
    @prizes = []

Westeros.Tournament = Tournament

class LannisterTournamentBuilder

LannisterTournamentBuilder::build = ->
  tournament = new Tournament
  tournament.events.push new Event('Joust')
  tournament.events.push new Event('Melee')
  tournament.attendees.push new Attendee('Jim')
  tournament.prizes.push new Prize('gold medal')
  tournament.prizes.push new Prize('silver medal')
  log tournament

Westeros.LannisterTournamentBuilder = LannisterTournamentBuilder

class TournamentBuilder

TournamentBuilder::build = (builder) ->
  builder.build()

Westeros.TournamentBuilder = TournamentBuilder

tournamentB = new Westeros.TournamentBuilder()
log tournamentB
theTournament = tournamentB.build(new Westeros.LannisterTournamentBuilder())
log theTournament

# Factory Method   *****************************************   *******************************************

religion = require './religion'
{watery} = require './religion'

log religion
log watery
log religion.watery

class GodFactory

GodFactory::build = (godName) ->
  if godName is 'watery'
    new religion.watery()
  else if godName is 'ancient'
    new religion.ancient()
  else
    new religion.DefaultGods()

class GodDeterminant
  constructor: (@religion, @prayerPurpose) ->

class Prayer
Prayer::pray = (godName) ->
  p = new GodFactory
  p.build(godName).prayTo()


god = new GodFactory
asia = god.build('watery')
log asia
log asia.name()
euroasia = god.build('ancient')

log asia.prayTo()
log euroasia.prayTo()

prejer = new Prayer
prejer.pray('watery')

# polish book example

class CarMaker

CarMaker::drive = ->
  log "Brum, I have #{@doors} doors"
CarMaker.factory = (type) ->
  constr = type
  if typeof CarMaker[constr] isnt "function"
    throw
      {name: 'Error', message: "#{constr} nie istnieje"}
      # log "Error #{constr} nie istnieje"
  if typeof CarMaker[constr]::drive isnt "function"
    CarMaker[constr].prototype = new CarMaker
  newCar = new CarMaker[constr]
  newCar

CarMaker.Compact = ->
  @doors = 4
CarMaker.SUV = ->
  @doors = 7


log CarMaker
auto = new CarMaker
auto_2 = CarMaker
log "to jest auto: #{auto}"
log "to jest auto_2: #{auto_2}"

for i,v of auto
  log i, " :: ", v

for i,v of auto_2
  log i, " :: ", v

corolla = CarMaker.factory('Compact')
log corolla
corolla.drive()
# expedition = new CarMaker.factory('suv')
f150 = auto_2.factory('SUV')
f150.drive()

o = new Object()
n = new Object(1)
s = Object('1')
b = Object(true)

log o.constructor is Object
log n.constructor is Number
log s.constructor is String
log b.constructor is Boolean


# Prototype pattern page 79

#   *************************************************   ***************************************************
#   Copying existing objects

clone = (source, destination) ->
  for attr of source.prototype
    destination.prototype[attr] = source.prototype[attr]

cloneCoffee = (s,d) ->
  for attr of s::
    d::attr = s::attr
#   *************************************************   ***************************************************

class Lannister
  Lannister::clone = ->
    clone = new Lannister
    for attr of @
      clone[attr] = @[attr]
    clone

jamie = new Lannister
jamie.swordSkills = 9
jamie.charm = 6
jamie.wealth = 10
tyrion = jamie.clone()
tyrion.charm = 10

log "tyrion wealth is cloned and = #{tyrion.wealth}"


# Singleton book pl str 139


Universe1 = -> # class Universe
  return Universe1.instance if typeof Universe1.instance is 'object'
  @start_time = 0
  @big_bang = 'wielki'
  Universe1.instance = @

uni1 = new Universe1
uni2 = new Universe1
log "uni1 is uni2 #{uni1 is uni2}"
log Universe1.instance
log Universe1

Universe2 = ->
  instance = @
  @start_time = 1
  @big_bang = 'duży'
  Universe2 = ->
    return instance

# uni5 = new Universe2 - # drugie i następne wywołania wykonują już zmieniony konstruktor
# jest to wzorzec samomodyfikującej się funkcji :: WADA :: nadpisana funkcja utraci wszystkie właściwości
# dodane między jej zdefiniowaniem i nadpisaniem
uni3 = new Universe2
uni4 = new Universe2
log "uni3 is uni4 #{uni3 is uni4}"

# Universe3 = ->
#   Universe3 = -> instance
#   Universe3.prototype = @
#   instance = new Universe3
#   instance.constructor = Universe3
#   instance.start_time = 2
#   instance.big_bang = 'ogromny'
#   instatnce

# Universe3::nothing = true
# uni6 = new Universe3
# Universe3::everything = true
# uni7 = new Universe3
# log "uni6 is uni7 #{uni6 is uni7}"



# Structural Patterns   *************************************   simple ways in which objects can interact

# Adapter pattern   *****************************************  p.84  *******************************************

# We may need to make use of a class that does not perfectly fit the required interface.
# The class may be missing methods or may have additional methods we would like to hide.
# When building library code, adapters can be used to mask the internal method and only present the limited functions needed by the end user.
# ShipAdapter is simplified version of Ship interface

class Ship
  SetRudderAngleTo: (angle) -> log angle
  SetSailConfiguration: (configuration) ->
  SetSailAngle: (sailId, sailAngle) -> log sailId, sailAngle
  GetCurrentBearing: () -> 7
  GetCurrentSpeedEstimate: () -> 7
  ShiftCrewWeightTo: (weightToShift, locationId) ->

ShipAdapter = do ->
  class ShipAdapter
    constructor: (ship) ->
      @ship = new Ship

    TurnLeft: () ->
      @ship.SetRudderAngleTo(-30)
      @ship.SetSailAngle(3, 12)

    TurnRight: () ->
      @ship.SetRudderAngleTo(30)
      @ship.SetSailAngle(5, -9)

  ShipAdapter::GoForward = () -> log "ship goes forward"
  ShipAdapter


ship = new ShipAdapter
ship.GoForward()
log ship.TurnRight()

for i,v of ship
  log i, " :: ", v


# Bridge pattern   *****************************************  p.88  *******************************************


class OldGods
OldGods::prayTo = (sacrifice) ->
  log "we old gods hear your prayer"

class DrownedGods
DrownedGods::prayTo = (humanSacrifice) ->
  log "we drowned gods hear your prayer"

class OldGodsAdapter
  constructor: (oldGods) ->
    @oldGods = new OldGods
OldGodsAdapter::prayTo = ->
  sacrifice = new Sacrifice
  @oldGods.prayTo sacrifice

class DrownedGodsAdapter
  constructor: (drownedGods) ->
    @drownedGods = new DrownedGods
  drownedGodsProps: ->
    for i of @drownedGods
      log "drownedGodsProps are: #{i}"
DrownedGodsAdapter::prayTo = ->
  sacrifice = new HumanSacrifice
  @drownedGods.prayTo sacrifice

class Sacrifice
  log "we sacrifice"

class HumanSacrifice
  log "we sacrifice humans"


god2 = new DrownedGodsAdapter
god2.drownedGodsProps()

for i,v of god2
  log i, v
god2.prayTo()

god3 = new OldGodsAdapter
gods = [god2, god3]

# code uses the bridges to provide a consistent interface to the gods so that they can all be treated as equals.
# wywołuje prayTo tak samo dla każdego god, a sygnatura (input , output) jest w definicji, a nie jako argument.
# wrapping the individual gods and proxying method calls through to them.
for god in gods
  god.prayTo()


# Composite Pattern   *****************************************   *******************************************


class SimpleIngredient
  constructor: (@name, @calories, @ironContent, @vitaminContent) ->

SimpleIngredient::GetName = ->
  @name
SimpleIngredient::GetCalories = ->
  @calories
SimpleIngredient::GetIronContent = ->
  @ironContent
SimpleIngredient::GetVitaminContent = ->
  @vitaminContent

class CompoundIngredient
  constructor: (@name, ingredients) ->
    @ingredients = new Array

CompoundIngredient::AddIngredient = (ingredient) ->
  @ingredients.push ingredient
CompoundIngredient::GetName = ->
  @name
CompoundIngredient::GetCalories = ->
  total = 0
  for ingredient in @ingredients
    log "this ingredient is #{ingredient.GetName()}"
    # for k of ingredient
    #   log k
    total += ingredient.GetCalories()
  total
CompoundIngredient::GetIronContent = ->
  total = 0
  for i in @ingredients
    total += i.GetIronContent()
  total
CompoundIngredient::GetVitaminContent = ->
  total = 0
  for i in @ingredients
    total += i.GetVitaminContent()
  total
CompoundIngredient::getArr = ->
  log @ingredients

egg = new SimpleIngredient("Egg", 155, 6, 0)
milk = new SimpleIngredient("Milk", 42, 0, 0)
sugar = new SimpleIngredient("Sugar", 387, 0, 0)
rice = new SimpleIngredient("Rice", 370, 8, 0)

ricePudding = new CompoundIngredient 'Rice Pudding'
ricePudding.AddIngredient(egg)
ricePudding.AddIngredient(rice)
ricePudding.AddIngredient(milk)
ricePudding.AddIngredient(sugar)

ricePudding.getArr()

log "A serving of rice pudding contains: #{ricePudding.GetCalories()} calories"

# both the simple and compound version of the ingredients have the same interface (names of functions),
# the caller does not need to know that there is any difference between the two ingredient types
# czyli jak GetName is called on simpleI to zwraca co innego i jak jest called  on compoundI co innego

milkyRicePudding = new CompoundIngredient 'milky rice pudding'
milkyRicePudding.AddIngredient(milk)
milkyRicePudding.AddIngredient(ricePudding)

milkyRicePudding.getArr()

log "A serving of milky rice pudding contains: #{milkyRicePudding.GetCalories()} calories"


# Decorator Pattern   *****************************************   *******************************************
# str 145 PL

class Sales
  constructor: (price) ->
    @price = price or 100

Sales::getPrice = ->
  return @price

Sales.decorators = {}

Sales.decorators.fedTax =
  getPrice: ->
    price = @uber.getPrice()
    price += price * 5 / 100
    price

Sales.decorators.quebec =
  getPrice: ->
    price = @uber.getPrice()
    price += price * 7.5 / 100
    price

Sales.decorators.money =
  getPrice: ->
    return "USD #{@uber.getPrice().toFixed(2)}"

Sales.decorators.cad =
  getPrice: ->
    return "CAD " + @uber.getPrice().toFixed(2)

Sales::decorate = (decorator) ->
  F = ->
  overrides = @constructor.decorators[decorator]
  F.prototype = @
  newObj = new F
  newObj.uber = F.prototype
  # hasOwn = Object::hasOwnProperty
  for i of overrides
    if overrides.hasOwnProperty i
      newObj[i] = overrides[i]
  # for i of overrides
  #   if hasOwn.call(overrides, i)
  #     newObj[i] = overrides[i]
  # newObj


# # konstruktor tymczasowy
# class Parent
#   constructor: (name) ->
#     @name = name or 'Adam'

# Parent::say = -> log @name

# class Child extends Parent
#   constructor: () ->
#     super('super Adam')

# inherit_2 = (C, P) ->
#   F = ->
#   do (C, P) ->
#     F.prototype = P.prototype
#     C.prototype = new F()
#     C.uber = P.prototype
#     C.prototype.constructor = C
#     for i,v of C
#       log i, " :: ", v

# inherit_2(Child, Parent)

# implementacja:
sales = new Sales
log sales.decorate 'fedTax'
log sales.getPrice()

# v2

class Sale
  constructor: (price, decorators_list) ->
    @price = price or 100
    @decorators_list = []

Sale.decorators = {}

Sale.decorators.fedTax =
  getPrice: (price) ->
    price + price * 5 / 100

Sale.decorators.quebec =
  getPrice: (price) ->
    price + price * 7.5 / 100

Sale.decorators.money =
  getPrice: ->
    return "USD #{@uber.getPrice().toFixed(2)}"

Sale.decorators.cad =
  getPrice: ->
    return "CAD " + @uber.getPrice().toFixed(2)

Sale::decorate = (decorator) ->
  @decorators_list.push decorator

Sale::getPrice = ->
  price = @price
  for i in @decorators_list
    price = Sale.decorators[i].getPrice(price)
  price


s = new Sale 50
s.decorate 'fedTax'
log s.getPrice()


# The decorator pattern is a valuable pattern for scenarios where inheritance is too
# limiting. These scenarios still exist in JavaScript so the pattern remains useful.
# page 97

class BasicArmor

BasicArmor::CalculateDamageFromHit = (hit) -> hit.Strength * .2
BasicArmor::GetArmorIntegrity = -> 1

class ChainMail
  constructor: (@decoratedArmor) ->

ChainMail::CalculateDamageFromHit = (hit) ->
  hit.Strength = hit.Strength * .8
  @decoratedArmor.CalculateDamageFromHit(hit)
ChainMail::GetArmorIntegrity = -> .9 * @decoratedArmor.GetArmorIntegrity()

armor = new ChainMail(new BasicArmor())
for i,v of armor
  log i, " :: ", v
log armor.CalculateDamageFromHit({Location: "head", Weapon: "Sock filled with pennies", Strength: 12})


# Facade Pattern   *****************************************   *******************************************
# page 100


class Statek
Statek::TurnLeft = ->
Statek::TurnRight = ->
Statek::GoFwd = ->

Transportation = {}
Transportation.Statek = Statek

class Admiral

Transportation.Admiral = Admiral

class SupplyCoordinator

Transportation.SupplyCoordinator = SupplyCoordinator

# Facade:
class Fleet
Fleet::setDestination = (destination) ->
# pass commands to a series of ships, admirals and whoever else needs it
Fleet::resupply = ->
Fleet::attack = (destination) ->
# attack a city

# Fasada str 152
# ma za zadanie zapewnić alternatywny interfejs obiektu:
# istnieją pewne metody dodatkowe łączące w sobie wywołania kilku innych metod

# • stopPropagation() — zapobiega wykonywaniu obsługi zdarzenia w węzłach nadrzędnych;
# • preventDefault() — zapobiega wykonaniu przez przeglądarkę domyślnej akcji dla zdarzenia

# fasada która wykona je obie:
myEvent =
  stop: (e) ->
    e.stopPropagation()
    e.preventDefault()

# myevent = {
# stop: (e) ->
#   # inne przeglądarki:
#   if (typeof e.preventDefault === "function")
#     e.preventDefault()
#   if (typeof e.stopPropagation === "function")
#     e.stopPropagation()
#   # IE:
#   if (typeof e.returnValue === "boolean")
#     e.returnValue = false
#   if (typeof e.cancelBubble === "boolean")
#     e.cancelBubble = true


# Flyweight Pattern   *****************************************   *******************************************
# page 102

# którego celem jest zmniejszenie wykorzystania pamięci poprzez poprawę efektywności obsługi dużych obiektów
# zbudowanych z wielu mniejszych elementów poprzez współdzielenie wspólnych małych elementów.
# Pattern is used in instances when there is a large number of instances of objects which only vary slightly
# Flyweight offers a way to compress this data, by only keeping track of the values that differ from some prototype in each instance

class Soldier1
  constructor: (Health, FightAbility, Hunger) ->
    @Health = 10
    @FightAbility = 5
    @Hunger = 0

# JavaScript's prototype model is ideal for this scenario. We can simply assign the most common value
# to the prototype and have individual instances override them as needed.

class Soldier2
Soldier2::Health = 100
Soldier2::FightAbility = 50
Soldier2::Hunger = 10

soldier21 = new Soldier2
soldier22 = new Soldier2
log "soldier21 health is: #{soldier21.Health}"
soldier21.Health = 70
log "soldier21 health is: #{soldier21.Health}"
log "soldier22 health is: #{soldier22.Health}"
delete soldier21.Health
log "soldier21 health is: #{soldier21.Health}"


# Proxy Pattern   *****************************************   *******************************************
# provides a method of controlling the creation and use of expensive objects
# page 104

# lazy instantiation:
# proxy can check its internal instance, and if not yet initiated, create it before passing on the method call

class BarrelCalc
BarrelCalc::CalculateNumberNeeded = (vol) ->
  log vol
  Math.ceil(vol/357)

class DragonBarrelCalculator
DragonBarrelCalculator::CalculateNumberNeeded = (vol) ->
  @_barrelCalculator = new BarrelCalc if !@_barrelCalculator?
  #log @_barrelCalculator.CalculateNumberNeeded(714)
  @_barrelCalculator.CalculateNumberNeeded(vol * .77)

barrel = new DragonBarrelCalculator
log "barrels: #{barrel.CalculateNumberNeeded(4100)}"


# Pośrednik  str 153 PL   *******************

# Jeden obiekt stanowi interfejs dla innego obiektu
# Pośrednik znajduje się między użytkownikiem a obiektem i broni - staje się strażnikiem rzeczywistego obiektu,
# stara się, by ten wykonał jak najmniej pracy
# służy do poprawy wydajności

# # JQuery shit:
# $ = (id) -> document.getElementById(id)

# $('vids').onclick = (e) ->
#   e = e or window.event
#   src = e.target or e.srcElement
#   return if src.nodeName isnt "A"
#   e.preventDefault() if typeof e.preventDefault is "function"
#   e.returnValue = false;
#   id = src.href.split('--')[1];
#   src.parentNode.innerHTML = videos.getPlayer(id) if src.className is "play"
#   src.parentNode.id = "v" + id
#   videos.getInfo(id)

# $('toggle-all').onclick = (e) ->
#   hrefs = $('vids').getElementsByTagName('a')
#   for i in hrefs
#     continue if i.className is "play"
#     continue if !i.parentNode.firstChild.checked
#     id = i.href.split('--')[1]
#     i.parentNode.id = "v" + id
#     videos.getInfo(id)

# videos =
#   getPlayer: (id) ->
#   updateList: (data) ->
#   getInfo: (id) ->
#     info = $('info' + id)
#     http.makeRequest([id], "videos.updateList") if !info
#     if info.style.display is "none"
#       info.style.display = ''
#     else
#       info.style.display = 'none'

# http =
#   makeRequest: (ids, callback) ->
#     url = 'http://query.yahooapis.com/v1/public/yql?q='
#     sql = 'select * from music.video.id where ids IN ("%ID%")'
#     format = "format=json"
#     handler = "callback=" + callback
#     script = document.createElement('script')
#     sql = sql.replace('%ID%', ids.join('","'))
#     sql = encodeURIComponent(sql)
#     url += sql + '&' + format + '&' + handler
#     script.src = url
#     document.body.appendChild(script)

# Zaprezentowany wcześniej kod działa prawidłowo, ale można go zoptymalizować. Na scenę
# wkracza obiekt proxy, który przejmuje komunikację między http i videos.
# W istniejącym kodzie zachodzi tylko jedna zmiana: metoda videos.getInfo() wywołuje
# metodę proxy.makeRequest() zamiast metody http.makeRequest().
# proxy.makeRequest(id, videos.updateList, videos)
# Obiekt pośrednika korzysta z kolejki, w której gromadzi identyfikatory materiałów wideo przekazane w ostatnich 50 ms.
# Następnie przekazuje wszystkie identyfikatory, wywołując metodę obiektu http i przekazując własną funkcję
# wywołania zwrotnego, ponieważ videos.updateList() potrafi przetworzyć tylko pojedynczy rekord danych.

proxy =
  ids: []
  delay: 50
  timeout: null
  callback: null
  context: null
  makeRequest: (id, callback, context) ->
    # dodanie do kolejki
    @ids.push(id)
    @callback = callback
    @context = context
    # ustawienie funkcji czasowej
    if !@timeout
      @timeout = setTimeout(() ->
        proxy.flush()
      , @delay)
  flush: ->
    http.makeRequest(@ids, "proxy.handler")
    # wyczyszczenie kolejki i funkcji czasowej
    @timeout = null
    @ids = []
  handler: (data) ->
    # pojedynczy materiał wideo
    if parseInt(data.query.count, 10) is 1
      proxy.callback.call(proxy.context, data.query.results.Video)
    # kilka materiałów wideo
    for i in data.query.results.Video
      proxy.callback.call(proxy.context, i)


# Chain of Responsibility Pattern   ***********************   *******************************************

JudicialSystem = {}

class Complaint
  constructor: (complaintParty, complaintAbout, complaint) ->
    @complaintParty = ""
    @complaintAbout = ""
    @complaint = ""

class ClerkOfTheCourt
ClerkOfTheCourt::IsAbleToResolveComplaint = (complanit) ->
  false
ClerkOfTheCourt::ListenToComplaint = (complaint) ->
  log 'this fucker is not able to resolve this complaint'

JudicialSystem.ClerkOfTheCourt = ClerkOfTheCourt

class King
King::IsAbleToResolveComplaint = (complaint) ->
  true
King::ListenToComplaint = (complaint) ->
  log 'tak jest able to resolve the complaint'

JudicialSystem.King = King

class ComplaintResolver
  constructor: (complaintListeners) ->
    @complaintListeners = new Array
    @complaintListeners.push new ClerkOfTheCourt
    @complaintListeners.push new King
ComplaintResolver::ResolveComplaint = (complaint) ->
  for i in @complaintListeners
    log i, i.IsAbleToResolveComplaint
    i.ListenToComplaint(complaint) if i.IsAbleToResolveComplaint(complaint)

cr = new ComplaintResolver
cr.ResolveComplaint('tak')
log 'this is fucking Judicial System: '
log JudicialSystem


# Command Pattern   *****************************************   *******************************************

# a method of encapsulating both the parameters to a method and the current object state, and method to be called.
# Packs up everything needed to call a method at a later date into a nice little package.
# single point of command execution also allows us to easily add functionality such as undo


class LordInstructions
  constructor: (@location, @numberOfTroops, @kiedy) ->
LordInstructions::BringTroops = (location, numberOfTroops, kiedy) ->
    log "You have been instructed to bring #{numberOfTroops} troops to #{location} by #{kiedy}"

class BringTroopsCommand
  constructor: (@location, @numberOfTroops, @kiedy) ->
BringTroopsCommand::Execute = ->
  receiver = new LordInstructions
  receiver.BringTroops(@_location, @_numberOfTroops, @_kiedy)

simpleCommand = new Array()
simpleCommand.push(new LordInstructions().BringTroops)
simpleCommand.push("King's Landing")
simpleCommand.push(500)
simpleCommand.push(new Date())

log simpleCommand[0](simpleCommand[1], simpleCommand[2], simpleCommand[3])

# the invoker   ***********************************
# part of the command pattern that instructs the command to execute its instructions - triggers invocation

process.nextTick( () ->
  BTC = new BringTroopsCommand
  BTC.Execute())

# The process.nextTick function defers the execution of a command to the end of
# the event loop such that it is executed next time the process has nothing to do.

# the receiver   **********************************
# This is the target of the command execution.
# The receiver knows how to perform the action that the command has deferred.
# There need not be anything special about the receiver; in fact it may be any class.

class LordInstructionsCopy
  constructor: (@location, @numberOfTroops, @kiedy) ->
LordInstructionsCopy::BringTroops = (location, numberOfTroops, kiedy) ->
    log "You have been instructed to bring #{numberOfTroops} troops to #{location} by #{kiedy}"


# Together these components make up the command pattern. A client will generate a
# command and pass it off to an invoker that may delay the command or execute it at
# once and the command will act upon a receiver.

# # building undo stack:
# In the case of building an undo stack, the commands are special, in that they have
# both an Execute and an Undo method. One takes the application state forward and
# the other backward. To perform an undo, simply pop the command off the undo
# stack, execute the Undo function, and push it onto a redo stack. For redo, pop from
# redo, run Execute, and push to the undo stack. Simple as that, although one must
# make sure all state mutations are performed through commands.




# Interpreter Pattern   *****************************************   *******************************************


class Battle
  constructor: (@battleGround, @agressor, @defender, @victor) ->

class Parser
  constructor: (@battleText, currentIndex, battleList) ->
    @currentIndex = 0
    @battleList = battleText.split("\n")
Parser::nextBattle = ->
  return null if !@battleList[0]
  segments = @battleList[0].match(/\((.+?)\s?->\s?(.+?)\s?<-\s?(.+?)\s?->\s?(.+)/)
  new Battle(segments[2], segments[1], segments[3], segments[4])


battleText = "(Robert Baratheon -> River Trident <- RhaegarTargaryen) -> Robert Baratheon"
p = new Parser(battleText)
log p.nextBattle()

# This data structure can now be queried like one would for any other structure in JavaScript



# Interator Pattern   *****************************************   *******************************************


class KingSuccession
  constructor: (@inlineForThrone, pointer) ->
    @pointer = 0
KingSuccession::next = ->
  @inlineForThrone[@pointer++]

king = new KingSuccession(["Robert Baratheon" , "JofferyBaratheon", "TommenBaratheon"]);
log king
log king.next()
log king.next()

class FiboIterator
  constructor: (previous, beforePrevious) ->
    @previous = 1
    @beforePrevious = 1
FiboIterator::next = ->
  current = @previous + @beforePrevious
  log "***"
  log "current is: #{current} cos beforePrevious_1 is: #{@beforePrevious} and previous_1 is: #{@previous}"
  @beforePrevious = @previous
  log "beforePrevious_2 is: #{@beforePrevious} cos previous_1 is: #{@previous}"
  @previous = current
  log "previous_2 is: #{@previous} cos current is: #{current}"
  current

fib = new FiboIterator
log fib
fib.next()
fib.next()
fib.next()
fib.next()


Agg = ->
  index = 0
  data = [1, 2, 3, 4]
  length = data.length
  return
    next: ->
      null if !@hasNext()
      element = data[index]
      index = index + 1
      element
    hasNext: -> index < length
    rewind: -> index = 0
    current: -> log "current element is: #{data[index]}"


ag = new Agg
log "Agg next: #{ag.next()}" while ag.hasNext()
ag.rewind()
ag.current()


# Mediator Pattern   *****************************************   *******************************************

# str 160 PL

# ma za zadanie promować luźne powiązania obiektów i wspomóc przyszłą konserwację kodu.
# niezależne obiekty (koledzy) nie komunikują się ze sobą bezpośrednio, ale korzystają z obiektu mediatora.
# Gdy jeden z kolegów zmieni stan, informuje o tym mediator, a ten przekazuje tę informację wszystkim innym zainteresowanym kolegom.

# Mediator wie o wszystkich obiektach. Komunikuje się z urządzeniem wejściowym (klawiaturą),
# obsługuje naciśnięcia klawiszy, określa, który gracz jest aktywny, i informuje o zmianach
# wyników. Gracz jedynie gra (czyli aktualizuje swój własny wynik) i informuje
# mediator o tym zdarzeniu. Mediator informuje tablicę o zmianie wyniku, a ta aktualizuje
# wyświetlaną wartość. Poza mediatorem żaden inny obiekt nie wie nic o pozostałych.

# # GRA:

readline = require('readline')
readline.emitKeypressEvents(process.stdin)
process.stdin.setRawMode(true)

# Obiekty graczy są tworzone przy użyciu konstruktora Player() i zawierają własne właściwości
# points i name. Metoda play() z prototypu zwiększa liczbę punktów o jeden i informuje
# o tym fakcie mediator.

class Player
  constructor: (@name, points) ->
    @points = 0
Player::play = ->
  @points += 1
  mediator.played()

# Obiekt scoreboard zawiera metodę update() wywoływaną przez mediator po zdobyciu
# punktu przez jednego z graczy. Tablica nie wie nic o graczach i nie przechowuje wyniku —
# po prostu wyświetla informacje przekazane przez mediator.

scoreboard =
  update: (score) ->
    for own i,v of score
      log i,": ", v

# Obiekt mediatora odpowiada za inicjalizację gry oraz utworzenie obiektów graczy
# w metodzie setup() i śledzenie ich poczynań dzięki umieszczeniu ich we właściwości players.
# Metoda played() zostaje wywołana przez każdego z graczy po wykonaniu akcji. Aktualizuje ona
# wynik (score) i przesyła go do tablicy (scoreboard). Ostatnia metoda, keypress(), obsługuje
# zdarzenia klawiatury, określa, który gracz jest aktywny, i powiadamia go o wykonanej akcji.

mediator =
  players: {}
  setup: ->
    players = @players
    players.home = new Player('Gospodarze')
    players.guest = new Player('Goście')
  # ktoś zagrał, uaktualnij wynik
  played: ->
    players = @players
    score =
      "Gospodarze": players.home.points
      "Goście": players.guest.points
    scoreboard.update(score)
  # obsługa interakcji z użytkownikiem
  keypress: (key) ->
    if key is '1'
      mediator.players.home.play()
    if key is '0'
      mediator.players.guest.play()

# # start!
# mediator.setup()
# process.stdin.on 'keypress', (key) ->  mediator.keypress(key)
# # gra kończy się po 5 sekundach
# after 2500, () ->
#   log "koniec gry: Goście #{mediator.players.guest.points} :: Gospodarze #{mediator.players.home.points}"
#   process.exit()


# page 122

# many-to-many relationships
# mediators are best used when the communication is both complex and well defined
# if the communication is not complex, then the mediator adds extra complexity.
# if the communication is ill defined, then it becomes difficult to codify the communication rules in a single place.

class Karstark
  constructor: (@greatLord) ->
Karstark::receiveMessage = (message) ->
Karstark::sendMessage = (message) ->
  @greatLord.routeMessage(message)

class Bolton
  constructor: (@greatLord) ->
Bolton::receiveMessage = (message) ->
Bolton::sendMessage = (message) ->
  @greatLord.routeMessage(message)

# mediator
class HouseStark
  constructor: (karstark, bolton, frey, umber) ->
    @karstark = new Karstark(@)
    @bolton = new Bolton(@)
HouseStark::receiveMessage = (message) ->


# Memento Pattern   *****************************************   *******************************************

# This world state is used to track all the conditions that make up the world and encompasses the whole state for the application, it can be used as a memento.
class WorldState
  constructor: (@numberOfKings, @currentKingInKingsLanding, @season) ->

# provides the same state as the memento and allows for the creation and restoration of mementos
class WorldStateProvider
WorldStateProvider::saveMemento = ->
  return new WorldState(@numberOfKings, @currentKingInKingsLanding, @season)
WorldStateProvider::restoreMemento = (memento) ->
  @numberOfKings = memento.numberOfKings
  @currentKingInKingsLanding = memento.currentKingInKingsLanding
  @season = memento.season

class Soothsayer
  constructor: (startingPoints, currentState) ->
    @startingPoints = []
    @currentState = new WorldStateProvider
Soothsayer::setInitialConditions = (numberOfKings, currentKingInKingsLanding, season) ->
  @currentState.numberOfKings = numberOfKings
  @currentState.currentKingInKingsLanding = currentKingInKingsLanding
  @currentState.season = season
Soothsayer::alterNumberOfKingsAndForetell = (numberOfKings) ->
  @startingPoints.push(@currentState.saveMemento())
  @currentState.numberOfKings = numberOfKings
Soothsayer::alterSeasonAndForetell = (season) -> log 4
Soothsayer::alterCurrentKingInKingsLandingAndForetell = (currentKingInKingsLanding) -> log 'T'
Soothsayer::tryADifferentChange = -> @currentState.restoreMemento(@startingPoints.pop())


# Observer Pattern   *****************************************   *******************************************


class GetterSetter
GetterSetter::getProperty = ->
  @_property
# setter function augmented with a call to some other object that is interested in knowing that a value has changed
GetterSetter::setProperty = (value) ->
  temp = @_property
  @_property = value
  @_listener.Event(value, temp)


class Spy
  constructor: (_partiesToNotify) ->
    @_partiesToNotify = []
Spy::subscribe = (subscriber) ->
  @_partiesToNotify.push(subscriber)
  log "parites to Notify: #{@_partiesToNotify}"
Spy::unSubscribe = (subscriber) ->
  @_partiesToNotify.remove(subscriber)
Spy::SetPainKillers = (painKillers) ->
  @_painKillers = painKillers
  for party in @_partiesToNotify
    party(painKillers)

class Playa
Playa::onKingsMedsAmountChange = (painKillerAmount) -> log "new Amount of pain Killers is: #{painKillerAmount}"

sp = new Spy
pl = new Playa
# observer pattern can also be applied to methods as well as properties
sp.subscribe(pl.onKingsMedsAmountChange)
sp.SetPainKillers(12)


# Observer in jQuery library:
# Subscribe to all the click events on buttons on a page with the following line:
#   $("body").on("click", "button", function(){/*do something*/})
# Even in Vanilla JavaScript, the same pattern applies:
#   buttons = document.getElementsByTagName("button")
#   for btn in buttons
#     btn.onclick = -> log 'button clicked'


# strona 163 PL

# celem używania wzorca jest promowanie luźnego powiązania elementów.
# Zamiast sytuacji, w której jeden obiekt wywołuje metodę drugiego, mamy sytuację, w której drugi
# z obiektów zgłasza chęć otrzymywania powiadomień o zmianie w pierwszym obiekcie
# Subskrybenta nazywa się często obserwatorem, a obiekt obserwowany obiektem publikującym lub źródłem
# Obiekt publikujący wywołuje subskrybentów po zajściu istotnego zdarzenia i przekazuje informację w postaci np. obiektu zdarzenia

# paper publikuje gazetę codzienną i miesięcznik
# subscribers tablica przechowującą wszystkich subskrybentów
# Gdy zajdzie istotne zdarzenie, obiekt paper przejdzie w pętli przez wszystkich subskrybentów, by ich o nim powiadomić.
# Notyfikacja polega na wywołaniu metody obiektu subskrybenta = w momencie zgłoszenia chęci otrzymywania powiadomień
# subskrybent musi przekazać obiektowi paper jedną ze swoich metod w wywołaniu metody subscribe()
# paper może dodatkowo umożliwić anulowanie subskrypcji, czyli usunięcie wpisu z tablicy subskrybentów
# istotną metodą obiektu paper jest publish(), która wywołuje metody subskrybentów.

# • subscribers — tablica
# • subscribe() — dodaje wpis do tablicy
# • unsubscribe() — usuwa wpis z tablicy
# • publish() — przechodzi w pętli przez subskrybentów i wywołuje przekazane przez nich metody.
# Wszystkie trzy metody potrzebują parametru type, ponieważ wydawca może zgłosić kilka różnych zdarzeń
# (publikację gazety lub magazynu), a subskrybenci mogą zdecydować się na otrzymywanie powiadomień tylko o jednym z nich.

publisher =
  subscribers:
    any: []
  subscribe: (fn, type) ->
    type = type or 'any'
    if typeof @subscribers[type] is 'undefined'
      @subscribers[type] = []
    @subscribers[type].push(fn)
  unsubscribe: (fn, type) ->
    @visitSubscribers('unsubscribe', fn, type)
  publish: (publication, type) ->
    @visitSubscribers('publish', publication, type)
  visitSubscribers: (action, arg, type) ->
    pubtype = type or 'any'
    subs = @subscribers[pubtype]
    if subs
      for sub in subs
        if action is 'publish'
          sub(arg)
        else
          if sub is arg
            subs.splice(sub, 1)

# funkcja która przyjmuje obiekt i zamienia go w obiekt publikujący przez skopiowanie wszystkich ogólnych metod dotyczących publikacji
makePublisher = (o) ->
  o.subscribers = any: []
  for i of publisher
    if typeof publisher[i] is 'function'
      o[i] = publisher[i]

# paper, który będzie publikował gazetę i magazyn
paper =
  daily: ->
    # log @publish
    @publish("ciekawy news")
  monthly: ->
    @publish("interesującą analizę", "magazyn")

# robimy z obiektu wydawcę
makePublisher(paper)

# subskrybent o nazwie joe
joe =
  drinkCoffee: (paper) ->
    log "Właśnie przeczytałem #{daily()}"
  sundayPreNap: (monthly) ->
    log "Chyba zasnę, czytając #{monthly()}"

#joe zgłasza się jako subskrybent do paper
publisher.subscribe(joe.drinkCoffee)
publisher.subscribe(joe.sundayPreNap, 'magazyn')
log publisher.subscribers


paper.daily()
paper.monthly()

# SHIT ABOVE DOES NOT WORK - makePublisher - this subscribers is not the same


class PlayerObserver
  constructor: (@name, @key, points, fire) ->
    @points = 0
    @fire('newplayer', @)
PlayerObserver::play = ->
  @points += 1
  @fire('play', @)

scoreboardObserver =
  update: (score) ->
    for own i,v of score
      log i,": ", v

publisherObserver =
    subscribers: any: []
    on: (type, fn, context) ->
      type = type or 'any'
      fn = if typeof fn is 'function' then fn else context[fn]
      @subscribers[type] = [] if typeof @subscribers[type] is 'undefined'
      @subscribers[type].push({fn: fn, context: context || @})
    remove: (type, fn, context) ->
      @visitSubscribers('unsubscribe', type, fn, context)
    fire: (type, publication) ->
      @visitSubscribers('publish', type, publication)
    visitSubscribers: (action, type, arg, context) ->
      pubtype = type or 'any'
      subs = @subscribers[pubtype]
      for sub of subs
        if action is 'publish'
          sub.fn.call(sub.context, arg)
        else
          if sub.fn is arg and sub.context is context
            subs.splice(sub, 1)

gameObserver =
  keys: {}
  addPlayer: (player) ->
    key = player.key.toString().charCodeAt(0)
    @keys[key] = player
  handleKeypress: (key) ->
    if game.keys[key]
      game.keys.play()
    if key is '0'
      mediator.players.guest.play()
  handlePlay: (player) ->
    players: @keys
    score: {}
    for i of players
      if players.hasOwnProperty(i)
        score[players[i].name] = players[i].startingPoints
    @fire('scorechange', score)

# # dynamiczne tworzenie tylu obiektów graczy (po naciśnięciu klawiszy), ile zostanie zażądanych przez grających
# while 1
#   playerName = prompt('podaj imię gracza')
#   break if !playerName
#   while 1
#     key = prompt("Klawisz dla gracza #{playerName} ?")
#     break if key
#   new Player(playername, key)


# State Pattern   *****************************************   *******************************************
# page 131

# Keeping track of the state is a typical problem in most applications. When the transitions between states is complex,
# then wrapping it up in a state pattern is one method of simplifying things. It is also possible to build up a simple
# workflow by registering events as sequential.


class BankAccountManager
  constructor: (currentState) ->
    @currentState = new GoodStandingState(@)
BankAccountManager::Deposit = (amount) ->
  @currentState.Deposit(amount)
BankAccountManager::Withdraw = (amount) ->
  @currentState.Withdraw(amount)
BankAccountManager::addToBalance = (amount) ->
  @balance += amount
BankAccountManager::getBalance = ->
  @balance
BankAccountManager::moveToState = (newState) ->
  @currentState = new State

class GoodStandingState
  constructor: (@manager) ->
GoodStandingState::Deposit = (amount) ->
  @manager.addToBalance(amount)
GoodStandingState::Withdraw = (amount) ->
  @manager.moveToState(new OverdrawnState(@manager)) if @manager.getBalance < amount
  @manager.addToBalance(-1 * amount)

class OverdrawnState
  constructor: (@manager) ->
OverdrawnState::Deposit = (amount) ->
  @manager.addToBalance(amount)
  @manager.moveToState(new GoodStandingState(@manager)) if @manager.getBalance() > 0
OverdrawnState::Withdraw = (amount) ->
  @manager.moveToState(new OnHold(@manager))
  throw "Cannot withdraw money from an already overdrawn bank account"

class OnHold
  constructor: (@manager) ->
OnHold::Deposit = (amount) ->
  @manager.addToBalance(amount)
  throw "Your account is on hold and you must go to the bank to resolve the issue"
OnHold::Withdraw = (amount) ->
  throw "Your account is on hold and you must go to the bank to resolve the issue"


# Strategy Pattern   *****************************************   *******************************************
# page 135

# strategy pattern, the method signature for each strategy should be the same

class TravelResult
  constructor: (@durationDays, @probabilityOfDeath, @cost) ->
  log @durationDays, @probabilityOfDeath, @cost

class SeaGoingVessel
SeaGoingVessel::travel = (source, destination) ->
  new TravelResult(15, .25, 500)

class Horse
Horse::travel = (source, destination) ->
  new TravelResult(30, .25, 50)

class Walk
Walk::travel = (source, destination) ->
  new TravelResult(150, .55, 0)

class GetCurrentBalance
  constructor: (@bal) ->
GetCurrentBalance::getBal = -> @bal


currentMoney = new GetCurrentBalance(501)
log currentMoney.bal
if currentMoney.bal > 500
  strat = new SeaGoingVessel
else if currentMoney.bal > 50
  strat = new Horse
else
  strat = new Walk

travelResult = strat.travel()
log travelResult


# Template Pattern   *****************************************   *******************************************
# page 138


class BasicBeer
  constructor: (@name) ->
  whatsTheName: -> log @name
BasicBeer::create = ->
  @addIngredients()
  @stir()
  @ferment()
  @test()
  if @testingPassed()
    @distribute()
BasicBeer::addIngredients = ->
  throw "Add ingredients needs to be implemented"
BasicBeer::stir = -> log 'stiring'
BasicBeer::ferment = -> log 'let stand for 30 days'
BasicBeer::test = -> log 'drink a cup to taste it'
BasicBeer::testingPassed = ->
  throw "Conditions to pass a test must be implemented"
BasicBeer::distribute = -> log 'place beer in 50l casks'


class RaspberryBeer extends BasicBeer
RaspberryBeer::addIngredients = -> log 'RaspberryBeer ingredients'
RaspberryBeer::testingPassed = -> log 'RaspberryBeer passed the test'

ras = new RaspberryBeer
ras.addIngredients()
ras.test()
ras.whatsTheName()
bb = new BasicBeer('basicBeer')
bb.whatsTheName()


# Template Pattern   *****************************************   *******************************************
# page 142


class Knight
  @_type = 'Knight'
Knight::printName = ->
  log 'Knight'
Knight::visit = (visitor) ->
  log "this is #{@} and #{Knight._type}"
  visitor.visit(@)

class Archer
  @_type = 'Archer'
Archer::printName = ->
  log 'Archer'
Archer::visit = (visitor) ->
  visitor.visit(@)

collection = []
collection.push(new Knight)
collection.push(new Archer)

for i in collection
  if typeof i is 'Knight'
    i.printName()
    log 'Knight of typeof'
  else if i._type is 'Knight'
    i.printName()
    log 'Knight of _type'
  else if i instanceof Knight
    i.printName()
    log 'Knight of an instanceof'
  else
    log 'not a Knight'

class SelectiveNamePrinterVisitor
SelectiveNamePrinterVisitor::visit = (memberOfArmy) ->
  log memberOfArmy
  if memberOfArmy._type is 'Knight'
    @visitKnight(memberOfArmy)
  else if memberOfArmy instanceof Knight
    log 'visitor knight from the instanceof'
    @visitKnight(memberOfArmy)
  else
    log 'Not a Knight'
SelectiveNamePrinterVisitor::visitKnight = (memberOfArmy) ->
  memberOfArmy.printName()

visitor = new SelectiveNamePrinterVisitor
for i in collection
  i.visit(visitor)



# DOM i wzorce dotyczące przeglądarek ...171............................................................................

# Skrypty wykorzystujące DOM ............172
# Dostęp do DOM .........................173
# Modyfikacja DOM .......................174
# Zdarzenia .............................175
# Obsługa zdarzeń .......................175
# Delegacja zdarzeń .....................177
# Długo działające skrypty ..............178
# Funkcja setTimeout() ..................178
# Skrypty obliczeniowe ..................179
# Komunikacja z serwerem ................179
# Obiekt XMLHttpRequest .................180
# JSONP .................................181
# Ramki i wywołania jako obrazy .........184
# Serwowanie kodu JavaScript klientom ...184
# Łączenie skryptów .....................184
# Minifikacja i kompresja ...............185
# Nagłówek Expires ......................185
# Wykorzystanie CDN .....................186
# Strategie wczytywania skryptów ........186
# Lokalizacja elementu <script> .........187
# Wysyłanie pliku HTML fragmentami ......188
# Dynamiczne elementy <script>
# zapewniające nieblokujące pobieranie ..189
# Wczytywanie leniwe ....................190
# Wczytywanie na żądanie ................191
# Wstępne wczytywanie kodu JavaScript ...192


# STR 182 zrobić sobie lepsze XO - tuning + smartPlay + beauty => na stronke


#   *****************************************                          *******************************************
#   **************************************     FUNCTIONAL PROGRAMMING     ****************************************
#   *****************************************                          *******************************************


class HamiltonianTourOptions
  onTourStart: -> log 'start tour'
  onEntryToAttraction: (cityname) -> log "I'm delighted to be in #{cityname}"
  onExitFromAttraction: -> log 'exit attraction'
  onTourCompletion: -> log 'finish tour'

class HamiltonianTour
  constructor: (@options) ->

HamiltonianTour::StartTour = ->
  if @options.onTourStart and typeof @options.onTourStart is "function"
    @options.onTourStart()
    @VisitAttraction("King's Landing")
    @VisitAttraction("Winterfell")
    @VisitAttraction("Mountains of Dorne")
    @VisitAttraction("Eyrie")
  if @options.onTourCompletion and typeof @options.onTourCompletion is "function"
    @options.onTourCompletion()

HamiltonianTour::VisitAttraction = (AttractionName) ->
  if @options.onEntryToAttraction and typeof @options.onEntryToAttraction is "function"
    @options.onEntryToAttraction(AttractionName)
  if @options.onExitFromAttraction and typeof @options.onExitFromAttraction is "function"
    @options.onExitFromAttraction(AttractionName)

tour = new HamiltonianTour(new HamiltonianTourOptions)
tour.StartTour()


# adding a simple filtering method to the array object

# custom map
Array::where = (inclusionTest) ->
  results = []
  i = 0
  while i < @length
    if inclusionTest(@[i])
      results.push @[i]
    i++
  results

itemz = [1,2,3,4,5,6,7,8,9,10]
log itemz.where((thing) -> thing % 2 is 0).where((thing) -> thing % 3 is 0)

# method of returning a modified version of the original object without changing the original is known as a fluent interface

# custom filter
Array::select = (projection) ->
  results = []
  i = 0
  while i < @length
    results.push projection(@[i])
    i++
  results

children = [
  { id: 1, Name: "Rob" }
  { id: 2, Name: "Sansa" }
  { id: 3, Name: "Arya" }
  { id: 4, Name: "Brandon" }
  { id: 5, Name: "Rickon" }]

children.where((x) -> x.id % 2 is 0).select((x) -> log x.Name)

# Accumulators page 158 - jakiś kurwa bezsens [ale chodzi o reduce]

peasants = [
  {name: "Jory Cassel", taxesOwed: 11, bankBalance: 50}
  {name: "Vardis Egen", taxesOwed: 5, bankBalance: 20}]

projectionFunc = (item) ->
  Math.min(item.taxesOwed, item.bankBalance)

class TaxCollector
TaxCollector::collect = (items, value, projection) ->
  if items.length > 1
    projection(items[0]) + @collect(items.slice(1), value, projection)
  projection(items[0])

taxCal = new TaxCollector
log taxCal.collect(peasants, 2, projectionFunc)

# Memoization page 160
# memoization is a specific term to retain a number of previously calculated values from a function

class Fibonacci
  constructor: (memoizedValues) ->
    @memoizedValues = []

Fibonacci::naiveFibo = (n) -> # n = index liczby w ciągu fibonacciego np. 8th liczba w ciągu to 21
  return 0 if n is 0
  return 1 if n <= 2
  return @naiveFibo(n-1) + @naiveFibo(n-2)

Fibonacci::memoizedFibo = (n) ->
  return 0 if n is 0
  return 1 if n <= 2
  if not @memoizedValues[n]
    @memoizedValues[n] = @memoizedFibo(n - 1) + @memoizedFibo(n - 2)
    log @memoizedValues
  @memoizedValues[n]

fib = new Fibonacci
log fib.naiveFibo(6)
log fib.memoizedFibo(6)

# Lazy Loading

class Bread
  constructor: (@breadType) ->
    log "Bread #{@breadType} created"

class Bakery
  constructor: (requiredBreads) ->
    @requiredBreads = []
Bakery::orderBreadType = (breadType) ->
  @requiredBreads.push(breadType)
Bakery::pickupBread = (breadType) ->
  log "Pickup of bread #{breadType} requested"
  @createBreads() if not @breads
  for i in @breads
    if i.breadType is breadType
      return i
Bakery::createBreads = ->
  @breads = []
  for i in @requiredBreads
    @breads.push new Bread i


bakery = new Bakery
bakery.orderBreadType("Brioche")
bakery.orderBreadType("Anadama bread")
bakery.orderBreadType("Chapati")
bakery.orderBreadType("Focaccia")

log "required Breads are #{bakery.requiredBreads}"
log bakery.pickupBread("Brioche").breadType + " pickedup"

# ****************************   PROMISE   *******************************************************

amIHappy = true

willGetReward = new Promise (resolve, reject) ->
  if amIHappy
    phone =
      make: 'iPhone'
      model: 'X'
    log "I'll buy you #{phone.make} #{phone.model}"
    resolve phone
  else
    reason = new Error 'I am not too happy'
    reject reason

# consuming promise

askMe_1 = ->
  willGetReward
    .then (fulfilled) -> log fulfilled
    .catch (err) -> log err.message

askMe_1()

showOff_1 = (phone) ->
  new Promise (resolve, reject) ->
    message = "Hey friend I have a new #{phone.make} #{phone.model}"
    resolve message

# We didn't call the reject. It's optional. We can shorten this sample like using Promise.resolve instead.

showOff_2 = (phone) ->
  message = "Hey friend I have a new #{phone.make} #{phone.model}"
  Promise.resolve(message)

askMe_2 = ->
  try
    log 'before asking 1'
    await phone = willGetReward
    await message = showOff_2(phone)
    log message
    log 'after asking 1'
  catch err
    log err.message
    log 'after asking 2'

do => await askMe_2()


# ****************************   CLOSURE   *******************************************************


showHelp = (help) ->
  log help

makeHelpCallback = (help) ->
  return () -> showHelp(help)

setupHelp = ->
  helpText = [
      {'id': 'email', 'help': 'Your e-mail address'},
      {'id': 'name', 'help': 'Your full name'},
      {'id': 'age', 'help': 'Your age (you must be over 16)'}
    ]
  for i in helpText
    item = i
    log "#{item.id} is #{makeHelpCallback(item.help)}"

setupHelp()


# ****************************   DEPENDENCY INJECTION   ********************************************
# medium Maciek Przybylski - dependency injection in javascript

injector =
  dependencies: {}
  register: (key, value) ->
    @dependencies[key] = value
  resolve: (deps, func, scope) ->
    args = []
    for i in deps
      if @dependencies[i]
        args.push @dependencies[i]
      else
        throw new Error "Can't resolve #{i}"
    () ->
      func.apply scope or {}, args.concat(Array::slice.call(arguments, 0))

# # unit test:

# doSth = injector.resolve ['service', 'router'],
#   (service, router, other) ->
#     expect(service().name).to.be('Service')
#     expect(router().name).to.be('Router')
#     expect(other).to.be('Other')
# doSth('Other')



# MVC, MVP, MVVM - model view controller - 169, presenter - 178, viewModel - 183


# Object.observe

# modelU = {}
# Object.observe modelU, (changes) ->
#   changes.forEach (change) ->
#     log "a #{change.type} occured on #{change.name}"
#   if change.type is "update"
#     log "the old value was #{change.oldValue}"


# modelU.item = 7
# modelU.item = 8
# delete modelU.item

# jQuery extension:

# do ($=jQuery) ->
#   $.fn.yeller = ->
#     @each (_, item) ->
#       $(item).val($(item).val().toUpperCase())
#       @


#   **********************************   Messaging   *************************************

# 1. Commands
# 2. Events
# 3. Request-reply (RabbitMQ)

class CowMailBus
  constructor: (@requestor) ->
    @responder = new CowMailResponder(@)
# process.nextTick, which simply defers a function to the next time through the event loop
CowMailBus::send = (message) ->
  that = @
  if message._from is 'requestor'
    process.nextTick = ->
      that.responder.process.message(message)
  else
    process.nextTick = ->
      that.requestor.process.message(message)

class CowMailRequestor
CowMailRequestor::request = ->
  message =
    _date: new Date()
    _from: 'requestor'
    _correlationID: new Guid()
    body: "invade moat Collin"
  bus = new CowMailBus
  bus.send(message)
CowMailRequestor::processMessage = (message) ->
  dir message

class CowMailResponder
  constructor: (bus) ->
CowMailResponder::processmessage = (message) ->
  response =
    _date: new Date()
    _from: 'responder'
    _correlationID: message._correlationID
    body: "ok, invaded"
  @bus.send(response)


# 4. Publish-subscribe








































