{ Expression } = require './expression'
{ build } = require './builder'

module.exports.ParameterDef = class ParameterDef extends Expression
  constructor: (json) ->
    super
    @name = json.name
    @default = build(json.default)
    @parameterTypeSpecifier = json.parameterTypeSpecifier

  exec: (ctx) ->
    if (ctx?.parameters[@name]?) then ctx.parameters[@name]
    else @default?.execute(ctx)

module.exports.ParameterRef = class ParameterRef extends Expression
  constructor: (json) ->
    super
    @name = json.name
    @library = json.libraryName

  exec: (ctx) ->
    ctx = if @library then ctx.getLibraryContext(@library) else ctx
    ctx.getParameter(@name)?.execute(ctx)