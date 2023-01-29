class Pet {
  var id,
      user_id,
      owner_id,
      gender,
      male_neuterated,
      status,
      name,
      image,
      dob,
      species,
      breed,
      injuries,
      note;

  Pet(
      this.id,
      this.user_id,
      this.owner_id,
      this.name,
      this.image,
      this.dob,
      this.gender,
      this.species,
      this.breed,
      this.male_neuterated,
      this.injuries,
      this.note,
      this.status);

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        owner_id = json['owner_id'],
        name = json['name'],
        image = json['image'],
        dob = json['dob'],
        gender = json['gender'],
        species = json['species'],
        breed = json['breed'],
        male_neuterated = json['male_neuterated'],
        injuries = json['injuries'],
        note = json['note'],
        status = json['status'];
}
