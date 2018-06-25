import 'package:nero_restaurant/model/globals.dart' as globals;

class Options {

  static Map<String, List<String>> getOptionsForThisItem(List<dynamic> options) {
    Map<String, List<String>> optionFields = new Map();

    if (options.isNotEmpty)
      options.forEach((option) {
        optionFields.addAll(
            {option.toString(): globals.allOptions[option.toString()]});
      });

    return optionFields;
  }
}
