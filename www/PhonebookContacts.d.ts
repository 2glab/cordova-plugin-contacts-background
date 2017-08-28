interface Navigator {
    /** Provides access to the device contacts database. */
    PhonebookContacts: PhonebookContacts;
}

interface PhonebookContacts {
    /**
     * The navigator.PhonebookContacts.contacts method executes asynchronously
     * @param onSuccess Success callback function
     * @param onError Error callback function
     */
    contacts(onSuccess: (result: string) => void,
        onError?: (error: string) => void): void;
}
