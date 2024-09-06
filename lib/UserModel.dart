class UserModel{
  String ?uid;
  String ?employeeid;
  String ?email;

  UserModel({this.uid,this.employeeid,this.email});
  UserModel.fromMap(Map<String,dynamic> map){
    uid= map["uid"];
    employeeid= map["fullname"];
    email= map["email"];
  }
  Map<String,dynamic> toMap(){
    return {
      "uid": uid,
      'employeeid': employeeid,
      'email':email,
    };
  }
}

