
fs = require 'fs'
Dom = require('dom-js').DomJS

module.exports = 
    read: (file, property, callback) ->
        fs.readFile file, (err, xml) ->
            return callback err if err
            dom = new Dom
            dom.parse '<?xml version="1.0"?>' + xml.toString(), (err, doc) ->
                return callback err if err
                for propertyChild in doc.children
                    continue unless propertyChild.name is 'property'
                    found = false
                    for child in propertyChild.children
                        found = true if child.name is 'name' and child.text() is property
                        break if found
                    continue unless found
                    for child in propertyChild.children
                        return callback null, child.text() if child.name is 'value'
                # Property no found
                callback null, null
