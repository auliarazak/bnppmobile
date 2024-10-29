class Mark {
  int? _id;
  late String _judul;
  late String _deskripsi;
  late String _tglAwal;
  late String _tglAkhir;
  late String _waktuAwal;
  late String _waktuAkhir;
  late String _lokasi;
  late String _warna;

  // Konstruktor tanpa id
  Mark(
      this._judul, 
      this._deskripsi, 
      this._tglAwal, 
      this._tglAkhir,
      this._waktuAwal, 
      this._waktuAkhir, 
      this._lokasi, 
      this._warna);

  // Konstruktor dengan id
  Mark.withId(
      this._id,
      this._judul,
      this._deskripsi,
      this._tglAwal,
      this._tglAkhir,
      this._waktuAwal,
      this._waktuAkhir,
      this._lokasi,
      this._warna);

  // Getter untuk id
  int? get id => _id;

  // Getter untuk properti lain
  String get judul => _judul;
  String get deskripsi => _deskripsi;
  String get tglAwal => _tglAwal;
  String get tglAkhir => _tglAkhir;
  String get waktuAwal => _waktuAwal;
  String get waktuAkhir => _waktuAkhir;
  String get lokasi => _lokasi;
  String get warna => _warna;

  //set
  set judul(String newJudul) {
    if (newJudul.length <= 100) {
      this._judul = newJudul;
    }
  }

  set deskripsi(String newDeskripsi) {
    if (newDeskripsi.length <= 255) {
      this._deskripsi = newDeskripsi;
    }
  }

  set tglAwal(String newtglAwal) {
    this._tglAwal = newtglAwal;
  }

  set tglAkhir(String newtglAkhir) {
    this._tglAkhir = newtglAkhir;
  }

  set waktuAwal(String newwaktuAwal) {
    this._waktuAwal = newwaktuAwal;
  }

  set waktuAkhir(String newwaktuAkhir) {
    this._waktuAkhir = newwaktuAkhir;
  }

  set lokasi(String newLokasi) {
    if (newLokasi.length <= 100) {
      this._lokasi = newLokasi;
    }
  }

  set warna(String newWarna) {
    if (newWarna.length <= 30) {
      this._warna = newWarna;
    }
  }

  //convert mark objek to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['judul'] = _judul;
    map['deskripsi'] = _deskripsi;
    map['tglAwal'] = _tglAwal;
    map['tglAkhir'] = _tglAkhir;
    map['waktuAwal'] = _waktuAwal;
    map['waktuAkhir'] = _waktuAkhir;
    map['lokasi'] = _lokasi;
    map['warna'] = _warna;

    return map;
  }

  //extract map to mark object
  Mark.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._judul = map['judul'];
    this._deskripsi = map['deskripsi'];
    this._tglAwal = map['tglAwal'];
    this._tglAkhir = map['tglAkhir'];
    this._waktuAwal = map['waktuAwal'];
    this._waktuAkhir = map['waktuAkhir'];
    this._lokasi = map['lokasi'];
    this._warna = map['warna'];
  }
}
