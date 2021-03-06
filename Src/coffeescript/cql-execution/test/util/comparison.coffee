should = require 'should'
{equals} = require '../../lib/util/comparison'

describe 'equals', ->
  it 'should detect equality/inequality for numbers', ->
    equals(1, 1).should.be.true()
    equals(1, -1).should.be.false()
    equals(5, 2+3).should.be.true()
    equals(1.2345, 1.2345).should.be.true()
    equals(1.2345, 1.23456).should.be.false()

  it 'should detect equality/inequality for strings', ->
    equals('', '').should.be.true()
    equals('a', 'a').should.be.true()
    equals('a', 'A').should.be.false()
    equals('abc', 'ab' + 'c').should.be.true()
    equals('abc', 'abcd').should.be.false()

  it 'should detect equality/inequality for dates', ->
    equals(new Date(2012, 2, 5, 10, 55, 34, 235), new Date(2012, 2, 5, 10, 55, 34, 235)).should.be.true()
    equals(new Date(2012, 2, 5, 10, 55, 34, 235), new Date(2012, 2, 5, 10, 55, 34, 236)).should.be.false()
    equals(new Date('2012-03-05T10:55:34.235'), new Date('2012-03-05T10:55:34.235')).should.be.true()
    equals(new Date('2012-03-05T10:55:34.235-04:00'), new Date('2012-03-05T10:55:34.235-05:00')).should.be.false()
    equals(new Date('2012-03-05T10:55:34.235-04:00'), new Date('2012-03-05T09:55:34.235-05:00')).should.be.true()

  it 'should detect equality/inequality for regular expressions', ->
    equals(/\w+\s/g, /\w+\s/g).should.be.true()
    equals(/\w+\s/g, /\w+\s/gi).should.be.false()
    equals(/\w+\s*/g, /\w+\s/g).should.be.false()

  it 'should detect equality/inequality for objects', ->
    equals({}, {}).should.be.true()
    equals({a: 1, b:2, c:3}, {a: 1, b: 2, c: 3}).should.be.true()
    equals({a: 1, b:2, c:3}, {c: 3, b: 2, a: 1}).should.be.true()
    equals({a: 1, b:2, c:3}, {a: 1, b: 2}).should.be.false()
    equals({a: 1, b:2}, {a: 1, b: 2, c: 3}).should.be.false()
    equals({a: {b: {c: 'd'}, e: 'f'}, g: 'h'}, {a: {b: {c: 'd'}, e: 'f'}, g: 'h'}).should.be.true()
    equals({a: {b: {c: 'd'}, e: 'f'}, g: 'h'}, {a: {b: {c: 'dee'}, e: 'f'}, g: 'h'}).should.be.false()
    equals({a: new Date('2012-03-05T10:55:34.235')}, {a: new Date('2012-03-05T10:55:34.235')}).should.be.true()
    equals({a: [1, 2, 3], b: [4, 5, 6]}, {a: [1, 2, 3], b: [4, 5, 6]}).should.be.true()
    equals({a: [1, 2, 3], b: [4, 5, 6]}, {a: [3, 2, 1], b: [6, 5, 4]}).should.be.false()

  it 'should detect equality/inequality for classes', ->
    class Foo
      constructor: (@prop1, @prop2) ->

    class Bar extends Foo
      constructor: (@prop1, @prop2) ->
        super

    equals(new Foo('abc', [1,2,3]), new Foo('abc', [1,2,3])).should.be.true()
    equals(new Foo('abc', [1,2,3]), new Foo('abcd', [1,2,3])).should.be.false()
    equals(new Foo('abc', new Bar('xyz')), new Foo('abc', new Bar('xyz'))).should.be.true()
    equals(new Foo('abc', new Bar('xyz')), new Foo('abc', new Bar('xyz',999))).should.be.false()
    equals(new Foo('abc', [1,2,3]), new Bar('abc', [1,2,3])).should.be.false()
    equals(new Bar('abc', [1,2,3]), new Foo('abc', [1,2,3])).should.be.false()

  it 'should delegate to equals method when available', ->
    class Int
      constructor: (@num) ->

    class StringFriendlyInt extends Int
      constructor: (@num) ->

      asInt: () ->
        switch typeof(@num)
          when 'number' then Math.floor(@num)
          when 'string' then parseInt(@num)
          else Number.NaN

      equals: (other) ->
        other instanceof StringFriendlyInt and @asInt() is other.asInt()

    equals(new Int(1), new Int('1')).should.be.false()
    equals(new StringFriendlyInt(1), new StringFriendlyInt('1')).should.be.true()

  it 'should detect equality/inequality for arrays', ->
    equals([], []).should.be.true()
    equals([1], [1]).should.be.true()
    equals([1, 2, 3], [1, 2, 3]).should.be.true()
    equals([1, 2, 3], [3, 2, 1]).should.be.false()
    equals([1, 2, 3], [1, 2]).should.be.false()
    equals([1, 2], [1, 2, 3]).should.be.false()
    equals([{a: 1}, {b: 2}], [{a: 1}, {b: 2}]).should.be.true()
    equals([['a','b','c'],[1,2,3]], [['a','b','c'],[1,2,3]]).should.be.true()
    equals([['a','b','c'],[1,2,3]], [['a','b','c'],[1,2,3,4]]).should.be.false()

  it 'should handle null values', ->
    equals(null, null).should.be.true()
    equals(null, 0).should.be.false()
    equals(0, null).should.be.false()
    equals(null, 'null').should.be.false()
    equals('null', null).should.be.false()
    equals(null, {}).should.be.false()
    equals({}, null).should.be.false()
    equals(null, [null]).should.be.false()
    equals([null], null).should.be.false()
    equals(null, {}.undef).should.be.false()
    equals({}.undef, null).should.be.false()
