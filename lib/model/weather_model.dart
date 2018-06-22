


class Weather {
  String temp;
  String description;
  String icon;

  Weather({
    this.temp,
    this.description,
    this.icon,
  });

  Weather.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> subMap = new Map();
    List<dynamic> list = new List();
    json.forEach((k, v) {

      if (k == 'main') {
        subMap = v;
        this.temp = ((subMap['temp'] -273)*9/5+32).truncate().toString() +'\u00b0';
      }
      else if (k == 'weather') {
        list = v;
        this.description = list[0]['description'];
        this.icon = 'http://openweathermap.org/img/w/' + list[0]['icon'] + '.png';
      }
    });
  }
}