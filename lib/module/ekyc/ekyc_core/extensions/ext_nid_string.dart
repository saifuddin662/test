/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

extension ExtNidString on String {

  bool get isValidMobileNo {
    final mobileRegExp = RegExp("(?:\\+88|88)?(01[3-9]\\d{8})");
    return mobileRegExp.hasMatch(this);
  }

  bool get isValidNomDob {
    final mobileRegExp = RegExp("((?:19|20)\\d\\d)/(0?[1-9]|1[012])/([12][0-9]|3[01]|0?[1-9])");
    return mobileRegExp.hasMatch(this);
  }

  bool get isValidAddress {
    if (length > 3) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValidNid {
    if (length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValidPostCode {
    if (length == 4) {
      return true;
    } else {
      return false;
    }
  }

  bool get isBasicValidText {
    if (length >= 2) {
      return true;
    } else {
      return false;
    }
  }

  bool get isBasicValidNumber {
    if (length >= 1) {
      return true;
    } else {
      return false;
    }
  }
}