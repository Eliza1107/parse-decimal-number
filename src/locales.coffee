fs = require 'fs'

createLocaleJson= (filename) ->
  #assuming the filename is a .txt file
  readline = require 'readline'
  fs = require 'fs'
  separatorsDict = {' ,':[], ' .':[], ',.':[], '.,':[], "',":[], "'.":[], "’,":[], "’.":[],  "..":[]}

  file = fs.readFileSync(filename, "utf8")
  lines = file.split('\n')
  for line in lines
    if line
      len = line.length
      sep = line.substring(len-2 ,len)
      code = line.substring(0, len-2)
      if '_' in code #remove '_' from the area code
        codeSplit = code.split('_')
        code = codeSplit[0] + codeSplit[1]
      separatorsDict[sep].push(code)

  #save to a file
  jsonString = JSON.stringify(separatorsDict)
  fs.writeFile("./dist/locales.json", jsonString, (err) ->
    if err
      return console.log(err)
  )
  createLocaleJson('../locale/final_data.txt')
