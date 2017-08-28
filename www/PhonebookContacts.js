var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

/**
* Represents a group of Contacts.
* @constructor
*/
var PhonebookContacts = {
    /**
     * Returns an array of Contacts
     * @param successCB success callback
     * @param errorCB error callback
     * @return array of Contacts
     */
    contacts:function(successCB, errorCB) {
        argscheck.checkArgs('fF', 'Echo.myPluginMethod', arguments);
        exec(successCB, errorCB, "Echo", "myPluginMethod", []);
    }
};

module.exports = PhonebookContacts;
