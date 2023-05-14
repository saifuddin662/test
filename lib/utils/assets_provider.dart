class AssetsProvider{

  static String imagePath(String name,{String type = 'png'}){
    return 'assets/images/$name.$type';
  }

  static String lottiePath(String name){
    return 'assets/json/$name.json';
  }

  static String gifPath(String name){
    return 'assets/gifs/$name.gif';
  }

  static String loadJson(String name){
    return 'assets/data/$name.json';
  }
}
