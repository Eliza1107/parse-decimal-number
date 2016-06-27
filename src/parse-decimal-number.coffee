fs = require 'fs'

patterns=[]
options ={}
module.exports = (value,inOptions,enforceGroupSize=true)->

  if typeof inOptions is 'string' and inOptions.match /\w+/
    separators = findSeparatorsByCountry(inOptions)
    if separators is '' then throw {name:'ArgumentException',message:'The format for area code is incorrect.'}
    thousands = separators[0]
    decimal = separators[1]
  else if typeof inOptions is 'string'
    if inOptions.length isnt 2 then throw {name:'ArgumentException',message:'The format for string options is \'<thousands><decimal>\' (exactly two characters)'}
    thousands = inOptions[0]
    decimal   = inOptions[1]
  else if inOptions instanceof Array
    if inOptions.length isnt 2 then throw {name:'ArgumentException',message:'The format for array options is [\'<thousands>\',\'[<decimal>\'] (exactly two elements)'}
    thousands = inOptions[0]
    decimal   = inOptions[1]
  else
    thousands = inOptions?.thousands or options.thousands
    decimal   = inOptions?.decimal    or options.decimal

  patternIndex = "#{thousands}#{decimal}#{enforceGroupSize}"
  pattern = patterns[patternIndex]
  if not pattern
    if enforceGroupSize
      pattern = patterns[patternIndex] =  new RegExp ('^\\s*(-?(?:(?:\\d{1,3}(?:\\' + thousands + '\\d{3})+)|\\d*))(?:\\' + decimal + '(\\d*))?\\s*$')
    else
      pattern = patterns[patternIndex] =  new RegExp ('^\\s*(-?(?:(?:\\d{1,3}(?:\\' + thousands + '\\d{1,3})+)|\\d*))(?:\\' + decimal + '(\\d*))?\\s*$')

  result = value.match pattern
  return NaN if not result or result.length != 3

  integerPart  = result[1].replace new RegExp("\\#{thousands}",'g'),''
  fractionPart = result[2]
  number = parseFloat "#{integerPart}.#{fractionPart}"
  return number

findSeparatorsByCountry = (code) ->
  jsonFile = fs.readFileSync("./dist/locales.json", "utf8")
  data = JSON.parse(jsonFile)
  sep = ''
  for key, value of data
    if code in value
      sep = key
      break
  return sep



module.exports.setOptions = (newOptions)->
  options[key] = value for key, value of newOptions
  return

module.exports.factoryReset = ->
  options =
    thousands : ','
    decimal   : '.'

module.exports.factoryReset()
