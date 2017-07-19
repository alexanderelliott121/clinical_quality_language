should = require 'should'
setup = require '../../setup'
data = require './data'
{Repository} = require '../../../lib/cql'

{ p1, p2 } = require './patients'

describe 'In Age Demographic', ->
  @beforeEach ->
    setup @, data, [ p1, p2 ]
    @results = @executor.withLibrary(@lib).exec_patient_context(@patientSource)

  it 'should have correct patient results', ->
    @results.patientResults['1'].InDemographic.should.equal false
    @results.patientResults['2'].InDemographic.should.equal true

  it 'should have empty population results', ->
    @results.populationResults.should.be.empty

describe 'Using CommonLib', ->
  @beforeEach ->
    setup @, data, [ p1, p2 ], {}, {}, new Repository(data)

  it "should have using models defined", ->
    @lib.usings.should.not.be.empty
    @lib.usings.length.should.equal 1
    @lib.usings[0].name.should.equal "QUICK"

  it 'Should have included a library', ->
    @lib.includes.should.not.be.empty

  it "should be able to execute expression from included library", ->
    @results = @executor.withLibrary(@lib).exec_patient_context(@patientSource)
    @results.patientResults['1'].ID.should.equal false
    @results.patientResults['2'].ID.should.equal true
    @results.patientResults['2'].FuncTest.should.equal 7
    @results.patientResults['1'].FuncTest.should.equal 7

describe 'Using CommonLib2', ->
  @beforeEach ->
    setup @, data, [], {}, {}, new Repository(data)

  it "should execute expression from included library that uses parameter", ->
    @exprUsesParam.exec(@ctx).should.equal 17

  it "should execute expression from included library that uses sent-in parameter", ->
    @exprUsesParam.exec(@ctx.withParameters({SomeNumber: 42})).should.equal 42

  it "should execute parameter from included library", ->
    @exprUsesParamDirectly.exec(@ctx).should.equal 17

  it "should execute sent-in parameter from included library", ->
    @exprUsesParamDirectly.exec(@ctx.withParameters({SomeNumber: 73})).should.equal 73

  it "should execute function from included library that uses parameter", ->
    @funcUsesParam.exec(@ctx).should.equal 22

  it "should execute expression from included library that calls function", ->
    @exprCallsFunc.exec(@ctx).should.equal 6

  it "should execute function from included library that calls function", ->
    @funcCallsFunc.exec(@ctx).should.equal 25

  it "should execute expression from included library that uses expression", ->
    @exprUsesExpr.exec(@ctx).should.equal 3

  it "should execute function from included library that uses expression", ->
    @funcUsesExpr.exec(@ctx).should.equal 7

  it "should execute function from included library that uses expression", ->
    @exprSortsOnFunc.exec(@ctx).should.eql [{N: 1}, {N: 2}, {N: 3}, {N: 4}, {N: 5}]
