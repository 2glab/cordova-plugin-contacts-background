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
        argscheck.checkArgs('fF', 'PhonebookContacts.contacts', arguments);
        exec(successCB, errorCB, "PhonebookContacts", "contacts", []);
    }
};

module.exports = PhonebookContacts;
