class DataStudent {
  static final DataStudent _instance = DataStudent._internal();

  int? studentId;
  String? image;
  List<int>? enrollmentIds;
  String? name;
  String? identification;
  String? birthDate;
  String? gender;
  int? age;
  String? email;
  String? phone;
  String? address;
  String? enrollmentDate;
  Map<String, dynamic>? currentCourse;
  List<int>? courseIds;
  String? bloodType;
  String? medicalConditions;
  String? allergies;
  Map<String, dynamic>? parentInfo;
  Map<String, dynamic>? secondaryParentInfo;
  String? status;
  bool? isActive;

  factory DataStudent() {
    return _instance;
  }

  DataStudent._internal();

  // Método para actualizar los datos del estudiante
  void setData(Map<String, dynamic> data) {
    studentId = data['id'];
    image = data['image'];
    enrollmentIds = List<int>.from(data['enrollment_ids'] ?? []);
    name = data['name'];
    identification = data['identification'];
    birthDate = data['birth_date'];
    gender = data['gender'];
    age = data['age'];
    email = data['email'];
    phone = data['phone'];
    address = data['address'];
    enrollmentDate = data['enrollment_date'];
    currentCourse = {
      "course_id": data['current_course_id'][0],
      "course_name": data['current_course_id'][1]
    };
    courseIds = List<int>.from(data['course_ids'] ?? []);
    bloodType = data['blood_type'];
    medicalConditions = data['medical_conditions'];
    allergies = data['allergies'];
    parentInfo = {
      "parent_id": data['parent_id'][0],
      "parent_name": data['parent_id'][1]
    };
    secondaryParentInfo = data['secondary_parent_id'];
    status = data['status'];
    isActive = data['active'];
  }
}
