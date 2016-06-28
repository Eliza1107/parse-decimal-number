(function() {
  var fs,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fs = require('fs');

  module.exports = function(filename) {
    var code, codeSplit, file, i, jsonString, len, len1, line, lines, readline, sep, separatorsDict;
    readline = require('readline');
    fs = require('fs');
    separatorsDict = {
      ' ,': [],
      ' .': [],
      ',.': [],
      '.,': [],
      "',": [],
      "'.": [],
      "’,": [],
      "’.": [],
      "..": []
    };
    file = fs.readFileSync(filename, "utf8");
    lines = file.split('\n');
    for (i = 0, len1 = lines.length; i < len1; i++) {
      line = lines[i];
      if (line) {
        len = line.length;
        sep = line.substring(len - 2, len);
        code = line.substring(0, len - 2);
        if (indexOf.call(code, '_') >= 0) {
          codeSplit = code.split('_');
          code = codeSplit[0] + codeSplit[1];
        }
        separatorsDict[sep].push(code);
      }
    }
    jsonString = JSON.stringify(separatorsDict);
    return fs.writeFile("./dist/locales.json", jsonString, function(err) {
      if (err) {
        return console.log(err);
      }
    });
  };

}).call(this);
