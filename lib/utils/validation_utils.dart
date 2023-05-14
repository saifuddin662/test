import 'package:flutter_contacts/contact.dart';

/**
 * Created by Md. Awon-Uz-Zaman on 17/January/2023
 */


class ValidationUtils {

  static bool validateMobile(String typedNumber){
    String pattern = r'^(?:\+?88)?01[1-9]\d{8}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(typedNumber)){
      return true;
    }
    return false;
  }

  static List<Contact> getValidContacts(List<Contact> contacts) {
    List<Contact> validContacts = [];
    contacts.forEach((element) {
      validContacts.add(element);
      // if(ValidationUtils.validateMobile(element.phones[0].number.toString())){
      //   validContacts.add(element);
      // }
    });
    return validContacts;
  }
}
