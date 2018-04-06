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
      # {name: 'Error', message: "#{constr} nie istnieje"}
      log "Error #{constr} nie istnieje"
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


























