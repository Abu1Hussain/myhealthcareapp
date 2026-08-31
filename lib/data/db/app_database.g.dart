// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<UserRole, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<UserRole>($UsersTable.$converterrole);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordSaltMeta =
      const VerificationMeta('passwordSalt');
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
      'password_salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
      'dob', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nationalIdMeta =
      const VerificationMeta('nationalId');
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
      'national_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 9, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        role,
        fullName,
        email,
        passwordHash,
        passwordSalt,
        phone,
        dob,
        gender,
        nationalId,
        isActive,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
          _passwordSaltMeta,
          passwordSalt.isAcceptableOrUnknown(
              data['password_salt']!, _passwordSaltMeta));
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
          _dobMeta, dob.isAcceptableOrUnknown(data['dob']!, _dobMeta));
    } else if (isInserting) {
      context.missing(_dobMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('national_id')) {
      context.handle(
          _nationalIdMeta,
          nationalId.isAcceptableOrUnknown(
              data['national_id']!, _nationalIdMeta));
    } else if (isInserting) {
      context.missing(_nationalIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      role: $UsersTable.$converterrole.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      passwordSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_salt'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      dob: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dob'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      nationalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}national_id'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UserRole, String, String> $converterrole =
      const EnumNameConverter<UserRole>(UserRole.values);
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final UserRole role;
  final String fullName;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final String phone;
  final DateTime dob;
  final String gender;
  final String nationalId;
  final bool isActive;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.role,
      required this.fullName,
      required this.email,
      required this.passwordHash,
      required this.passwordSalt,
      required this.phone,
      required this.dob,
      required this.gender,
      required this.nationalId,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['role'] = Variable<String>($UsersTable.$converterrole.toSql(role));
    }
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['phone'] = Variable<String>(phone);
    map['dob'] = Variable<DateTime>(dob);
    map['gender'] = Variable<String>(gender);
    map['national_id'] = Variable<String>(nationalId);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      role: Value(role),
      fullName: Value(fullName),
      email: Value(email),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      phone: Value(phone),
      dob: Value(dob),
      gender: Value(gender),
      nationalId: Value(nationalId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      role: $UsersTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      phone: serializer.fromJson<String>(json['phone']),
      dob: serializer.fromJson<DateTime>(json['dob']),
      gender: serializer.fromJson<String>(json['gender']),
      nationalId: serializer.fromJson<String>(json['nationalId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role':
          serializer.toJson<String>($UsersTable.$converterrole.toJson(role)),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'phone': serializer.toJson<String>(phone),
      'dob': serializer.toJson<DateTime>(dob),
      'gender': serializer.toJson<String>(gender),
      'nationalId': serializer.toJson<String>(nationalId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          UserRole? role,
          String? fullName,
          String? email,
          String? passwordHash,
          String? passwordSalt,
          String? phone,
          DateTime? dob,
          String? gender,
          String? nationalId,
          bool? isActive,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        role: role ?? this.role,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        passwordSalt: passwordSalt ?? this.passwordSalt,
        phone: phone ?? this.phone,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
        nationalId: nationalId ?? this.nationalId,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      phone: data.phone.present ? data.phone.value : this.phone,
      dob: data.dob.present ? data.dob.value : this.dob,
      gender: data.gender.present ? data.gender.value : this.gender,
      nationalId:
          data.nationalId.present ? data.nationalId.value : this.nationalId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('phone: $phone, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender, ')
          ..write('nationalId: $nationalId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, fullName, email, passwordHash,
      passwordSalt, phone, dob, gender, nationalId, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.role == this.role &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.phone == this.phone &&
          other.dob == this.dob &&
          other.gender == this.gender &&
          other.nationalId == this.nationalId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<UserRole> role;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<String> phone;
  final Value<DateTime> dob;
  final Value<String> gender;
  final Value<String> nationalId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.phone = const Value.absent(),
    this.dob = const Value.absent(),
    this.gender = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required UserRole role,
    required String fullName,
    required String email,
    required String passwordHash,
    required String passwordSalt,
    required String phone,
    required DateTime dob,
    required String gender,
    required String nationalId,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : role = Value(role),
        fullName = Value(fullName),
        email = Value(email),
        passwordHash = Value(passwordHash),
        passwordSalt = Value(passwordSalt),
        phone = Value(phone),
        dob = Value(dob),
        gender = Value(gender),
        nationalId = Value(nationalId);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<String>? phone,
    Expression<DateTime>? dob,
    Expression<String>? gender,
    Expression<String>? nationalId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (phone != null) 'phone': phone,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (nationalId != null) 'national_id': nationalId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<UserRole>? role,
      Value<String>? fullName,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String>? passwordSalt,
      Value<String>? phone,
      Value<DateTime>? dob,
      Value<String>? gender,
      Value<String>? nationalId,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      nationalId: nationalId ?? this.nationalId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] =
          Variable<String>($UsersTable.$converterrole.toSql(role.value));
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('phone: $phone, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender, ')
          ..write('nationalId: $nationalId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PatientProfilesTable extends PatientProfiles
    with TableInfo<$PatientProfilesTable, PatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _bloodTypeMeta =
      const VerificationMeta('bloodType');
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
      'blood_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _allergiesMeta =
      const VerificationMeta('allergies');
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
      'allergies', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chronicConditionsMeta =
      const VerificationMeta('chronicConditions');
  @override
  late final GeneratedColumn<String> chronicConditions =
      GeneratedColumn<String>('chronic_conditions', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emergencyContactMeta =
      const VerificationMeta('emergencyContact');
  @override
  late final GeneratedColumn<String> emergencyContact = GeneratedColumn<String>(
      'emergency_contact', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, bloodType, allergies, chronicConditions, emergencyContact];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PatientProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('blood_type')) {
      context.handle(_bloodTypeMeta,
          bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta));
    } else if (isInserting) {
      context.missing(_bloodTypeMeta);
    }
    if (data.containsKey('allergies')) {
      context.handle(_allergiesMeta,
          allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta));
    } else if (isInserting) {
      context.missing(_allergiesMeta);
    }
    if (data.containsKey('chronic_conditions')) {
      context.handle(
          _chronicConditionsMeta,
          chronicConditions.isAcceptableOrUnknown(
              data['chronic_conditions']!, _chronicConditionsMeta));
    } else if (isInserting) {
      context.missing(_chronicConditionsMeta);
    }
    if (data.containsKey('emergency_contact')) {
      context.handle(
          _emergencyContactMeta,
          emergencyContact.isAcceptableOrUnknown(
              data['emergency_contact']!, _emergencyContactMeta));
    } else if (isInserting) {
      context.missing(_emergencyContactMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  PatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientProfile(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      bloodType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_type'])!,
      allergies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergies'])!,
      chronicConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chronic_conditions'])!,
      emergencyContact: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}emergency_contact'])!,
    );
  }

  @override
  $PatientProfilesTable createAlias(String alias) {
    return $PatientProfilesTable(attachedDatabase, alias);
  }
}

class PatientProfile extends DataClass implements Insertable<PatientProfile> {
  final int userId;
  final String bloodType;
  final String allergies;
  final String chronicConditions;
  final String emergencyContact;
  const PatientProfile(
      {required this.userId,
      required this.bloodType,
      required this.allergies,
      required this.chronicConditions,
      required this.emergencyContact});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['blood_type'] = Variable<String>(bloodType);
    map['allergies'] = Variable<String>(allergies);
    map['chronic_conditions'] = Variable<String>(chronicConditions);
    map['emergency_contact'] = Variable<String>(emergencyContact);
    return map;
  }

  PatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return PatientProfilesCompanion(
      userId: Value(userId),
      bloodType: Value(bloodType),
      allergies: Value(allergies),
      chronicConditions: Value(chronicConditions),
      emergencyContact: Value(emergencyContact),
    );
  }

  factory PatientProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientProfile(
      userId: serializer.fromJson<int>(json['userId']),
      bloodType: serializer.fromJson<String>(json['bloodType']),
      allergies: serializer.fromJson<String>(json['allergies']),
      chronicConditions: serializer.fromJson<String>(json['chronicConditions']),
      emergencyContact: serializer.fromJson<String>(json['emergencyContact']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'bloodType': serializer.toJson<String>(bloodType),
      'allergies': serializer.toJson<String>(allergies),
      'chronicConditions': serializer.toJson<String>(chronicConditions),
      'emergencyContact': serializer.toJson<String>(emergencyContact),
    };
  }

  PatientProfile copyWith(
          {int? userId,
          String? bloodType,
          String? allergies,
          String? chronicConditions,
          String? emergencyContact}) =>
      PatientProfile(
        userId: userId ?? this.userId,
        bloodType: bloodType ?? this.bloodType,
        allergies: allergies ?? this.allergies,
        chronicConditions: chronicConditions ?? this.chronicConditions,
        emergencyContact: emergencyContact ?? this.emergencyContact,
      );
  PatientProfile copyWithCompanion(PatientProfilesCompanion data) {
    return PatientProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      chronicConditions: data.chronicConditions.present
          ? data.chronicConditions.value
          : this.chronicConditions,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfile(')
          ..write('userId: $userId, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('emergencyContact: $emergencyContact')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId, bloodType, allergies, chronicConditions, emergencyContact);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientProfile &&
          other.userId == this.userId &&
          other.bloodType == this.bloodType &&
          other.allergies == this.allergies &&
          other.chronicConditions == this.chronicConditions &&
          other.emergencyContact == this.emergencyContact);
}

class PatientProfilesCompanion extends UpdateCompanion<PatientProfile> {
  final Value<int> userId;
  final Value<String> bloodType;
  final Value<String> allergies;
  final Value<String> chronicConditions;
  final Value<String> emergencyContact;
  const PatientProfilesCompanion({
    this.userId = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.allergies = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.emergencyContact = const Value.absent(),
  });
  PatientProfilesCompanion.insert({
    this.userId = const Value.absent(),
    required String bloodType,
    required String allergies,
    required String chronicConditions,
    required String emergencyContact,
  })  : bloodType = Value(bloodType),
        allergies = Value(allergies),
        chronicConditions = Value(chronicConditions),
        emergencyContact = Value(emergencyContact);
  static Insertable<PatientProfile> custom({
    Expression<int>? userId,
    Expression<String>? bloodType,
    Expression<String>? allergies,
    Expression<String>? chronicConditions,
    Expression<String>? emergencyContact,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (bloodType != null) 'blood_type': bloodType,
      if (allergies != null) 'allergies': allergies,
      if (chronicConditions != null) 'chronic_conditions': chronicConditions,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
    });
  }

  PatientProfilesCompanion copyWith(
      {Value<int>? userId,
      Value<String>? bloodType,
      Value<String>? allergies,
      Value<String>? chronicConditions,
      Value<String>? emergencyContact}) {
    return PatientProfilesCompanion(
      userId: userId ?? this.userId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (chronicConditions.present) {
      map['chronic_conditions'] = Variable<String>(chronicConditions.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('emergencyContact: $emergencyContact')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(Insertable<Department> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final int id;
  final String name;
  final String description;
  const Department(
      {required this.id, required this.name, required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
  }

  factory Department.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  Department copyWith({int? id, String? name, String? description}) =>
      Department(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
  })  : name = Value(name),
        description = Value(description);
  static Insertable<Department> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  DepartmentsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? description}) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $StaffProfilesTable extends StaffProfiles
    with TableInfo<$StaffProfilesTable, StaffProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _departmentIdMeta =
      const VerificationMeta('departmentId');
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
      'department_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES departments (id)'));
  static const VerificationMeta _specialtyMeta =
      const VerificationMeta('specialty');
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
      'specialty', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _licenseNoMeta =
      const VerificationMeta('licenseNo');
  @override
  late final GeneratedColumn<String> licenseNo = GeneratedColumn<String>(
      'license_no', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _jobTitleMeta =
      const VerificationMeta('jobTitle');
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
      'job_title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, departmentId, specialty, licenseNo, jobTitle];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<StaffProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('department_id')) {
      context.handle(
          _departmentIdMeta,
          departmentId.isAcceptableOrUnknown(
              data['department_id']!, _departmentIdMeta));
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(_specialtyMeta,
          specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta));
    } else if (isInserting) {
      context.missing(_specialtyMeta);
    }
    if (data.containsKey('license_no')) {
      context.handle(_licenseNoMeta,
          licenseNo.isAcceptableOrUnknown(data['license_no']!, _licenseNoMeta));
    } else if (isInserting) {
      context.missing(_licenseNoMeta);
    }
    if (data.containsKey('job_title')) {
      context.handle(_jobTitleMeta,
          jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta));
    } else if (isInserting) {
      context.missing(_jobTitleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  StaffProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffProfile(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      departmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}department_id'])!,
      specialty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialty'])!,
      licenseNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_no'])!,
      jobTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_title'])!,
    );
  }

  @override
  $StaffProfilesTable createAlias(String alias) {
    return $StaffProfilesTable(attachedDatabase, alias);
  }
}

class StaffProfile extends DataClass implements Insertable<StaffProfile> {
  final int userId;
  final int departmentId;
  final String specialty;
  final String licenseNo;
  final String jobTitle;
  const StaffProfile(
      {required this.userId,
      required this.departmentId,
      required this.specialty,
      required this.licenseNo,
      required this.jobTitle});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['department_id'] = Variable<int>(departmentId);
    map['specialty'] = Variable<String>(specialty);
    map['license_no'] = Variable<String>(licenseNo);
    map['job_title'] = Variable<String>(jobTitle);
    return map;
  }

  StaffProfilesCompanion toCompanion(bool nullToAbsent) {
    return StaffProfilesCompanion(
      userId: Value(userId),
      departmentId: Value(departmentId),
      specialty: Value(specialty),
      licenseNo: Value(licenseNo),
      jobTitle: Value(jobTitle),
    );
  }

  factory StaffProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffProfile(
      userId: serializer.fromJson<int>(json['userId']),
      departmentId: serializer.fromJson<int>(json['departmentId']),
      specialty: serializer.fromJson<String>(json['specialty']),
      licenseNo: serializer.fromJson<String>(json['licenseNo']),
      jobTitle: serializer.fromJson<String>(json['jobTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'departmentId': serializer.toJson<int>(departmentId),
      'specialty': serializer.toJson<String>(specialty),
      'licenseNo': serializer.toJson<String>(licenseNo),
      'jobTitle': serializer.toJson<String>(jobTitle),
    };
  }

  StaffProfile copyWith(
          {int? userId,
          int? departmentId,
          String? specialty,
          String? licenseNo,
          String? jobTitle}) =>
      StaffProfile(
        userId: userId ?? this.userId,
        departmentId: departmentId ?? this.departmentId,
        specialty: specialty ?? this.specialty,
        licenseNo: licenseNo ?? this.licenseNo,
        jobTitle: jobTitle ?? this.jobTitle,
      );
  StaffProfile copyWithCompanion(StaffProfilesCompanion data) {
    return StaffProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      licenseNo: data.licenseNo.present ? data.licenseNo.value : this.licenseNo,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffProfile(')
          ..write('userId: $userId, ')
          ..write('departmentId: $departmentId, ')
          ..write('specialty: $specialty, ')
          ..write('licenseNo: $licenseNo, ')
          ..write('jobTitle: $jobTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, departmentId, specialty, licenseNo, jobTitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffProfile &&
          other.userId == this.userId &&
          other.departmentId == this.departmentId &&
          other.specialty == this.specialty &&
          other.licenseNo == this.licenseNo &&
          other.jobTitle == this.jobTitle);
}

class StaffProfilesCompanion extends UpdateCompanion<StaffProfile> {
  final Value<int> userId;
  final Value<int> departmentId;
  final Value<String> specialty;
  final Value<String> licenseNo;
  final Value<String> jobTitle;
  const StaffProfilesCompanion({
    this.userId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.specialty = const Value.absent(),
    this.licenseNo = const Value.absent(),
    this.jobTitle = const Value.absent(),
  });
  StaffProfilesCompanion.insert({
    this.userId = const Value.absent(),
    required int departmentId,
    required String specialty,
    required String licenseNo,
    required String jobTitle,
  })  : departmentId = Value(departmentId),
        specialty = Value(specialty),
        licenseNo = Value(licenseNo),
        jobTitle = Value(jobTitle);
  static Insertable<StaffProfile> custom({
    Expression<int>? userId,
    Expression<int>? departmentId,
    Expression<String>? specialty,
    Expression<String>? licenseNo,
    Expression<String>? jobTitle,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (departmentId != null) 'department_id': departmentId,
      if (specialty != null) 'specialty': specialty,
      if (licenseNo != null) 'license_no': licenseNo,
      if (jobTitle != null) 'job_title': jobTitle,
    });
  }

  StaffProfilesCompanion copyWith(
      {Value<int>? userId,
      Value<int>? departmentId,
      Value<String>? specialty,
      Value<String>? licenseNo,
      Value<String>? jobTitle}) {
    return StaffProfilesCompanion(
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      specialty: specialty ?? this.specialty,
      licenseNo: licenseNo ?? this.licenseNo,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (licenseNo.present) {
      map['license_no'] = Variable<String>(licenseNo.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('departmentId: $departmentId, ')
          ..write('specialty: $specialty, ')
          ..write('licenseNo: $licenseNo, ')
          ..write('jobTitle: $jobTitle')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _departmentIdMeta =
      const VerificationMeta('departmentId');
  @override
  late final GeneratedColumn<int> departmentId = GeneratedColumn<int>(
      'department_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES departments (id)'));
  static const VerificationMeta _slotStartMeta =
      const VerificationMeta('slotStart');
  @override
  late final GeneratedColumn<DateTime> slotStart = GeneratedColumn<DateTime>(
      'slot_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _slotEndMeta =
      const VerificationMeta('slotEnd');
  @override
  late final GeneratedColumn<DateTime> slotEnd = GeneratedColumn<DateTime>(
      'slot_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _visitTypeMeta =
      const VerificationMeta('visitType');
  @override
  late final GeneratedColumn<String> visitType = GeneratedColumn<String>(
      'visit_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AppointmentStatus, String>
      status = GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(AppointmentStatus.booked.name))
          .withConverter<AppointmentStatus>(
              $AppointmentsTable.$converterstatus);
  static const VerificationMeta _reasonTextMeta =
      const VerificationMeta('reasonText');
  @override
  late final GeneratedColumn<String> reasonText = GeneratedColumn<String>(
      'reason_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookedAtMeta =
      const VerificationMeta('bookedAt');
  @override
  late final GeneratedColumn<DateTime> bookedAt = GeneratedColumn<DateTime>(
      'booked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _noShowRiskMeta =
      const VerificationMeta('noShowRisk');
  @override
  late final GeneratedColumn<double> noShowRisk = GeneratedColumn<double>(
      'no_show_risk', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<RiskBand?, String> riskBand =
      GeneratedColumn<String>('risk_band', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<RiskBand?>($AppointmentsTable.$converterriskBandn);
  static const VerificationMeta _remindersSentMeta =
      const VerificationMeta('remindersSent');
  @override
  late final GeneratedColumn<int> remindersSent = GeneratedColumn<int>(
      'reminders_sent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _checkedInAtMeta =
      const VerificationMeta('checkedInAt');
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
      'checked_in_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        staffId,
        departmentId,
        slotStart,
        slotEnd,
        visitType,
        status,
        reasonText,
        bookedAt,
        noShowRisk,
        riskBand,
        remindersSent,
        checkedInAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(Insertable<Appointment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
          _departmentIdMeta,
          departmentId.isAcceptableOrUnknown(
              data['department_id']!, _departmentIdMeta));
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('slot_start')) {
      context.handle(_slotStartMeta,
          slotStart.isAcceptableOrUnknown(data['slot_start']!, _slotStartMeta));
    } else if (isInserting) {
      context.missing(_slotStartMeta);
    }
    if (data.containsKey('slot_end')) {
      context.handle(_slotEndMeta,
          slotEnd.isAcceptableOrUnknown(data['slot_end']!, _slotEndMeta));
    } else if (isInserting) {
      context.missing(_slotEndMeta);
    }
    if (data.containsKey('visit_type')) {
      context.handle(_visitTypeMeta,
          visitType.isAcceptableOrUnknown(data['visit_type']!, _visitTypeMeta));
    } else if (isInserting) {
      context.missing(_visitTypeMeta);
    }
    if (data.containsKey('reason_text')) {
      context.handle(
          _reasonTextMeta,
          reasonText.isAcceptableOrUnknown(
              data['reason_text']!, _reasonTextMeta));
    } else if (isInserting) {
      context.missing(_reasonTextMeta);
    }
    if (data.containsKey('booked_at')) {
      context.handle(_bookedAtMeta,
          bookedAt.isAcceptableOrUnknown(data['booked_at']!, _bookedAtMeta));
    }
    if (data.containsKey('no_show_risk')) {
      context.handle(
          _noShowRiskMeta,
          noShowRisk.isAcceptableOrUnknown(
              data['no_show_risk']!, _noShowRiskMeta));
    }
    if (data.containsKey('reminders_sent')) {
      context.handle(
          _remindersSentMeta,
          remindersSent.isAcceptableOrUnknown(
              data['reminders_sent']!, _remindersSentMeta));
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
          _checkedInAtMeta,
          checkedInAt.isAcceptableOrUnknown(
              data['checked_in_at']!, _checkedInAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}staff_id'])!,
      departmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}department_id'])!,
      slotStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}slot_start'])!,
      slotEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}slot_end'])!,
      visitType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visit_type'])!,
      status: $AppointmentsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      reasonText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason_text'])!,
      bookedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}booked_at'])!,
      noShowRisk: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}no_show_risk']),
      riskBand: $AppointmentsTable.$converterriskBandn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_band'])),
      remindersSent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminders_sent'])!,
      checkedInAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}checked_in_at']),
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppointmentStatus, String, String>
      $converterstatus =
      const EnumNameConverter<AppointmentStatus>(AppointmentStatus.values);
  static JsonTypeConverter2<RiskBand, String, String> $converterriskBand =
      const EnumNameConverter<RiskBand>(RiskBand.values);
  static JsonTypeConverter2<RiskBand?, String?, String?> $converterriskBandn =
      JsonTypeConverter2.asNullable($converterriskBand);
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final int id;
  final int patientId;
  final int staffId;
  final int departmentId;
  final DateTime slotStart;
  final DateTime slotEnd;
  final String visitType;
  final AppointmentStatus status;
  final String reasonText;
  final DateTime bookedAt;
  final double? noShowRisk;
  final RiskBand? riskBand;
  final int remindersSent;
  final DateTime? checkedInAt;
  const Appointment(
      {required this.id,
      required this.patientId,
      required this.staffId,
      required this.departmentId,
      required this.slotStart,
      required this.slotEnd,
      required this.visitType,
      required this.status,
      required this.reasonText,
      required this.bookedAt,
      this.noShowRisk,
      this.riskBand,
      required this.remindersSent,
      this.checkedInAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['staff_id'] = Variable<int>(staffId);
    map['department_id'] = Variable<int>(departmentId);
    map['slot_start'] = Variable<DateTime>(slotStart);
    map['slot_end'] = Variable<DateTime>(slotEnd);
    map['visit_type'] = Variable<String>(visitType);
    {
      map['status'] =
          Variable<String>($AppointmentsTable.$converterstatus.toSql(status));
    }
    map['reason_text'] = Variable<String>(reasonText);
    map['booked_at'] = Variable<DateTime>(bookedAt);
    if (!nullToAbsent || noShowRisk != null) {
      map['no_show_risk'] = Variable<double>(noShowRisk);
    }
    if (!nullToAbsent || riskBand != null) {
      map['risk_band'] = Variable<String>(
          $AppointmentsTable.$converterriskBandn.toSql(riskBand));
    }
    map['reminders_sent'] = Variable<int>(remindersSent);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      staffId: Value(staffId),
      departmentId: Value(departmentId),
      slotStart: Value(slotStart),
      slotEnd: Value(slotEnd),
      visitType: Value(visitType),
      status: Value(status),
      reasonText: Value(reasonText),
      bookedAt: Value(bookedAt),
      noShowRisk: noShowRisk == null && nullToAbsent
          ? const Value.absent()
          : Value(noShowRisk),
      riskBand: riskBand == null && nullToAbsent
          ? const Value.absent()
          : Value(riskBand),
      remindersSent: Value(remindersSent),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      staffId: serializer.fromJson<int>(json['staffId']),
      departmentId: serializer.fromJson<int>(json['departmentId']),
      slotStart: serializer.fromJson<DateTime>(json['slotStart']),
      slotEnd: serializer.fromJson<DateTime>(json['slotEnd']),
      visitType: serializer.fromJson<String>(json['visitType']),
      status: $AppointmentsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      reasonText: serializer.fromJson<String>(json['reasonText']),
      bookedAt: serializer.fromJson<DateTime>(json['bookedAt']),
      noShowRisk: serializer.fromJson<double?>(json['noShowRisk']),
      riskBand: $AppointmentsTable.$converterriskBandn
          .fromJson(serializer.fromJson<String?>(json['riskBand'])),
      remindersSent: serializer.fromJson<int>(json['remindersSent']),
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'staffId': serializer.toJson<int>(staffId),
      'departmentId': serializer.toJson<int>(departmentId),
      'slotStart': serializer.toJson<DateTime>(slotStart),
      'slotEnd': serializer.toJson<DateTime>(slotEnd),
      'visitType': serializer.toJson<String>(visitType),
      'status': serializer
          .toJson<String>($AppointmentsTable.$converterstatus.toJson(status)),
      'reasonText': serializer.toJson<String>(reasonText),
      'bookedAt': serializer.toJson<DateTime>(bookedAt),
      'noShowRisk': serializer.toJson<double?>(noShowRisk),
      'riskBand': serializer.toJson<String?>(
          $AppointmentsTable.$converterriskBandn.toJson(riskBand)),
      'remindersSent': serializer.toJson<int>(remindersSent),
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
    };
  }

  Appointment copyWith(
          {int? id,
          int? patientId,
          int? staffId,
          int? departmentId,
          DateTime? slotStart,
          DateTime? slotEnd,
          String? visitType,
          AppointmentStatus? status,
          String? reasonText,
          DateTime? bookedAt,
          Value<double?> noShowRisk = const Value.absent(),
          Value<RiskBand?> riskBand = const Value.absent(),
          int? remindersSent,
          Value<DateTime?> checkedInAt = const Value.absent()}) =>
      Appointment(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        staffId: staffId ?? this.staffId,
        departmentId: departmentId ?? this.departmentId,
        slotStart: slotStart ?? this.slotStart,
        slotEnd: slotEnd ?? this.slotEnd,
        visitType: visitType ?? this.visitType,
        status: status ?? this.status,
        reasonText: reasonText ?? this.reasonText,
        bookedAt: bookedAt ?? this.bookedAt,
        noShowRisk: noShowRisk.present ? noShowRisk.value : this.noShowRisk,
        riskBand: riskBand.present ? riskBand.value : this.riskBand,
        remindersSent: remindersSent ?? this.remindersSent,
        checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
      );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      slotStart: data.slotStart.present ? data.slotStart.value : this.slotStart,
      slotEnd: data.slotEnd.present ? data.slotEnd.value : this.slotEnd,
      visitType: data.visitType.present ? data.visitType.value : this.visitType,
      status: data.status.present ? data.status.value : this.status,
      reasonText:
          data.reasonText.present ? data.reasonText.value : this.reasonText,
      bookedAt: data.bookedAt.present ? data.bookedAt.value : this.bookedAt,
      noShowRisk:
          data.noShowRisk.present ? data.noShowRisk.value : this.noShowRisk,
      riskBand: data.riskBand.present ? data.riskBand.value : this.riskBand,
      remindersSent: data.remindersSent.present
          ? data.remindersSent.value
          : this.remindersSent,
      checkedInAt:
          data.checkedInAt.present ? data.checkedInAt.value : this.checkedInAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('staffId: $staffId, ')
          ..write('departmentId: $departmentId, ')
          ..write('slotStart: $slotStart, ')
          ..write('slotEnd: $slotEnd, ')
          ..write('visitType: $visitType, ')
          ..write('status: $status, ')
          ..write('reasonText: $reasonText, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('noShowRisk: $noShowRisk, ')
          ..write('riskBand: $riskBand, ')
          ..write('remindersSent: $remindersSent, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      staffId,
      departmentId,
      slotStart,
      slotEnd,
      visitType,
      status,
      reasonText,
      bookedAt,
      noShowRisk,
      riskBand,
      remindersSent,
      checkedInAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.staffId == this.staffId &&
          other.departmentId == this.departmentId &&
          other.slotStart == this.slotStart &&
          other.slotEnd == this.slotEnd &&
          other.visitType == this.visitType &&
          other.status == this.status &&
          other.reasonText == this.reasonText &&
          other.bookedAt == this.bookedAt &&
          other.noShowRisk == this.noShowRisk &&
          other.riskBand == this.riskBand &&
          other.remindersSent == this.remindersSent &&
          other.checkedInAt == this.checkedInAt);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<int> staffId;
  final Value<int> departmentId;
  final Value<DateTime> slotStart;
  final Value<DateTime> slotEnd;
  final Value<String> visitType;
  final Value<AppointmentStatus> status;
  final Value<String> reasonText;
  final Value<DateTime> bookedAt;
  final Value<double?> noShowRisk;
  final Value<RiskBand?> riskBand;
  final Value<int> remindersSent;
  final Value<DateTime?> checkedInAt;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.staffId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.slotStart = const Value.absent(),
    this.slotEnd = const Value.absent(),
    this.visitType = const Value.absent(),
    this.status = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.bookedAt = const Value.absent(),
    this.noShowRisk = const Value.absent(),
    this.riskBand = const Value.absent(),
    this.remindersSent = const Value.absent(),
    this.checkedInAt = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required int staffId,
    required int departmentId,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String visitType,
    this.status = const Value.absent(),
    required String reasonText,
    this.bookedAt = const Value.absent(),
    this.noShowRisk = const Value.absent(),
    this.riskBand = const Value.absent(),
    this.remindersSent = const Value.absent(),
    this.checkedInAt = const Value.absent(),
  })  : patientId = Value(patientId),
        staffId = Value(staffId),
        departmentId = Value(departmentId),
        slotStart = Value(slotStart),
        slotEnd = Value(slotEnd),
        visitType = Value(visitType),
        reasonText = Value(reasonText);
  static Insertable<Appointment> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<int>? staffId,
    Expression<int>? departmentId,
    Expression<DateTime>? slotStart,
    Expression<DateTime>? slotEnd,
    Expression<String>? visitType,
    Expression<String>? status,
    Expression<String>? reasonText,
    Expression<DateTime>? bookedAt,
    Expression<double>? noShowRisk,
    Expression<String>? riskBand,
    Expression<int>? remindersSent,
    Expression<DateTime>? checkedInAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (staffId != null) 'staff_id': staffId,
      if (departmentId != null) 'department_id': departmentId,
      if (slotStart != null) 'slot_start': slotStart,
      if (slotEnd != null) 'slot_end': slotEnd,
      if (visitType != null) 'visit_type': visitType,
      if (status != null) 'status': status,
      if (reasonText != null) 'reason_text': reasonText,
      if (bookedAt != null) 'booked_at': bookedAt,
      if (noShowRisk != null) 'no_show_risk': noShowRisk,
      if (riskBand != null) 'risk_band': riskBand,
      if (remindersSent != null) 'reminders_sent': remindersSent,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
    });
  }

  AppointmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<int>? staffId,
      Value<int>? departmentId,
      Value<DateTime>? slotStart,
      Value<DateTime>? slotEnd,
      Value<String>? visitType,
      Value<AppointmentStatus>? status,
      Value<String>? reasonText,
      Value<DateTime>? bookedAt,
      Value<double?>? noShowRisk,
      Value<RiskBand?>? riskBand,
      Value<int>? remindersSent,
      Value<DateTime?>? checkedInAt}) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      staffId: staffId ?? this.staffId,
      departmentId: departmentId ?? this.departmentId,
      slotStart: slotStart ?? this.slotStart,
      slotEnd: slotEnd ?? this.slotEnd,
      visitType: visitType ?? this.visitType,
      status: status ?? this.status,
      reasonText: reasonText ?? this.reasonText,
      bookedAt: bookedAt ?? this.bookedAt,
      noShowRisk: noShowRisk ?? this.noShowRisk,
      riskBand: riskBand ?? this.riskBand,
      remindersSent: remindersSent ?? this.remindersSent,
      checkedInAt: checkedInAt ?? this.checkedInAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<int>(departmentId.value);
    }
    if (slotStart.present) {
      map['slot_start'] = Variable<DateTime>(slotStart.value);
    }
    if (slotEnd.present) {
      map['slot_end'] = Variable<DateTime>(slotEnd.value);
    }
    if (visitType.present) {
      map['visit_type'] = Variable<String>(visitType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $AppointmentsTable.$converterstatus.toSql(status.value));
    }
    if (reasonText.present) {
      map['reason_text'] = Variable<String>(reasonText.value);
    }
    if (bookedAt.present) {
      map['booked_at'] = Variable<DateTime>(bookedAt.value);
    }
    if (noShowRisk.present) {
      map['no_show_risk'] = Variable<double>(noShowRisk.value);
    }
    if (riskBand.present) {
      map['risk_band'] = Variable<String>(
          $AppointmentsTable.$converterriskBandn.toSql(riskBand.value));
    }
    if (remindersSent.present) {
      map['reminders_sent'] = Variable<int>(remindersSent.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('staffId: $staffId, ')
          ..write('departmentId: $departmentId, ')
          ..write('slotStart: $slotStart, ')
          ..write('slotEnd: $slotEnd, ')
          ..write('visitType: $visitType, ')
          ..write('status: $status, ')
          ..write('reasonText: $reasonText, ')
          ..write('bookedAt: $bookedAt, ')
          ..write('noShowRisk: $noShowRisk, ')
          ..write('riskBand: $riskBand, ')
          ..write('remindersSent: $remindersSent, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }
}

class $ScheduleTemplatesTable extends ScheduleTemplates
    with TableInfo<$ScheduleTemplatesTable, ScheduleTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _weekdayMeta =
      const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
      'weekday', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slotMinutesMeta =
      const VerificationMeta('slotMinutes');
  @override
  late final GeneratedColumn<int> slotMinutes = GeneratedColumn<int>(
      'slot_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  @override
  List<GeneratedColumn> get $columns =>
      [id, staffId, weekday, startTime, endTime, slotMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_templates';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('slot_minutes')) {
      context.handle(
          _slotMinutesMeta,
          slotMinutes.isAcceptableOrUnknown(
              data['slot_minutes']!, _slotMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}staff_id'])!,
      weekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!,
      slotMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_minutes'])!,
    );
  }

  @override
  $ScheduleTemplatesTable createAlias(String alias) {
    return $ScheduleTemplatesTable(attachedDatabase, alias);
  }
}

class ScheduleTemplate extends DataClass
    implements Insertable<ScheduleTemplate> {
  final int id;
  final int staffId;
  final int weekday;
  final String startTime;
  final String endTime;
  final int slotMinutes;
  const ScheduleTemplate(
      {required this.id,
      required this.staffId,
      required this.weekday,
      required this.startTime,
      required this.endTime,
      required this.slotMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    map['weekday'] = Variable<int>(weekday);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['slot_minutes'] = Variable<int>(slotMinutes);
    return map;
  }

  ScheduleTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleTemplatesCompanion(
      id: Value(id),
      staffId: Value(staffId),
      weekday: Value(weekday),
      startTime: Value(startTime),
      endTime: Value(endTime),
      slotMinutes: Value(slotMinutes),
    );
  }

  factory ScheduleTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleTemplate(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      slotMinutes: serializer.fromJson<int>(json['slotMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'weekday': serializer.toJson<int>(weekday),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'slotMinutes': serializer.toJson<int>(slotMinutes),
    };
  }

  ScheduleTemplate copyWith(
          {int? id,
          int? staffId,
          int? weekday,
          String? startTime,
          String? endTime,
          int? slotMinutes}) =>
      ScheduleTemplate(
        id: id ?? this.id,
        staffId: staffId ?? this.staffId,
        weekday: weekday ?? this.weekday,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        slotMinutes: slotMinutes ?? this.slotMinutes,
      );
  ScheduleTemplate copyWithCompanion(ScheduleTemplatesCompanion data) {
    return ScheduleTemplate(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      slotMinutes:
          data.slotMinutes.present ? data.slotMinutes.value : this.slotMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTemplate(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('slotMinutes: $slotMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, staffId, weekday, startTime, endTime, slotMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleTemplate &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.weekday == this.weekday &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.slotMinutes == this.slotMinutes);
}

class ScheduleTemplatesCompanion extends UpdateCompanion<ScheduleTemplate> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<int> weekday;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<int> slotMinutes;
  const ScheduleTemplatesCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.slotMinutes = const Value.absent(),
  });
  ScheduleTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    required int weekday,
    required String startTime,
    required String endTime,
    this.slotMinutes = const Value.absent(),
  })  : staffId = Value(staffId),
        weekday = Value(weekday),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<ScheduleTemplate> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<int>? weekday,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<int>? slotMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (weekday != null) 'weekday': weekday,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (slotMinutes != null) 'slot_minutes': slotMinutes,
    });
  }

  ScheduleTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? staffId,
      Value<int>? weekday,
      Value<String>? startTime,
      Value<String>? endTime,
      Value<int>? slotMinutes}) {
    return ScheduleTemplatesCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotMinutes: slotMinutes ?? this.slotMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (slotMinutes.present) {
      map['slot_minutes'] = Variable<int>(slotMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('slotMinutes: $slotMinutes')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
      'appointment_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES appointments (id) ON DELETE CASCADE'));
  static const VerificationMeta _scheduledForMeta =
      const VerificationMeta('scheduledFor');
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
      'scheduled_for', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ReminderChannel, String> channel =
      GeneratedColumn<String>('channel', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ReminderChannel>($RemindersTable.$converterchannel);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<ReminderKind, String> kind =
      GeneratedColumn<String>('kind', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ReminderKind>($RemindersTable.$converterkind);
  @override
  List<GeneratedColumn> get $columns =>
      [id, appointmentId, scheduledFor, channel, sentAt, kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
          _scheduledForMeta,
          scheduledFor.isAcceptableOrUnknown(
              data['scheduled_for']!, _scheduledForMeta));
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}appointment_id'])!,
      scheduledFor: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_for'])!,
      channel: $RemindersTable.$converterchannel.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!),
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at']),
      kind: $RemindersTable.$converterkind.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderChannel, String, String> $converterchannel =
      const EnumNameConverter<ReminderChannel>(ReminderChannel.values);
  static JsonTypeConverter2<ReminderKind, String, String> $converterkind =
      const EnumNameConverter<ReminderKind>(ReminderKind.values);
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int appointmentId;
  final DateTime scheduledFor;
  final ReminderChannel channel;
  final DateTime? sentAt;
  final ReminderKind kind;
  const Reminder(
      {required this.id,
      required this.appointmentId,
      required this.scheduledFor,
      required this.channel,
      this.sentAt,
      required this.kind});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['appointment_id'] = Variable<int>(appointmentId);
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    {
      map['channel'] =
          Variable<String>($RemindersTable.$converterchannel.toSql(channel));
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    {
      map['kind'] =
          Variable<String>($RemindersTable.$converterkind.toSql(kind));
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      appointmentId: Value(appointmentId),
      scheduledFor: Value(scheduledFor),
      channel: Value(channel),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
      kind: Value(kind),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      appointmentId: serializer.fromJson<int>(json['appointmentId']),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
      channel: $RemindersTable.$converterchannel
          .fromJson(serializer.fromJson<String>(json['channel'])),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      kind: $RemindersTable.$converterkind
          .fromJson(serializer.fromJson<String>(json['kind'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appointmentId': serializer.toJson<int>(appointmentId),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
      'channel': serializer
          .toJson<String>($RemindersTable.$converterchannel.toJson(channel)),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'kind': serializer
          .toJson<String>($RemindersTable.$converterkind.toJson(kind)),
    };
  }

  Reminder copyWith(
          {int? id,
          int? appointmentId,
          DateTime? scheduledFor,
          ReminderChannel? channel,
          Value<DateTime?> sentAt = const Value.absent(),
          ReminderKind? kind}) =>
      Reminder(
        id: id ?? this.id,
        appointmentId: appointmentId ?? this.appointmentId,
        scheduledFor: scheduledFor ?? this.scheduledFor,
        channel: channel ?? this.channel,
        sentAt: sentAt.present ? sentAt.value : this.sentAt,
        kind: kind ?? this.kind,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      channel: data.channel.present ? data.channel.value : this.channel,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('channel: $channel, ')
          ..write('sentAt: $sentAt, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appointmentId, scheduledFor, channel, sentAt, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.appointmentId == this.appointmentId &&
          other.scheduledFor == this.scheduledFor &&
          other.channel == this.channel &&
          other.sentAt == this.sentAt &&
          other.kind == this.kind);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> appointmentId;
  final Value<DateTime> scheduledFor;
  final Value<ReminderChannel> channel;
  final Value<DateTime?> sentAt;
  final Value<ReminderKind> kind;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.channel = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.kind = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int appointmentId,
    required DateTime scheduledFor,
    required ReminderChannel channel,
    this.sentAt = const Value.absent(),
    required ReminderKind kind,
  })  : appointmentId = Value(appointmentId),
        scheduledFor = Value(scheduledFor),
        channel = Value(channel),
        kind = Value(kind);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? appointmentId,
    Expression<DateTime>? scheduledFor,
    Expression<String>? channel,
    Expression<DateTime>? sentAt,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (channel != null) 'channel': channel,
      if (sentAt != null) 'sent_at': sentAt,
      if (kind != null) 'kind': kind,
    });
  }

  RemindersCompanion copyWith(
      {Value<int>? id,
      Value<int>? appointmentId,
      Value<DateTime>? scheduledFor,
      Value<ReminderChannel>? channel,
      Value<DateTime?>? sentAt,
      Value<ReminderKind>? kind}) {
    return RemindersCompanion(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      channel: channel ?? this.channel,
      sentAt: sentAt ?? this.sentAt,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(
          $RemindersTable.$converterchannel.toSql(channel.value));
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (kind.present) {
      map['kind'] =
          Variable<String>($RemindersTable.$converterkind.toSql(kind.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('channel: $channel, ')
          ..write('sentAt: $sentAt, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $MedicalRecordsTable extends MedicalRecords
    with TableInfo<$MedicalRecordsTable, MedicalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _authorStaffIdMeta =
      const VerificationMeta('authorStaffId');
  @override
  late final GeneratedColumn<int> authorStaffId = GeneratedColumn<int>(
      'author_staff_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  late final GeneratedColumnWithTypeConverter<RecordType, String> recordType =
      GeneratedColumn<String>('record_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RecordType>($MedicalRecordsTable.$converterrecordType);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceFacilityMeta =
      const VerificationMeta('sourceFacility');
  @override
  late final GeneratedColumn<String> sourceFacility = GeneratedColumn<String>(
      'source_facility', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _attachmentPathMeta =
      const VerificationMeta('attachmentPath');
  @override
  late final GeneratedColumn<String> attachmentPath = GeneratedColumn<String>(
      'attachment_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extractedTextMeta =
      const VerificationMeta('extractedText');
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
      'extracted_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        authorStaffId,
        recordType,
        title,
        body,
        occurredAt,
        sourceFacility,
        attachmentPath,
        extractedText,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_records';
  @override
  VerificationContext validateIntegrity(Insertable<MedicalRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('author_staff_id')) {
      context.handle(
          _authorStaffIdMeta,
          authorStaffId.isAcceptableOrUnknown(
              data['author_staff_id']!, _authorStaffIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('source_facility')) {
      context.handle(
          _sourceFacilityMeta,
          sourceFacility.isAcceptableOrUnknown(
              data['source_facility']!, _sourceFacilityMeta));
    } else if (isInserting) {
      context.missing(_sourceFacilityMeta);
    }
    if (data.containsKey('attachment_path')) {
      context.handle(
          _attachmentPathMeta,
          attachmentPath.isAcceptableOrUnknown(
              data['attachment_path']!, _attachmentPathMeta));
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
          _extractedTextMeta,
          extractedText.isAcceptableOrUnknown(
              data['extracted_text']!, _extractedTextMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      authorStaffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}author_staff_id']),
      recordType: $MedicalRecordsTable.$converterrecordType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}record_type'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      sourceFacility: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_facility'])!,
      attachmentPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachment_path']),
      extractedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extracted_text']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MedicalRecordsTable createAlias(String alias) {
    return $MedicalRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecordType, String, String> $converterrecordType =
      const EnumNameConverter<RecordType>(RecordType.values);
}

class MedicalRecord extends DataClass implements Insertable<MedicalRecord> {
  final int id;
  final int patientId;
  final int? authorStaffId;
  final RecordType recordType;
  final String title;
  final String body;
  final DateTime occurredAt;
  final String sourceFacility;
  final String? attachmentPath;
  final String? extractedText;
  final DateTime createdAt;
  const MedicalRecord(
      {required this.id,
      required this.patientId,
      this.authorStaffId,
      required this.recordType,
      required this.title,
      required this.body,
      required this.occurredAt,
      required this.sourceFacility,
      this.attachmentPath,
      this.extractedText,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    if (!nullToAbsent || authorStaffId != null) {
      map['author_staff_id'] = Variable<int>(authorStaffId);
    }
    {
      map['record_type'] = Variable<String>(
          $MedicalRecordsTable.$converterrecordType.toSql(recordType));
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['source_facility'] = Variable<String>(sourceFacility);
    if (!nullToAbsent || attachmentPath != null) {
      map['attachment_path'] = Variable<String>(attachmentPath);
    }
    if (!nullToAbsent || extractedText != null) {
      map['extracted_text'] = Variable<String>(extractedText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicalRecordsCompanion toCompanion(bool nullToAbsent) {
    return MedicalRecordsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      authorStaffId: authorStaffId == null && nullToAbsent
          ? const Value.absent()
          : Value(authorStaffId),
      recordType: Value(recordType),
      title: Value(title),
      body: Value(body),
      occurredAt: Value(occurredAt),
      sourceFacility: Value(sourceFacility),
      attachmentPath: attachmentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentPath),
      extractedText: extractedText == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedText),
      createdAt: Value(createdAt),
    );
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalRecord(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      authorStaffId: serializer.fromJson<int?>(json['authorStaffId']),
      recordType: $MedicalRecordsTable.$converterrecordType
          .fromJson(serializer.fromJson<String>(json['recordType'])),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      sourceFacility: serializer.fromJson<String>(json['sourceFacility']),
      attachmentPath: serializer.fromJson<String?>(json['attachmentPath']),
      extractedText: serializer.fromJson<String?>(json['extractedText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'authorStaffId': serializer.toJson<int?>(authorStaffId),
      'recordType': serializer.toJson<String>(
          $MedicalRecordsTable.$converterrecordType.toJson(recordType)),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'sourceFacility': serializer.toJson<String>(sourceFacility),
      'attachmentPath': serializer.toJson<String?>(attachmentPath),
      'extractedText': serializer.toJson<String?>(extractedText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicalRecord copyWith(
          {int? id,
          int? patientId,
          Value<int?> authorStaffId = const Value.absent(),
          RecordType? recordType,
          String? title,
          String? body,
          DateTime? occurredAt,
          String? sourceFacility,
          Value<String?> attachmentPath = const Value.absent(),
          Value<String?> extractedText = const Value.absent(),
          DateTime? createdAt}) =>
      MedicalRecord(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        authorStaffId:
            authorStaffId.present ? authorStaffId.value : this.authorStaffId,
        recordType: recordType ?? this.recordType,
        title: title ?? this.title,
        body: body ?? this.body,
        occurredAt: occurredAt ?? this.occurredAt,
        sourceFacility: sourceFacility ?? this.sourceFacility,
        attachmentPath:
            attachmentPath.present ? attachmentPath.value : this.attachmentPath,
        extractedText:
            extractedText.present ? extractedText.value : this.extractedText,
        createdAt: createdAt ?? this.createdAt,
      );
  MedicalRecord copyWithCompanion(MedicalRecordsCompanion data) {
    return MedicalRecord(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      authorStaffId: data.authorStaffId.present
          ? data.authorStaffId.value
          : this.authorStaffId,
      recordType:
          data.recordType.present ? data.recordType.value : this.recordType,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      sourceFacility: data.sourceFacility.present
          ? data.sourceFacility.value
          : this.sourceFacility,
      attachmentPath: data.attachmentPath.present
          ? data.attachmentPath.value
          : this.attachmentPath,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecord(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('authorStaffId: $authorStaffId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sourceFacility: $sourceFacility, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      authorStaffId,
      recordType,
      title,
      body,
      occurredAt,
      sourceFacility,
      attachmentPath,
      extractedText,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalRecord &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.authorStaffId == this.authorStaffId &&
          other.recordType == this.recordType &&
          other.title == this.title &&
          other.body == this.body &&
          other.occurredAt == this.occurredAt &&
          other.sourceFacility == this.sourceFacility &&
          other.attachmentPath == this.attachmentPath &&
          other.extractedText == this.extractedText &&
          other.createdAt == this.createdAt);
}

class MedicalRecordsCompanion extends UpdateCompanion<MedicalRecord> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<int?> authorStaffId;
  final Value<RecordType> recordType;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> occurredAt;
  final Value<String> sourceFacility;
  final Value<String?> attachmentPath;
  final Value<String?> extractedText;
  final Value<DateTime> createdAt;
  const MedicalRecordsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.authorStaffId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.sourceFacility = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    this.authorStaffId = const Value.absent(),
    required RecordType recordType,
    required String title,
    required String body,
    required DateTime occurredAt,
    required String sourceFacility,
    this.attachmentPath = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : patientId = Value(patientId),
        recordType = Value(recordType),
        title = Value(title),
        body = Value(body),
        occurredAt = Value(occurredAt),
        sourceFacility = Value(sourceFacility);
  static Insertable<MedicalRecord> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<int>? authorStaffId,
    Expression<String>? recordType,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? occurredAt,
    Expression<String>? sourceFacility,
    Expression<String>? attachmentPath,
    Expression<String>? extractedText,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (authorStaffId != null) 'author_staff_id': authorStaffId,
      if (recordType != null) 'record_type': recordType,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (sourceFacility != null) 'source_facility': sourceFacility,
      if (attachmentPath != null) 'attachment_path': attachmentPath,
      if (extractedText != null) 'extracted_text': extractedText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicalRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<int?>? authorStaffId,
      Value<RecordType>? recordType,
      Value<String>? title,
      Value<String>? body,
      Value<DateTime>? occurredAt,
      Value<String>? sourceFacility,
      Value<String?>? attachmentPath,
      Value<String?>? extractedText,
      Value<DateTime>? createdAt}) {
    return MedicalRecordsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      authorStaffId: authorStaffId ?? this.authorStaffId,
      recordType: recordType ?? this.recordType,
      title: title ?? this.title,
      body: body ?? this.body,
      occurredAt: occurredAt ?? this.occurredAt,
      sourceFacility: sourceFacility ?? this.sourceFacility,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (authorStaffId.present) {
      map['author_staff_id'] = Variable<int>(authorStaffId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(
          $MedicalRecordsTable.$converterrecordType.toSql(recordType.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (sourceFacility.present) {
      map['source_facility'] = Variable<String>(sourceFacility.value);
    }
    if (attachmentPath.present) {
      map['attachment_path'] = Variable<String>(attachmentPath.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('authorStaffId: $authorStaffId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sourceFacility: $sourceFacility, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('extractedText: $extractedText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LabValuesTable extends LabValues
    with TableInfo<$LabValuesTable, LabValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medical_records (id) ON DELETE CASCADE'));
  static const VerificationMeta _analyteMeta =
      const VerificationMeta('analyte');
  @override
  late final GeneratedColumn<String> analyte = GeneratedColumn<String>(
      'analyte', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _refLowMeta = const VerificationMeta('refLow');
  @override
  late final GeneratedColumn<double> refLow = GeneratedColumn<double>(
      'ref_low', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _refHighMeta =
      const VerificationMeta('refHigh');
  @override
  late final GeneratedColumn<double> refHigh = GeneratedColumn<double>(
      'ref_high', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _abnormalFlagMeta =
      const VerificationMeta('abnormalFlag');
  @override
  late final GeneratedColumn<bool> abnormalFlag = GeneratedColumn<bool>(
      'abnormal_flag', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("abnormal_flag" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordId, analyte, value, unit, refLow, refHigh, abnormalFlag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_values';
  @override
  VerificationContext validateIntegrity(Insertable<LabValue> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('analyte')) {
      context.handle(_analyteMeta,
          analyte.isAcceptableOrUnknown(data['analyte']!, _analyteMeta));
    } else if (isInserting) {
      context.missing(_analyteMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('ref_low')) {
      context.handle(_refLowMeta,
          refLow.isAcceptableOrUnknown(data['ref_low']!, _refLowMeta));
    } else if (isInserting) {
      context.missing(_refLowMeta);
    }
    if (data.containsKey('ref_high')) {
      context.handle(_refHighMeta,
          refHigh.isAcceptableOrUnknown(data['ref_high']!, _refHighMeta));
    } else if (isInserting) {
      context.missing(_refHighMeta);
    }
    if (data.containsKey('abnormal_flag')) {
      context.handle(
          _abnormalFlagMeta,
          abnormalFlag.isAcceptableOrUnknown(
              data['abnormal_flag']!, _abnormalFlagMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabValue(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id'])!,
      analyte: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}analyte'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      refLow: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ref_low'])!,
      refHigh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ref_high'])!,
      abnormalFlag: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}abnormal_flag'])!,
    );
  }

  @override
  $LabValuesTable createAlias(String alias) {
    return $LabValuesTable(attachedDatabase, alias);
  }
}

class LabValue extends DataClass implements Insertable<LabValue> {
  final int id;
  final int recordId;
  final String analyte;
  final double value;
  final String unit;
  final double refLow;
  final double refHigh;
  final bool abnormalFlag;
  const LabValue(
      {required this.id,
      required this.recordId,
      required this.analyte,
      required this.value,
      required this.unit,
      required this.refLow,
      required this.refHigh,
      required this.abnormalFlag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    map['analyte'] = Variable<String>(analyte);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['ref_low'] = Variable<double>(refLow);
    map['ref_high'] = Variable<double>(refHigh);
    map['abnormal_flag'] = Variable<bool>(abnormalFlag);
    return map;
  }

  LabValuesCompanion toCompanion(bool nullToAbsent) {
    return LabValuesCompanion(
      id: Value(id),
      recordId: Value(recordId),
      analyte: Value(analyte),
      value: Value(value),
      unit: Value(unit),
      refLow: Value(refLow),
      refHigh: Value(refHigh),
      abnormalFlag: Value(abnormalFlag),
    );
  }

  factory LabValue.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabValue(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      analyte: serializer.fromJson<String>(json['analyte']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      refLow: serializer.fromJson<double>(json['refLow']),
      refHigh: serializer.fromJson<double>(json['refHigh']),
      abnormalFlag: serializer.fromJson<bool>(json['abnormalFlag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'analyte': serializer.toJson<String>(analyte),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'refLow': serializer.toJson<double>(refLow),
      'refHigh': serializer.toJson<double>(refHigh),
      'abnormalFlag': serializer.toJson<bool>(abnormalFlag),
    };
  }

  LabValue copyWith(
          {int? id,
          int? recordId,
          String? analyte,
          double? value,
          String? unit,
          double? refLow,
          double? refHigh,
          bool? abnormalFlag}) =>
      LabValue(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        analyte: analyte ?? this.analyte,
        value: value ?? this.value,
        unit: unit ?? this.unit,
        refLow: refLow ?? this.refLow,
        refHigh: refHigh ?? this.refHigh,
        abnormalFlag: abnormalFlag ?? this.abnormalFlag,
      );
  LabValue copyWithCompanion(LabValuesCompanion data) {
    return LabValue(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      analyte: data.analyte.present ? data.analyte.value : this.analyte,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      refLow: data.refLow.present ? data.refLow.value : this.refLow,
      refHigh: data.refHigh.present ? data.refHigh.value : this.refHigh,
      abnormalFlag: data.abnormalFlag.present
          ? data.abnormalFlag.value
          : this.abnormalFlag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabValue(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('analyte: $analyte, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('abnormalFlag: $abnormalFlag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, recordId, analyte, value, unit, refLow, refHigh, abnormalFlag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabValue &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.analyte == this.analyte &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.refLow == this.refLow &&
          other.refHigh == this.refHigh &&
          other.abnormalFlag == this.abnormalFlag);
}

class LabValuesCompanion extends UpdateCompanion<LabValue> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<String> analyte;
  final Value<double> value;
  final Value<String> unit;
  final Value<double> refLow;
  final Value<double> refHigh;
  final Value<bool> abnormalFlag;
  const LabValuesCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.analyte = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.refLow = const Value.absent(),
    this.refHigh = const Value.absent(),
    this.abnormalFlag = const Value.absent(),
  });
  LabValuesCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required String analyte,
    required double value,
    required String unit,
    required double refLow,
    required double refHigh,
    this.abnormalFlag = const Value.absent(),
  })  : recordId = Value(recordId),
        analyte = Value(analyte),
        value = Value(value),
        unit = Value(unit),
        refLow = Value(refLow),
        refHigh = Value(refHigh);
  static Insertable<LabValue> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<String>? analyte,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<double>? refLow,
    Expression<double>? refHigh,
    Expression<bool>? abnormalFlag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (analyte != null) 'analyte': analyte,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (refLow != null) 'ref_low': refLow,
      if (refHigh != null) 'ref_high': refHigh,
      if (abnormalFlag != null) 'abnormal_flag': abnormalFlag,
    });
  }

  LabValuesCompanion copyWith(
      {Value<int>? id,
      Value<int>? recordId,
      Value<String>? analyte,
      Value<double>? value,
      Value<String>? unit,
      Value<double>? refLow,
      Value<double>? refHigh,
      Value<bool>? abnormalFlag}) {
    return LabValuesCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      analyte: analyte ?? this.analyte,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      refLow: refLow ?? this.refLow,
      refHigh: refHigh ?? this.refHigh,
      abnormalFlag: abnormalFlag ?? this.abnormalFlag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (analyte.present) {
      map['analyte'] = Variable<String>(analyte.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (refLow.present) {
      map['ref_low'] = Variable<double>(refLow.value);
    }
    if (refHigh.present) {
      map['ref_high'] = Variable<double>(refHigh.value);
    }
    if (abnormalFlag.present) {
      map['abnormal_flag'] = Variable<bool>(abnormalFlag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabValuesCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('analyte: $analyte, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('abnormalFlag: $abnormalFlag')
          ..write(')'))
        .toString();
  }
}

class $VitalsTable extends Vitals with TableInfo<$VitalsTable, Vital> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _systolicMeta =
      const VerificationMeta('systolic');
  @override
  late final GeneratedColumn<double> systolic = GeneratedColumn<double>(
      'systolic', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _diastolicMeta =
      const VerificationMeta('diastolic');
  @override
  late final GeneratedColumn<double> diastolic = GeneratedColumn<double>(
      'diastolic', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heartRateMeta =
      const VerificationMeta('heartRate');
  @override
  late final GeneratedColumn<double> heartRate = GeneratedColumn<double>(
      'heart_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tempCMeta = const VerificationMeta('tempC');
  @override
  late final GeneratedColumn<double> tempC = GeneratedColumn<double>(
      'temp_c', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<double> spo2 = GeneratedColumn<double>(
      'spo2', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _glucoseMeta =
      const VerificationMeta('glucose');
  @override
  late final GeneratedColumn<double> glucose = GeneratedColumn<double>(
      'glucose', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        recordedAt,
        systolic,
        diastolic,
        heartRate,
        tempC,
        weightKg,
        heightCm,
        spo2,
        glucose
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vitals';
  @override
  VerificationContext validateIntegrity(Insertable<Vital> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('systolic')) {
      context.handle(_systolicMeta,
          systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta));
    }
    if (data.containsKey('diastolic')) {
      context.handle(_diastolicMeta,
          diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta));
    }
    if (data.containsKey('heart_rate')) {
      context.handle(_heartRateMeta,
          heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta));
    }
    if (data.containsKey('temp_c')) {
      context.handle(
          _tempCMeta, tempC.isAcceptableOrUnknown(data['temp_c']!, _tempCMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    }
    if (data.containsKey('spo2')) {
      context.handle(
          _spo2Meta, spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta));
    }
    if (data.containsKey('glucose')) {
      context.handle(_glucoseMeta,
          glucose.isAcceptableOrUnknown(data['glucose']!, _glucoseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vital map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vital(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      systolic: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}systolic']),
      diastolic: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}diastolic']),
      heartRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}heart_rate']),
      tempC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_c']),
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg']),
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm']),
      spo2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}spo2']),
      glucose: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}glucose']),
    );
  }

  @override
  $VitalsTable createAlias(String alias) {
    return $VitalsTable(attachedDatabase, alias);
  }
}

class Vital extends DataClass implements Insertable<Vital> {
  final int id;
  final int patientId;
  final DateTime recordedAt;
  final double? systolic;
  final double? diastolic;
  final double? heartRate;
  final double? tempC;
  final double? weightKg;
  final double? heightCm;
  final double? spo2;
  final double? glucose;
  const Vital(
      {required this.id,
      required this.patientId,
      required this.recordedAt,
      this.systolic,
      this.diastolic,
      this.heartRate,
      this.tempC,
      this.weightKg,
      this.heightCm,
      this.spo2,
      this.glucose});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || systolic != null) {
      map['systolic'] = Variable<double>(systolic);
    }
    if (!nullToAbsent || diastolic != null) {
      map['diastolic'] = Variable<double>(diastolic);
    }
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<double>(heartRate);
    }
    if (!nullToAbsent || tempC != null) {
      map['temp_c'] = Variable<double>(tempC);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || spo2 != null) {
      map['spo2'] = Variable<double>(spo2);
    }
    if (!nullToAbsent || glucose != null) {
      map['glucose'] = Variable<double>(glucose);
    }
    return map;
  }

  VitalsCompanion toCompanion(bool nullToAbsent) {
    return VitalsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      recordedAt: Value(recordedAt),
      systolic: systolic == null && nullToAbsent
          ? const Value.absent()
          : Value(systolic),
      diastolic: diastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(diastolic),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      tempC:
          tempC == null && nullToAbsent ? const Value.absent() : Value(tempC),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      spo2: spo2 == null && nullToAbsent ? const Value.absent() : Value(spo2),
      glucose: glucose == null && nullToAbsent
          ? const Value.absent()
          : Value(glucose),
    );
  }

  factory Vital.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vital(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      systolic: serializer.fromJson<double?>(json['systolic']),
      diastolic: serializer.fromJson<double?>(json['diastolic']),
      heartRate: serializer.fromJson<double?>(json['heartRate']),
      tempC: serializer.fromJson<double?>(json['tempC']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      spo2: serializer.fromJson<double?>(json['spo2']),
      glucose: serializer.fromJson<double?>(json['glucose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'systolic': serializer.toJson<double?>(systolic),
      'diastolic': serializer.toJson<double?>(diastolic),
      'heartRate': serializer.toJson<double?>(heartRate),
      'tempC': serializer.toJson<double?>(tempC),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'spo2': serializer.toJson<double?>(spo2),
      'glucose': serializer.toJson<double?>(glucose),
    };
  }

  Vital copyWith(
          {int? id,
          int? patientId,
          DateTime? recordedAt,
          Value<double?> systolic = const Value.absent(),
          Value<double?> diastolic = const Value.absent(),
          Value<double?> heartRate = const Value.absent(),
          Value<double?> tempC = const Value.absent(),
          Value<double?> weightKg = const Value.absent(),
          Value<double?> heightCm = const Value.absent(),
          Value<double?> spo2 = const Value.absent(),
          Value<double?> glucose = const Value.absent()}) =>
      Vital(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        recordedAt: recordedAt ?? this.recordedAt,
        systolic: systolic.present ? systolic.value : this.systolic,
        diastolic: diastolic.present ? diastolic.value : this.diastolic,
        heartRate: heartRate.present ? heartRate.value : this.heartRate,
        tempC: tempC.present ? tempC.value : this.tempC,
        weightKg: weightKg.present ? weightKg.value : this.weightKg,
        heightCm: heightCm.present ? heightCm.value : this.heightCm,
        spo2: spo2.present ? spo2.value : this.spo2,
        glucose: glucose.present ? glucose.value : this.glucose,
      );
  Vital copyWithCompanion(VitalsCompanion data) {
    return Vital(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      tempC: data.tempC.present ? data.tempC.value : this.tempC,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      glucose: data.glucose.present ? data.glucose.value : this.glucose,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vital(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('tempC: $tempC, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('spo2: $spo2, ')
          ..write('glucose: $glucose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, recordedAt, systolic,
      diastolic, heartRate, tempC, weightKg, heightCm, spo2, glucose);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vital &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.recordedAt == this.recordedAt &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.heartRate == this.heartRate &&
          other.tempC == this.tempC &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.spo2 == this.spo2 &&
          other.glucose == this.glucose);
}

class VitalsCompanion extends UpdateCompanion<Vital> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<DateTime> recordedAt;
  final Value<double?> systolic;
  final Value<double?> diastolic;
  final Value<double?> heartRate;
  final Value<double?> tempC;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  final Value<double?> spo2;
  final Value<double?> glucose;
  const VitalsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.tempC = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.glucose = const Value.absent(),
  });
  VitalsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required DateTime recordedAt,
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.tempC = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.glucose = const Value.absent(),
  })  : patientId = Value(patientId),
        recordedAt = Value(recordedAt);
  static Insertable<Vital> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<DateTime>? recordedAt,
    Expression<double>? systolic,
    Expression<double>? diastolic,
    Expression<double>? heartRate,
    Expression<double>? tempC,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<double>? spo2,
    Expression<double>? glucose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (heartRate != null) 'heart_rate': heartRate,
      if (tempC != null) 'temp_c': tempC,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (spo2 != null) 'spo2': spo2,
      if (glucose != null) 'glucose': glucose,
    });
  }

  VitalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<DateTime>? recordedAt,
      Value<double?>? systolic,
      Value<double?>? diastolic,
      Value<double?>? heartRate,
      Value<double?>? tempC,
      Value<double?>? weightKg,
      Value<double?>? heightCm,
      Value<double?>? spo2,
      Value<double?>? glucose}) {
    return VitalsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      recordedAt: recordedAt ?? this.recordedAt,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      heartRate: heartRate ?? this.heartRate,
      tempC: tempC ?? this.tempC,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      spo2: spo2 ?? this.spo2,
      glucose: glucose ?? this.glucose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<double>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<double>(diastolic.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<double>(heartRate.value);
    }
    if (tempC.present) {
      map['temp_c'] = Variable<double>(tempC.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<double>(spo2.value);
    }
    if (glucose.present) {
      map['glucose'] = Variable<double>(glucose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('tempC: $tempC, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('spo2: $spo2, ')
          ..write('glucose: $glucose')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _prescriberIdMeta =
      const VerificationMeta('prescriberId');
  @override
  late final GeneratedColumn<int> prescriberId = GeneratedColumn<int>(
      'prescriber_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
      'dose', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        prescriberId,
        name,
        dose,
        frequency,
        startDate,
        endDate,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('prescriber_id')) {
      context.handle(
          _prescriberIdMeta,
          prescriberId.isAcceptableOrUnknown(
              data['prescriber_id']!, _prescriberIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      prescriberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prescriber_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final int patientId;
  final int? prescriberId;
  final String name;
  final String dose;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  const Medication(
      {required this.id,
      required this.patientId,
      this.prescriberId,
      required this.name,
      required this.dose,
      required this.frequency,
      required this.startDate,
      this.endDate,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    if (!nullToAbsent || prescriberId != null) {
      map['prescriber_id'] = Variable<int>(prescriberId);
    }
    map['name'] = Variable<String>(name);
    map['dose'] = Variable<String>(dose);
    map['frequency'] = Variable<String>(frequency);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      prescriberId: prescriberId == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriberId),
      name: Value(name),
      dose: Value(dose),
      frequency: Value(frequency),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      prescriberId: serializer.fromJson<int?>(json['prescriberId']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String>(json['dose']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'prescriberId': serializer.toJson<int?>(prescriberId),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String>(dose),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Medication copyWith(
          {int? id,
          int? patientId,
          Value<int?> prescriberId = const Value.absent(),
          String? name,
          String? dose,
          String? frequency,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? isActive}) =>
      Medication(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        prescriberId:
            prescriberId.present ? prescriberId.value : this.prescriberId,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        frequency: frequency ?? this.frequency,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        isActive: isActive ?? this.isActive,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      prescriberId: data.prescriberId.present
          ? data.prescriberId.value
          : this.prescriberId,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('prescriberId: $prescriberId, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, prescriberId, name, dose,
      frequency, startDate, endDate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.prescriberId == this.prescriberId &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<int?> prescriberId;
  final Value<String> name;
  final Value<String> dose;
  final Value<String> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.prescriberId = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    this.prescriberId = const Value.absent(),
    required String name,
    required String dose,
    required String frequency,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : patientId = Value(patientId),
        name = Value(name),
        dose = Value(dose),
        frequency = Value(frequency),
        startDate = Value(startDate);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<int>? prescriberId,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (prescriberId != null) 'prescriber_id': prescriberId,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MedicationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<int?>? prescriberId,
      Value<String>? name,
      Value<String>? dose,
      Value<String>? frequency,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? isActive}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      prescriberId: prescriberId ?? this.prescriberId,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (prescriberId.present) {
      map['prescriber_id'] = Variable<int>(prescriberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('prescriberId: $prescriberId, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AiSummariesTable extends AiSummaries
    with TableInfo<$AiSummariesTable, AiSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _modelIdMeta =
      const VerificationMeta('modelId');
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
      'model_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _promptVersionMeta =
      const VerificationMeta('promptVersion');
  @override
  late final GeneratedColumn<String> promptVersion = GeneratedColumn<String>(
      'prompt_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMarkdownMeta =
      const VerificationMeta('summaryMarkdown');
  @override
  late final GeneratedColumn<String> summaryMarkdown = GeneratedColumn<String>(
      'summary_markdown', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyEventsJsonMeta =
      const VerificationMeta('keyEventsJson');
  @override
  late final GeneratedColumn<String> keyEventsJson = GeneratedColumn<String>(
      'key_events_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trendsJsonMeta =
      const VerificationMeta('trendsJson');
  @override
  late final GeneratedColumn<String> trendsJson = GeneratedColumn<String>(
      'trends_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _redFlagsJsonMeta =
      const VerificationMeta('redFlagsJson');
  @override
  late final GeneratedColumn<String> redFlagsJson = GeneratedColumn<String>(
      'red_flags_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputHashMeta =
      const VerificationMeta('inputHash');
  @override
  late final GeneratedColumn<String> inputHash = GeneratedColumn<String>(
      'input_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        generatedAt,
        modelId,
        promptVersion,
        summaryMarkdown,
        keyEventsJson,
        trendsJson,
        redFlagsJson,
        inputHash
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<AiSummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    }
    if (data.containsKey('model_id')) {
      context.handle(_modelIdMeta,
          modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta));
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('prompt_version')) {
      context.handle(
          _promptVersionMeta,
          promptVersion.isAcceptableOrUnknown(
              data['prompt_version']!, _promptVersionMeta));
    } else if (isInserting) {
      context.missing(_promptVersionMeta);
    }
    if (data.containsKey('summary_markdown')) {
      context.handle(
          _summaryMarkdownMeta,
          summaryMarkdown.isAcceptableOrUnknown(
              data['summary_markdown']!, _summaryMarkdownMeta));
    } else if (isInserting) {
      context.missing(_summaryMarkdownMeta);
    }
    if (data.containsKey('key_events_json')) {
      context.handle(
          _keyEventsJsonMeta,
          keyEventsJson.isAcceptableOrUnknown(
              data['key_events_json']!, _keyEventsJsonMeta));
    } else if (isInserting) {
      context.missing(_keyEventsJsonMeta);
    }
    if (data.containsKey('trends_json')) {
      context.handle(
          _trendsJsonMeta,
          trendsJson.isAcceptableOrUnknown(
              data['trends_json']!, _trendsJsonMeta));
    } else if (isInserting) {
      context.missing(_trendsJsonMeta);
    }
    if (data.containsKey('red_flags_json')) {
      context.handle(
          _redFlagsJsonMeta,
          redFlagsJson.isAcceptableOrUnknown(
              data['red_flags_json']!, _redFlagsJsonMeta));
    } else if (isInserting) {
      context.missing(_redFlagsJsonMeta);
    }
    if (data.containsKey('input_hash')) {
      context.handle(_inputHashMeta,
          inputHash.isAcceptableOrUnknown(data['input_hash']!, _inputHashMeta));
    } else if (isInserting) {
      context.missing(_inputHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiSummary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      modelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_id'])!,
      promptVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prompt_version'])!,
      summaryMarkdown: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}summary_markdown'])!,
      keyEventsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}key_events_json'])!,
      trendsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trends_json'])!,
      redFlagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}red_flags_json'])!,
      inputHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_hash'])!,
    );
  }

  @override
  $AiSummariesTable createAlias(String alias) {
    return $AiSummariesTable(attachedDatabase, alias);
  }
}

class AiSummary extends DataClass implements Insertable<AiSummary> {
  final int id;
  final int patientId;
  final DateTime generatedAt;
  final String modelId;
  final String promptVersion;
  final String summaryMarkdown;
  final String keyEventsJson;
  final String trendsJson;
  final String redFlagsJson;
  final String inputHash;
  const AiSummary(
      {required this.id,
      required this.patientId,
      required this.generatedAt,
      required this.modelId,
      required this.promptVersion,
      required this.summaryMarkdown,
      required this.keyEventsJson,
      required this.trendsJson,
      required this.redFlagsJson,
      required this.inputHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['model_id'] = Variable<String>(modelId);
    map['prompt_version'] = Variable<String>(promptVersion);
    map['summary_markdown'] = Variable<String>(summaryMarkdown);
    map['key_events_json'] = Variable<String>(keyEventsJson);
    map['trends_json'] = Variable<String>(trendsJson);
    map['red_flags_json'] = Variable<String>(redFlagsJson);
    map['input_hash'] = Variable<String>(inputHash);
    return map;
  }

  AiSummariesCompanion toCompanion(bool nullToAbsent) {
    return AiSummariesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      generatedAt: Value(generatedAt),
      modelId: Value(modelId),
      promptVersion: Value(promptVersion),
      summaryMarkdown: Value(summaryMarkdown),
      keyEventsJson: Value(keyEventsJson),
      trendsJson: Value(trendsJson),
      redFlagsJson: Value(redFlagsJson),
      inputHash: Value(inputHash),
    );
  }

  factory AiSummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiSummary(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      modelId: serializer.fromJson<String>(json['modelId']),
      promptVersion: serializer.fromJson<String>(json['promptVersion']),
      summaryMarkdown: serializer.fromJson<String>(json['summaryMarkdown']),
      keyEventsJson: serializer.fromJson<String>(json['keyEventsJson']),
      trendsJson: serializer.fromJson<String>(json['trendsJson']),
      redFlagsJson: serializer.fromJson<String>(json['redFlagsJson']),
      inputHash: serializer.fromJson<String>(json['inputHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'modelId': serializer.toJson<String>(modelId),
      'promptVersion': serializer.toJson<String>(promptVersion),
      'summaryMarkdown': serializer.toJson<String>(summaryMarkdown),
      'keyEventsJson': serializer.toJson<String>(keyEventsJson),
      'trendsJson': serializer.toJson<String>(trendsJson),
      'redFlagsJson': serializer.toJson<String>(redFlagsJson),
      'inputHash': serializer.toJson<String>(inputHash),
    };
  }

  AiSummary copyWith(
          {int? id,
          int? patientId,
          DateTime? generatedAt,
          String? modelId,
          String? promptVersion,
          String? summaryMarkdown,
          String? keyEventsJson,
          String? trendsJson,
          String? redFlagsJson,
          String? inputHash}) =>
      AiSummary(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        generatedAt: generatedAt ?? this.generatedAt,
        modelId: modelId ?? this.modelId,
        promptVersion: promptVersion ?? this.promptVersion,
        summaryMarkdown: summaryMarkdown ?? this.summaryMarkdown,
        keyEventsJson: keyEventsJson ?? this.keyEventsJson,
        trendsJson: trendsJson ?? this.trendsJson,
        redFlagsJson: redFlagsJson ?? this.redFlagsJson,
        inputHash: inputHash ?? this.inputHash,
      );
  AiSummary copyWithCompanion(AiSummariesCompanion data) {
    return AiSummary(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      promptVersion: data.promptVersion.present
          ? data.promptVersion.value
          : this.promptVersion,
      summaryMarkdown: data.summaryMarkdown.present
          ? data.summaryMarkdown.value
          : this.summaryMarkdown,
      keyEventsJson: data.keyEventsJson.present
          ? data.keyEventsJson.value
          : this.keyEventsJson,
      trendsJson:
          data.trendsJson.present ? data.trendsJson.value : this.trendsJson,
      redFlagsJson: data.redFlagsJson.present
          ? data.redFlagsJson.value
          : this.redFlagsJson,
      inputHash: data.inputHash.present ? data.inputHash.value : this.inputHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiSummary(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('modelId: $modelId, ')
          ..write('promptVersion: $promptVersion, ')
          ..write('summaryMarkdown: $summaryMarkdown, ')
          ..write('keyEventsJson: $keyEventsJson, ')
          ..write('trendsJson: $trendsJson, ')
          ..write('redFlagsJson: $redFlagsJson, ')
          ..write('inputHash: $inputHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      generatedAt,
      modelId,
      promptVersion,
      summaryMarkdown,
      keyEventsJson,
      trendsJson,
      redFlagsJson,
      inputHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiSummary &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.generatedAt == this.generatedAt &&
          other.modelId == this.modelId &&
          other.promptVersion == this.promptVersion &&
          other.summaryMarkdown == this.summaryMarkdown &&
          other.keyEventsJson == this.keyEventsJson &&
          other.trendsJson == this.trendsJson &&
          other.redFlagsJson == this.redFlagsJson &&
          other.inputHash == this.inputHash);
}

class AiSummariesCompanion extends UpdateCompanion<AiSummary> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<DateTime> generatedAt;
  final Value<String> modelId;
  final Value<String> promptVersion;
  final Value<String> summaryMarkdown;
  final Value<String> keyEventsJson;
  final Value<String> trendsJson;
  final Value<String> redFlagsJson;
  final Value<String> inputHash;
  const AiSummariesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.modelId = const Value.absent(),
    this.promptVersion = const Value.absent(),
    this.summaryMarkdown = const Value.absent(),
    this.keyEventsJson = const Value.absent(),
    this.trendsJson = const Value.absent(),
    this.redFlagsJson = const Value.absent(),
    this.inputHash = const Value.absent(),
  });
  AiSummariesCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    this.generatedAt = const Value.absent(),
    required String modelId,
    required String promptVersion,
    required String summaryMarkdown,
    required String keyEventsJson,
    required String trendsJson,
    required String redFlagsJson,
    required String inputHash,
  })  : patientId = Value(patientId),
        modelId = Value(modelId),
        promptVersion = Value(promptVersion),
        summaryMarkdown = Value(summaryMarkdown),
        keyEventsJson = Value(keyEventsJson),
        trendsJson = Value(trendsJson),
        redFlagsJson = Value(redFlagsJson),
        inputHash = Value(inputHash);
  static Insertable<AiSummary> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<DateTime>? generatedAt,
    Expression<String>? modelId,
    Expression<String>? promptVersion,
    Expression<String>? summaryMarkdown,
    Expression<String>? keyEventsJson,
    Expression<String>? trendsJson,
    Expression<String>? redFlagsJson,
    Expression<String>? inputHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (modelId != null) 'model_id': modelId,
      if (promptVersion != null) 'prompt_version': promptVersion,
      if (summaryMarkdown != null) 'summary_markdown': summaryMarkdown,
      if (keyEventsJson != null) 'key_events_json': keyEventsJson,
      if (trendsJson != null) 'trends_json': trendsJson,
      if (redFlagsJson != null) 'red_flags_json': redFlagsJson,
      if (inputHash != null) 'input_hash': inputHash,
    });
  }

  AiSummariesCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<DateTime>? generatedAt,
      Value<String>? modelId,
      Value<String>? promptVersion,
      Value<String>? summaryMarkdown,
      Value<String>? keyEventsJson,
      Value<String>? trendsJson,
      Value<String>? redFlagsJson,
      Value<String>? inputHash}) {
    return AiSummariesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      generatedAt: generatedAt ?? this.generatedAt,
      modelId: modelId ?? this.modelId,
      promptVersion: promptVersion ?? this.promptVersion,
      summaryMarkdown: summaryMarkdown ?? this.summaryMarkdown,
      keyEventsJson: keyEventsJson ?? this.keyEventsJson,
      trendsJson: trendsJson ?? this.trendsJson,
      redFlagsJson: redFlagsJson ?? this.redFlagsJson,
      inputHash: inputHash ?? this.inputHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (promptVersion.present) {
      map['prompt_version'] = Variable<String>(promptVersion.value);
    }
    if (summaryMarkdown.present) {
      map['summary_markdown'] = Variable<String>(summaryMarkdown.value);
    }
    if (keyEventsJson.present) {
      map['key_events_json'] = Variable<String>(keyEventsJson.value);
    }
    if (trendsJson.present) {
      map['trends_json'] = Variable<String>(trendsJson.value);
    }
    if (redFlagsJson.present) {
      map['red_flags_json'] = Variable<String>(redFlagsJson.value);
    }
    if (inputHash.present) {
      map['input_hash'] = Variable<String>(inputHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiSummariesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('modelId: $modelId, ')
          ..write('promptVersion: $promptVersion, ')
          ..write('summaryMarkdown: $summaryMarkdown, ')
          ..write('keyEventsJson: $keyEventsJson, ')
          ..write('trendsJson: $trendsJson, ')
          ..write('redFlagsJson: $redFlagsJson, ')
          ..write('inputHash: $inputHash')
          ..write(')'))
        .toString();
  }
}

class $RiskFlagsTable extends RiskFlags
    with TableInfo<$RiskFlagsTable, RiskFlag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiskFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<RiskSeverity, String> severity =
      GeneratedColumn<String>('severity', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RiskSeverity>($RiskFlagsTable.$converterseverity);
  static const VerificationMeta _rationaleMeta =
      const VerificationMeta('rationale');
  @override
  late final GeneratedColumn<String> rationale = GeneratedColumn<String>(
      'rationale', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detectedAtMeta =
      const VerificationMeta('detectedAt');
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
      'detected_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumnWithTypeConverter<RiskSource, String> source =
      GeneratedColumn<String>('source', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RiskSource>($RiskFlagsTable.$convertersource);
  static const VerificationMeta _acknowledgedByMeta =
      const VerificationMeta('acknowledgedBy');
  @override
  late final GeneratedColumn<int> acknowledgedBy = GeneratedColumn<int>(
      'acknowledged_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _acknowledgedAtMeta =
      const VerificationMeta('acknowledgedAt');
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>('acknowledged_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        kind,
        severity,
        rationale,
        detectedAt,
        source,
        acknowledgedBy,
        acknowledgedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'risk_flags';
  @override
  VerificationContext validateIntegrity(Insertable<RiskFlag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('rationale')) {
      context.handle(_rationaleMeta,
          rationale.isAcceptableOrUnknown(data['rationale']!, _rationaleMeta));
    } else if (isInserting) {
      context.missing(_rationaleMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
          _detectedAtMeta,
          detectedAt.isAcceptableOrUnknown(
              data['detected_at']!, _detectedAtMeta));
    }
    if (data.containsKey('acknowledged_by')) {
      context.handle(
          _acknowledgedByMeta,
          acknowledgedBy.isAcceptableOrUnknown(
              data['acknowledged_by']!, _acknowledgedByMeta));
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
          _acknowledgedAtMeta,
          acknowledgedAt.isAcceptableOrUnknown(
              data['acknowledged_at']!, _acknowledgedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RiskFlag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiskFlag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      severity: $RiskFlagsTable.$converterseverity.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!),
      rationale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rationale'])!,
      detectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}detected_at'])!,
      source: $RiskFlagsTable.$convertersource.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!),
      acknowledgedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}acknowledged_by']),
      acknowledgedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}acknowledged_at']),
    );
  }

  @override
  $RiskFlagsTable createAlias(String alias) {
    return $RiskFlagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RiskSeverity, String, String> $converterseverity =
      const EnumNameConverter<RiskSeverity>(RiskSeverity.values);
  static JsonTypeConverter2<RiskSource, String, String> $convertersource =
      const EnumNameConverter<RiskSource>(RiskSource.values);
}

class RiskFlag extends DataClass implements Insertable<RiskFlag> {
  final int id;
  final int patientId;
  final String kind;
  final RiskSeverity severity;
  final String rationale;
  final DateTime detectedAt;
  final RiskSource source;
  final int? acknowledgedBy;
  final DateTime? acknowledgedAt;
  const RiskFlag(
      {required this.id,
      required this.patientId,
      required this.kind,
      required this.severity,
      required this.rationale,
      required this.detectedAt,
      required this.source,
      this.acknowledgedBy,
      this.acknowledgedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['kind'] = Variable<String>(kind);
    {
      map['severity'] =
          Variable<String>($RiskFlagsTable.$converterseverity.toSql(severity));
    }
    map['rationale'] = Variable<String>(rationale);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    {
      map['source'] =
          Variable<String>($RiskFlagsTable.$convertersource.toSql(source));
    }
    if (!nullToAbsent || acknowledgedBy != null) {
      map['acknowledged_by'] = Variable<int>(acknowledgedBy);
    }
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    return map;
  }

  RiskFlagsCompanion toCompanion(bool nullToAbsent) {
    return RiskFlagsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      kind: Value(kind),
      severity: Value(severity),
      rationale: Value(rationale),
      detectedAt: Value(detectedAt),
      source: Value(source),
      acknowledgedBy: acknowledgedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedBy),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
    );
  }

  factory RiskFlag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiskFlag(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      kind: serializer.fromJson<String>(json['kind']),
      severity: $RiskFlagsTable.$converterseverity
          .fromJson(serializer.fromJson<String>(json['severity'])),
      rationale: serializer.fromJson<String>(json['rationale']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      source: $RiskFlagsTable.$convertersource
          .fromJson(serializer.fromJson<String>(json['source'])),
      acknowledgedBy: serializer.fromJson<int?>(json['acknowledgedBy']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'kind': serializer.toJson<String>(kind),
      'severity': serializer
          .toJson<String>($RiskFlagsTable.$converterseverity.toJson(severity)),
      'rationale': serializer.toJson<String>(rationale),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'source': serializer
          .toJson<String>($RiskFlagsTable.$convertersource.toJson(source)),
      'acknowledgedBy': serializer.toJson<int?>(acknowledgedBy),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
    };
  }

  RiskFlag copyWith(
          {int? id,
          int? patientId,
          String? kind,
          RiskSeverity? severity,
          String? rationale,
          DateTime? detectedAt,
          RiskSource? source,
          Value<int?> acknowledgedBy = const Value.absent(),
          Value<DateTime?> acknowledgedAt = const Value.absent()}) =>
      RiskFlag(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        kind: kind ?? this.kind,
        severity: severity ?? this.severity,
        rationale: rationale ?? this.rationale,
        detectedAt: detectedAt ?? this.detectedAt,
        source: source ?? this.source,
        acknowledgedBy:
            acknowledgedBy.present ? acknowledgedBy.value : this.acknowledgedBy,
        acknowledgedAt:
            acknowledgedAt.present ? acknowledgedAt.value : this.acknowledgedAt,
      );
  RiskFlag copyWithCompanion(RiskFlagsCompanion data) {
    return RiskFlag(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      kind: data.kind.present ? data.kind.value : this.kind,
      severity: data.severity.present ? data.severity.value : this.severity,
      rationale: data.rationale.present ? data.rationale.value : this.rationale,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
      source: data.source.present ? data.source.value : this.source,
      acknowledgedBy: data.acknowledgedBy.present
          ? data.acknowledgedBy.value
          : this.acknowledgedBy,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiskFlag(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('kind: $kind, ')
          ..write('severity: $severity, ')
          ..write('rationale: $rationale, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('source: $source, ')
          ..write('acknowledgedBy: $acknowledgedBy, ')
          ..write('acknowledgedAt: $acknowledgedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, kind, severity, rationale,
      detectedAt, source, acknowledgedBy, acknowledgedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiskFlag &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.kind == this.kind &&
          other.severity == this.severity &&
          other.rationale == this.rationale &&
          other.detectedAt == this.detectedAt &&
          other.source == this.source &&
          other.acknowledgedBy == this.acknowledgedBy &&
          other.acknowledgedAt == this.acknowledgedAt);
}

class RiskFlagsCompanion extends UpdateCompanion<RiskFlag> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<String> kind;
  final Value<RiskSeverity> severity;
  final Value<String> rationale;
  final Value<DateTime> detectedAt;
  final Value<RiskSource> source;
  final Value<int?> acknowledgedBy;
  final Value<DateTime?> acknowledgedAt;
  const RiskFlagsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.kind = const Value.absent(),
    this.severity = const Value.absent(),
    this.rationale = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.acknowledgedBy = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
  });
  RiskFlagsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required String kind,
    required RiskSeverity severity,
    required String rationale,
    this.detectedAt = const Value.absent(),
    required RiskSource source,
    this.acknowledgedBy = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
  })  : patientId = Value(patientId),
        kind = Value(kind),
        severity = Value(severity),
        rationale = Value(rationale),
        source = Value(source);
  static Insertable<RiskFlag> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<String>? kind,
    Expression<String>? severity,
    Expression<String>? rationale,
    Expression<DateTime>? detectedAt,
    Expression<String>? source,
    Expression<int>? acknowledgedBy,
    Expression<DateTime>? acknowledgedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (kind != null) 'kind': kind,
      if (severity != null) 'severity': severity,
      if (rationale != null) 'rationale': rationale,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (source != null) 'source': source,
      if (acknowledgedBy != null) 'acknowledged_by': acknowledgedBy,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
    });
  }

  RiskFlagsCompanion copyWith(
      {Value<int>? id,
      Value<int>? patientId,
      Value<String>? kind,
      Value<RiskSeverity>? severity,
      Value<String>? rationale,
      Value<DateTime>? detectedAt,
      Value<RiskSource>? source,
      Value<int?>? acknowledgedBy,
      Value<DateTime?>? acknowledgedAt}) {
    return RiskFlagsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      kind: kind ?? this.kind,
      severity: severity ?? this.severity,
      rationale: rationale ?? this.rationale,
      detectedAt: detectedAt ?? this.detectedAt,
      source: source ?? this.source,
      acknowledgedBy: acknowledgedBy ?? this.acknowledgedBy,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(
          $RiskFlagsTable.$converterseverity.toSql(severity.value));
    }
    if (rationale.present) {
      map['rationale'] = Variable<String>(rationale.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
          $RiskFlagsTable.$convertersource.toSql(source.value));
    }
    if (acknowledgedBy.present) {
      map['acknowledged_by'] = Variable<int>(acknowledgedBy.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RiskFlagsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('kind: $kind, ')
          ..write('severity: $severity, ')
          ..write('rationale: $rationale, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('source: $source, ')
          ..write('acknowledgedBy: $acknowledgedBy, ')
          ..write('acknowledgedAt: $acknowledgedAt')
          ..write(')'))
        .toString();
  }
}

class $StaffTasksTable extends StaffTasks
    with TableInfo<$StaffTasksTable, StaffTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TaskKind, String> kind =
      GeneratedColumn<String>('kind', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TaskKind>($StaffTasksTable.$converterkind);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(TaskStatus.pending.name))
          .withConverter<TaskStatus>($StaffTasksTable.$converterstatus);
  static const VerificationMeta _ruleScoreMeta =
      const VerificationMeta('ruleScore');
  @override
  late final GeneratedColumn<double> ruleScore = GeneratedColumn<double>(
      'rule_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _aiPriorityScoreMeta =
      const VerificationMeta('aiPriorityScore');
  @override
  late final GeneratedColumn<double> aiPriorityScore = GeneratedColumn<double>(
      'ai_priority_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _aiRationaleMeta =
      const VerificationMeta('aiRationale');
  @override
  late final GeneratedColumn<String> aiRationale = GeneratedColumn<String>(
      'ai_rationale', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        staffId,
        patientId,
        title,
        kind,
        dueAt,
        status,
        ruleScore,
        aiPriorityScore,
        aiRationale,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<StaffTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('rule_score')) {
      context.handle(_ruleScoreMeta,
          ruleScore.isAcceptableOrUnknown(data['rule_score']!, _ruleScoreMeta));
    }
    if (data.containsKey('ai_priority_score')) {
      context.handle(
          _aiPriorityScoreMeta,
          aiPriorityScore.isAcceptableOrUnknown(
              data['ai_priority_score']!, _aiPriorityScoreMeta));
    }
    if (data.containsKey('ai_rationale')) {
      context.handle(
          _aiRationaleMeta,
          aiRationale.isAcceptableOrUnknown(
              data['ai_rationale']!, _aiRationaleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}staff_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      kind: $StaffTasksTable.$converterkind.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      status: $StaffTasksTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      ruleScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rule_score'])!,
      aiPriorityScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}ai_priority_score']),
      aiRationale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_rationale']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StaffTasksTable createAlias(String alias) {
    return $StaffTasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskKind, String, String> $converterkind =
      const EnumNameConverter<TaskKind>(TaskKind.values);
  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
}

class StaffTask extends DataClass implements Insertable<StaffTask> {
  final int id;
  final int staffId;
  final int? patientId;
  final String title;
  final TaskKind kind;
  final DateTime dueAt;
  final TaskStatus status;
  final double ruleScore;
  final double? aiPriorityScore;
  final String? aiRationale;
  final DateTime createdAt;
  const StaffTask(
      {required this.id,
      required this.staffId,
      this.patientId,
      required this.title,
      required this.kind,
      required this.dueAt,
      required this.status,
      required this.ruleScore,
      this.aiPriorityScore,
      this.aiRationale,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<int>(patientId);
    }
    map['title'] = Variable<String>(title);
    {
      map['kind'] =
          Variable<String>($StaffTasksTable.$converterkind.toSql(kind));
    }
    map['due_at'] = Variable<DateTime>(dueAt);
    {
      map['status'] =
          Variable<String>($StaffTasksTable.$converterstatus.toSql(status));
    }
    map['rule_score'] = Variable<double>(ruleScore);
    if (!nullToAbsent || aiPriorityScore != null) {
      map['ai_priority_score'] = Variable<double>(aiPriorityScore);
    }
    if (!nullToAbsent || aiRationale != null) {
      map['ai_rationale'] = Variable<String>(aiRationale);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StaffTasksCompanion toCompanion(bool nullToAbsent) {
    return StaffTasksCompanion(
      id: Value(id),
      staffId: Value(staffId),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      title: Value(title),
      kind: Value(kind),
      dueAt: Value(dueAt),
      status: Value(status),
      ruleScore: Value(ruleScore),
      aiPriorityScore: aiPriorityScore == null && nullToAbsent
          ? const Value.absent()
          : Value(aiPriorityScore),
      aiRationale: aiRationale == null && nullToAbsent
          ? const Value.absent()
          : Value(aiRationale),
      createdAt: Value(createdAt),
    );
  }

  factory StaffTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffTask(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      patientId: serializer.fromJson<int?>(json['patientId']),
      title: serializer.fromJson<String>(json['title']),
      kind: $StaffTasksTable.$converterkind
          .fromJson(serializer.fromJson<String>(json['kind'])),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      status: $StaffTasksTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      ruleScore: serializer.fromJson<double>(json['ruleScore']),
      aiPriorityScore: serializer.fromJson<double?>(json['aiPriorityScore']),
      aiRationale: serializer.fromJson<String?>(json['aiRationale']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'patientId': serializer.toJson<int?>(patientId),
      'title': serializer.toJson<String>(title),
      'kind': serializer
          .toJson<String>($StaffTasksTable.$converterkind.toJson(kind)),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'status': serializer
          .toJson<String>($StaffTasksTable.$converterstatus.toJson(status)),
      'ruleScore': serializer.toJson<double>(ruleScore),
      'aiPriorityScore': serializer.toJson<double?>(aiPriorityScore),
      'aiRationale': serializer.toJson<String?>(aiRationale),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StaffTask copyWith(
          {int? id,
          int? staffId,
          Value<int?> patientId = const Value.absent(),
          String? title,
          TaskKind? kind,
          DateTime? dueAt,
          TaskStatus? status,
          double? ruleScore,
          Value<double?> aiPriorityScore = const Value.absent(),
          Value<String?> aiRationale = const Value.absent(),
          DateTime? createdAt}) =>
      StaffTask(
        id: id ?? this.id,
        staffId: staffId ?? this.staffId,
        patientId: patientId.present ? patientId.value : this.patientId,
        title: title ?? this.title,
        kind: kind ?? this.kind,
        dueAt: dueAt ?? this.dueAt,
        status: status ?? this.status,
        ruleScore: ruleScore ?? this.ruleScore,
        aiPriorityScore: aiPriorityScore.present
            ? aiPriorityScore.value
            : this.aiPriorityScore,
        aiRationale: aiRationale.present ? aiRationale.value : this.aiRationale,
        createdAt: createdAt ?? this.createdAt,
      );
  StaffTask copyWithCompanion(StaffTasksCompanion data) {
    return StaffTask(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      status: data.status.present ? data.status.value : this.status,
      ruleScore: data.ruleScore.present ? data.ruleScore.value : this.ruleScore,
      aiPriorityScore: data.aiPriorityScore.present
          ? data.aiPriorityScore.value
          : this.aiPriorityScore,
      aiRationale:
          data.aiRationale.present ? data.aiRationale.value : this.aiRationale,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffTask(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('patientId: $patientId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status, ')
          ..write('ruleScore: $ruleScore, ')
          ..write('aiPriorityScore: $aiPriorityScore, ')
          ..write('aiRationale: $aiRationale, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, staffId, patientId, title, kind, dueAt,
      status, ruleScore, aiPriorityScore, aiRationale, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffTask &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.patientId == this.patientId &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.dueAt == this.dueAt &&
          other.status == this.status &&
          other.ruleScore == this.ruleScore &&
          other.aiPriorityScore == this.aiPriorityScore &&
          other.aiRationale == this.aiRationale &&
          other.createdAt == this.createdAt);
}

class StaffTasksCompanion extends UpdateCompanion<StaffTask> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<int?> patientId;
  final Value<String> title;
  final Value<TaskKind> kind;
  final Value<DateTime> dueAt;
  final Value<TaskStatus> status;
  final Value<double> ruleScore;
  final Value<double?> aiPriorityScore;
  final Value<String?> aiRationale;
  final Value<DateTime> createdAt;
  const StaffTasksCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.status = const Value.absent(),
    this.ruleScore = const Value.absent(),
    this.aiPriorityScore = const Value.absent(),
    this.aiRationale = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StaffTasksCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    this.patientId = const Value.absent(),
    required String title,
    required TaskKind kind,
    required DateTime dueAt,
    this.status = const Value.absent(),
    this.ruleScore = const Value.absent(),
    this.aiPriorityScore = const Value.absent(),
    this.aiRationale = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : staffId = Value(staffId),
        title = Value(title),
        kind = Value(kind),
        dueAt = Value(dueAt);
  static Insertable<StaffTask> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<int>? patientId,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<DateTime>? dueAt,
    Expression<String>? status,
    Expression<double>? ruleScore,
    Expression<double>? aiPriorityScore,
    Expression<String>? aiRationale,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (patientId != null) 'patient_id': patientId,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (dueAt != null) 'due_at': dueAt,
      if (status != null) 'status': status,
      if (ruleScore != null) 'rule_score': ruleScore,
      if (aiPriorityScore != null) 'ai_priority_score': aiPriorityScore,
      if (aiRationale != null) 'ai_rationale': aiRationale,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StaffTasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? staffId,
      Value<int?>? patientId,
      Value<String>? title,
      Value<TaskKind>? kind,
      Value<DateTime>? dueAt,
      Value<TaskStatus>? status,
      Value<double>? ruleScore,
      Value<double?>? aiPriorityScore,
      Value<String?>? aiRationale,
      Value<DateTime>? createdAt}) {
    return StaffTasksCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      ruleScore: ruleScore ?? this.ruleScore,
      aiPriorityScore: aiPriorityScore ?? this.aiPriorityScore,
      aiRationale: aiRationale ?? this.aiRationale,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] =
          Variable<String>($StaffTasksTable.$converterkind.toSql(kind.value));
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $StaffTasksTable.$converterstatus.toSql(status.value));
    }
    if (ruleScore.present) {
      map['rule_score'] = Variable<double>(ruleScore.value);
    }
    if (aiPriorityScore.present) {
      map['ai_priority_score'] = Variable<double>(aiPriorityScore.value);
    }
    if (aiRationale.present) {
      map['ai_rationale'] = Variable<String>(aiRationale.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffTasksCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('patientId: $patientId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('dueAt: $dueAt, ')
          ..write('status: $status, ')
          ..write('ruleScore: $ruleScore, ')
          ..write('aiPriorityScore: $aiPriorityScore, ')
          ..write('aiRationale: $aiRationale, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actorUserIdMeta =
      const VerificationMeta('actorUserId');
  @override
  late final GeneratedColumn<int> actorUserId = GeneratedColumn<int>(
      'actor_user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, actorUserId, action, entityType, entityId, timestamp, metadataJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('actor_user_id')) {
      context.handle(
          _actorUserIdMeta,
          actorUserId.isAcceptableOrUnknown(
              data['actor_user_id']!, _actorUserIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      actorUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actor_user_id']),
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int id;
  final int? actorUserId;
  final String action;
  final String entityType;
  final int? entityId;
  final DateTime timestamp;
  final String? metadataJson;
  const AuditLogData(
      {required this.id,
      this.actorUserId,
      required this.action,
      required this.entityType,
      this.entityId,
      required this.timestamp,
      this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || actorUserId != null) {
      map['actor_user_id'] = Variable<int>(actorUserId);
    }
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      actorUserId: actorUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUserId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      timestamp: Value(timestamp),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory AuditLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<int>(json['id']),
      actorUserId: serializer.fromJson<int?>(json['actorUserId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actorUserId': serializer.toJson<int?>(actorUserId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int?>(entityId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  AuditLogData copyWith(
          {int? id,
          Value<int?> actorUserId = const Value.absent(),
          String? action,
          String? entityType,
          Value<int?> entityId = const Value.absent(),
          DateTime? timestamp,
          Value<String?> metadataJson = const Value.absent()}) =>
      AuditLogData(
        id: id ?? this.id,
        actorUserId: actorUserId.present ? actorUserId.value : this.actorUserId,
        action: action ?? this.action,
        entityType: entityType ?? this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        timestamp: timestamp ?? this.timestamp,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
      );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      actorUserId:
          data.actorUserId.present ? data.actorUserId.value : this.actorUserId,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, actorUserId, action, entityType, entityId, timestamp, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.actorUserId == this.actorUserId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.timestamp == this.timestamp &&
          other.metadataJson == this.metadataJson);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> id;
  final Value<int?> actorUserId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<int?> entityId;
  final Value<DateTime> timestamp;
  final Value<String?> metadataJson;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.actorUserId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadataJson = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    this.actorUserId = const Value.absent(),
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadataJson = const Value.absent(),
  })  : action = Value(action),
        entityType = Value(entityType);
  static Insertable<AuditLogData> custom({
    Expression<int>? id,
    Expression<int>? actorUserId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<DateTime>? timestamp,
    Expression<String>? metadataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actorUserId != null) 'actor_user_id': actorUserId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadataJson != null) 'metadata_json': metadataJson,
    });
  }

  AuditLogCompanion copyWith(
      {Value<int>? id,
      Value<int?>? actorUserId,
      Value<String>? action,
      Value<String>? entityType,
      Value<int?>? entityId,
      Value<DateTime>? timestamp,
      Value<String?>? metadataJson}) {
    return AuditLogCompanion(
      id: id ?? this.id,
      actorUserId: actorUserId ?? this.actorUserId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      timestamp: timestamp ?? this.timestamp,
      metadataJson: metadataJson ?? this.metadataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actorUserId.present) {
      map['actor_user_id'] = Variable<int>(actorUserId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _aiEnabledMeta =
      const VerificationMeta('aiEnabled');
  @override
  late final GeneratedColumn<bool> aiEnabled = GeneratedColumn<bool>(
      'ai_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ai_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _mockModeMeta =
      const VerificationMeta('mockMode');
  @override
  late final GeneratedColumn<bool> mockMode = GeneratedColumn<bool>(
      'mock_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("mock_mode" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _modelIdMeta =
      const VerificationMeta('modelId');
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
      'model_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('claude-3-5-sonnet-20241022'));
  static const VerificationMeta _seedVersionMeta =
      const VerificationMeta('seedVersion');
  @override
  late final GeneratedColumn<int> seedVersion = GeneratedColumn<int>(
      'seed_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastSeededAtMeta =
      const VerificationMeta('lastSeededAt');
  @override
  late final GeneratedColumn<DateTime> lastSeededAt = GeneratedColumn<DateTime>(
      'last_seeded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, aiEnabled, mockMode, modelId, seedVersion, lastSeededAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ai_enabled')) {
      context.handle(_aiEnabledMeta,
          aiEnabled.isAcceptableOrUnknown(data['ai_enabled']!, _aiEnabledMeta));
    }
    if (data.containsKey('mock_mode')) {
      context.handle(_mockModeMeta,
          mockMode.isAcceptableOrUnknown(data['mock_mode']!, _mockModeMeta));
    }
    if (data.containsKey('model_id')) {
      context.handle(_modelIdMeta,
          modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta));
    }
    if (data.containsKey('seed_version')) {
      context.handle(
          _seedVersionMeta,
          seedVersion.isAcceptableOrUnknown(
              data['seed_version']!, _seedVersionMeta));
    }
    if (data.containsKey('last_seeded_at')) {
      context.handle(
          _lastSeededAtMeta,
          lastSeededAt.isAcceptableOrUnknown(
              data['last_seeded_at']!, _lastSeededAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      aiEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ai_enabled'])!,
      mockMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}mock_mode'])!,
      modelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_id'])!,
      seedVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seed_version'])!,
      lastSeededAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_seeded_at']),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool aiEnabled;
  final bool mockMode;
  final String modelId;
  final int seedVersion;
  final DateTime? lastSeededAt;
  const AppSetting(
      {required this.id,
      required this.aiEnabled,
      required this.mockMode,
      required this.modelId,
      required this.seedVersion,
      this.lastSeededAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ai_enabled'] = Variable<bool>(aiEnabled);
    map['mock_mode'] = Variable<bool>(mockMode);
    map['model_id'] = Variable<String>(modelId);
    map['seed_version'] = Variable<int>(seedVersion);
    if (!nullToAbsent || lastSeededAt != null) {
      map['last_seeded_at'] = Variable<DateTime>(lastSeededAt);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      aiEnabled: Value(aiEnabled),
      mockMode: Value(mockMode),
      modelId: Value(modelId),
      seedVersion: Value(seedVersion),
      lastSeededAt: lastSeededAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeededAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      aiEnabled: serializer.fromJson<bool>(json['aiEnabled']),
      mockMode: serializer.fromJson<bool>(json['mockMode']),
      modelId: serializer.fromJson<String>(json['modelId']),
      seedVersion: serializer.fromJson<int>(json['seedVersion']),
      lastSeededAt: serializer.fromJson<DateTime?>(json['lastSeededAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'aiEnabled': serializer.toJson<bool>(aiEnabled),
      'mockMode': serializer.toJson<bool>(mockMode),
      'modelId': serializer.toJson<String>(modelId),
      'seedVersion': serializer.toJson<int>(seedVersion),
      'lastSeededAt': serializer.toJson<DateTime?>(lastSeededAt),
    };
  }

  AppSetting copyWith(
          {int? id,
          bool? aiEnabled,
          bool? mockMode,
          String? modelId,
          int? seedVersion,
          Value<DateTime?> lastSeededAt = const Value.absent()}) =>
      AppSetting(
        id: id ?? this.id,
        aiEnabled: aiEnabled ?? this.aiEnabled,
        mockMode: mockMode ?? this.mockMode,
        modelId: modelId ?? this.modelId,
        seedVersion: seedVersion ?? this.seedVersion,
        lastSeededAt:
            lastSeededAt.present ? lastSeededAt.value : this.lastSeededAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      aiEnabled: data.aiEnabled.present ? data.aiEnabled.value : this.aiEnabled,
      mockMode: data.mockMode.present ? data.mockMode.value : this.mockMode,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      seedVersion:
          data.seedVersion.present ? data.seedVersion.value : this.seedVersion,
      lastSeededAt: data.lastSeededAt.present
          ? data.lastSeededAt.value
          : this.lastSeededAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('aiEnabled: $aiEnabled, ')
          ..write('mockMode: $mockMode, ')
          ..write('modelId: $modelId, ')
          ..write('seedVersion: $seedVersion, ')
          ..write('lastSeededAt: $lastSeededAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, aiEnabled, mockMode, modelId, seedVersion, lastSeededAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.aiEnabled == this.aiEnabled &&
          other.mockMode == this.mockMode &&
          other.modelId == this.modelId &&
          other.seedVersion == this.seedVersion &&
          other.lastSeededAt == this.lastSeededAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> aiEnabled;
  final Value<bool> mockMode;
  final Value<String> modelId;
  final Value<int> seedVersion;
  final Value<DateTime?> lastSeededAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.aiEnabled = const Value.absent(),
    this.mockMode = const Value.absent(),
    this.modelId = const Value.absent(),
    this.seedVersion = const Value.absent(),
    this.lastSeededAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.aiEnabled = const Value.absent(),
    this.mockMode = const Value.absent(),
    this.modelId = const Value.absent(),
    this.seedVersion = const Value.absent(),
    this.lastSeededAt = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? aiEnabled,
    Expression<bool>? mockMode,
    Expression<String>? modelId,
    Expression<int>? seedVersion,
    Expression<DateTime>? lastSeededAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (aiEnabled != null) 'ai_enabled': aiEnabled,
      if (mockMode != null) 'mock_mode': mockMode,
      if (modelId != null) 'model_id': modelId,
      if (seedVersion != null) 'seed_version': seedVersion,
      if (lastSeededAt != null) 'last_seeded_at': lastSeededAt,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? aiEnabled,
      Value<bool>? mockMode,
      Value<String>? modelId,
      Value<int>? seedVersion,
      Value<DateTime?>? lastSeededAt}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      mockMode: mockMode ?? this.mockMode,
      modelId: modelId ?? this.modelId,
      seedVersion: seedVersion ?? this.seedVersion,
      lastSeededAt: lastSeededAt ?? this.lastSeededAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (aiEnabled.present) {
      map['ai_enabled'] = Variable<bool>(aiEnabled.value);
    }
    if (mockMode.present) {
      map['mock_mode'] = Variable<bool>(mockMode.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (seedVersion.present) {
      map['seed_version'] = Variable<int>(seedVersion.value);
    }
    if (lastSeededAt.present) {
      map['last_seeded_at'] = Variable<DateTime>(lastSeededAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('aiEnabled: $aiEnabled, ')
          ..write('mockMode: $mockMode, ')
          ..write('modelId: $modelId, ')
          ..write('seedVersion: $seedVersion, ')
          ..write('lastSeededAt: $lastSeededAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PatientProfilesTable patientProfiles =
      $PatientProfilesTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $StaffProfilesTable staffProfiles = $StaffProfilesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $ScheduleTemplatesTable scheduleTemplates =
      $ScheduleTemplatesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $MedicalRecordsTable medicalRecords = $MedicalRecordsTable(this);
  late final $LabValuesTable labValues = $LabValuesTable(this);
  late final $VitalsTable vitals = $VitalsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $AiSummariesTable aiSummaries = $AiSummariesTable(this);
  late final $RiskFlagsTable riskFlags = $RiskFlagsTable(this);
  late final $StaffTasksTable staffTasks = $StaffTasksTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        patientProfiles,
        departments,
        staffProfiles,
        appointments,
        scheduleTemplates,
        reminders,
        medicalRecords,
        labValues,
        vitals,
        medications,
        aiSummaries,
        riskFlags,
        staffTasks,
        auditLog,
        appSettings
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('patient_profiles', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('staff_profiles', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('appointments',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminders', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('medical_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lab_values', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required UserRole role,
  required String fullName,
  required String email,
  required String passwordHash,
  required String passwordSalt,
  required String phone,
  required DateTime dob,
  required String gender,
  required String nationalId,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<UserRole> role,
  Value<String> fullName,
  Value<String> email,
  Value<String> passwordHash,
  Value<String> passwordSalt,
  Value<String> phone,
  Value<DateTime> dob,
  Value<String> gender,
  Value<String> nationalId,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PatientProfilesTable, List<PatientProfile>>
      _patientProfilesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.patientProfiles,
              aliasName: 'users__id__patient_profiles__user_id');

  $$PatientProfilesTableProcessedTableManager get patientProfilesRefs {
    final manager =
        $$PatientProfilesTableTableManager($_db, $_db.patientProfiles)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_patientProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StaffProfilesTable, List<StaffProfile>>
      _staffProfilesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.staffProfiles,
              aliasName: 'users__id__staff_profiles__user_id');

  $$StaffProfilesTableProcessedTableManager get staffProfilesRefs {
    final manager = $$StaffProfilesTableTableManager($_db, $_db.staffProfiles)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staffProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ScheduleTemplatesTable, List<ScheduleTemplate>>
      _scheduleTemplatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.scheduleTemplates,
              aliasName: 'users__id__schedule_templates__staff_id');

  $$ScheduleTemplatesTableProcessedTableManager get scheduleTemplatesRefs {
    final manager =
        $$ScheduleTemplatesTableTableManager($_db, $_db.scheduleTemplates)
            .filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_scheduleTemplatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$VitalsTable, List<Vital>> _vitalsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.vitals,
          aliasName: 'users__id__vitals__patient_id');

  $$VitalsTableProcessedTableManager get vitalsRefs {
    final manager = $$VitalsTableTableManager($_db, $_db.vitals)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vitalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AiSummariesTable, List<AiSummary>>
      _aiSummariesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.aiSummaries,
              aliasName: 'users__id__ai_summaries__patient_id');

  $$AiSummariesTableProcessedTableManager get aiSummariesRefs {
    final manager = $$AiSummariesTableTableManager($_db, $_db.aiSummaries)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_aiSummariesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AuditLogTable, List<AuditLogData>>
      _auditLogRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.auditLog,
              aliasName: 'users__id__audit_log__actor_user_id');

  $$AuditLogTableProcessedTableManager get auditLogRefs {
    final manager = $$AuditLogTableTableManager($_db, $_db.auditLog)
        .filter((f) => f.actorUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<UserRole, UserRole, String> get role =>
      $composableBuilder(
          column: $table.role,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> patientProfilesRefs(
      Expression<bool> Function($$PatientProfilesTableFilterComposer f) f) {
    final $$PatientProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.patientProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientProfilesTableFilterComposer(
              $db: $db,
              $table: $db.patientProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> staffProfilesRefs(
      Expression<bool> Function($$StaffProfilesTableFilterComposer f) f) {
    final $$StaffProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staffProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffProfilesTableFilterComposer(
              $db: $db,
              $table: $db.staffProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> scheduleTemplatesRefs(
      Expression<bool> Function($$ScheduleTemplatesTableFilterComposer f) f) {
    final $$ScheduleTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.scheduleTemplates,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduleTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.scheduleTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> vitalsRefs(
      Expression<bool> Function($$VitalsTableFilterComposer f) f) {
    final $$VitalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vitals,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VitalsTableFilterComposer(
              $db: $db,
              $table: $db.vitals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> aiSummariesRefs(
      Expression<bool> Function($$AiSummariesTableFilterComposer f) f) {
    final $$AiSummariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.aiSummaries,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AiSummariesTableFilterComposer(
              $db: $db,
              $table: $db.aiSummaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> auditLogRefs(
      Expression<bool> Function($$AuditLogTableFilterComposer f) f) {
    final $$AuditLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLog,
        getReferencedColumn: (t) => t.actorUserId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogTableFilterComposer(
              $db: $db,
              $table: $db.auditLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UserRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> patientProfilesRefs<T extends Object>(
      Expression<T> Function($$PatientProfilesTableAnnotationComposer a) f) {
    final $$PatientProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.patientProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.patientProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> staffProfilesRefs<T extends Object>(
      Expression<T> Function($$StaffProfilesTableAnnotationComposer a) f) {
    final $$StaffProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staffProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.staffProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> scheduleTemplatesRefs<T extends Object>(
      Expression<T> Function($$ScheduleTemplatesTableAnnotationComposer a) f) {
    final $$ScheduleTemplatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.scheduleTemplates,
            getReferencedColumn: (t) => t.staffId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ScheduleTemplatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.scheduleTemplates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> vitalsRefs<T extends Object>(
      Expression<T> Function($$VitalsTableAnnotationComposer a) f) {
    final $$VitalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vitals,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VitalsTableAnnotationComposer(
              $db: $db,
              $table: $db.vitals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> aiSummariesRefs<T extends Object>(
      Expression<T> Function($$AiSummariesTableAnnotationComposer a) f) {
    final $$AiSummariesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.aiSummaries,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AiSummariesTableAnnotationComposer(
              $db: $db,
              $table: $db.aiSummaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> auditLogRefs<T extends Object>(
      Expression<T> Function($$AuditLogTableAnnotationComposer a) f) {
    final $$AuditLogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLog,
        getReferencedColumn: (t) => t.actorUserId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogTableAnnotationComposer(
              $db: $db,
              $table: $db.auditLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool patientProfilesRefs,
        bool staffProfilesRefs,
        bool scheduleTemplatesRefs,
        bool vitalsRefs,
        bool aiSummariesRefs,
        bool auditLogRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<UserRole> role = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> passwordSalt = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<DateTime> dob = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<String> nationalId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            role: role,
            fullName: fullName,
            email: email,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            phone: phone,
            dob: dob,
            gender: gender,
            nationalId: nationalId,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required UserRole role,
            required String fullName,
            required String email,
            required String passwordHash,
            required String passwordSalt,
            required String phone,
            required DateTime dob,
            required String gender,
            required String nationalId,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            role: role,
            fullName: fullName,
            email: email,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            phone: phone,
            dob: dob,
            gender: gender,
            nationalId: nationalId,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {patientProfilesRefs = false,
              staffProfilesRefs = false,
              scheduleTemplatesRefs = false,
              vitalsRefs = false,
              aiSummariesRefs = false,
              auditLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (patientProfilesRefs) db.patientProfiles,
                if (staffProfilesRefs) db.staffProfiles,
                if (scheduleTemplatesRefs) db.scheduleTemplates,
                if (vitalsRefs) db.vitals,
                if (aiSummariesRefs) db.aiSummaries,
                if (auditLogRefs) db.auditLog
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (patientProfilesRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            PatientProfile>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._patientProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .patientProfilesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (staffProfilesRefs)
                    await $_getPrefetchedData<User, $UsersTable, StaffProfile>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._staffProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .staffProfilesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (scheduleTemplatesRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            ScheduleTemplate>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._scheduleTemplatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .scheduleTemplatesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.staffId == item.id),
                        typedResults: items),
                  if (vitalsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Vital>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._vitalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).vitalsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (aiSummariesRefs)
                    await $_getPrefetchedData<User, $UsersTable, AiSummary>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._aiSummariesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .aiSummariesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (auditLogRefs)
                    await $_getPrefetchedData<User, $UsersTable, AuditLogData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._auditLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).auditLogRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.actorUserId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool patientProfilesRefs,
        bool staffProfilesRefs,
        bool scheduleTemplatesRefs,
        bool vitalsRefs,
        bool aiSummariesRefs,
        bool auditLogRefs})>;
typedef $$PatientProfilesTableCreateCompanionBuilder = PatientProfilesCompanion
    Function({
  Value<int> userId,
  required String bloodType,
  required String allergies,
  required String chronicConditions,
  required String emergencyContact,
});
typedef $$PatientProfilesTableUpdateCompanionBuilder = PatientProfilesCompanion
    Function({
  Value<int> userId,
  Value<String> bloodType,
  Value<String> allergies,
  Value<String> chronicConditions,
  Value<String> emergencyContact,
});

final class $$PatientProfilesTableReferences extends BaseReferences<
    _$AppDatabase, $PatientProfilesTable, PatientProfile> {
  $$PatientProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('patient_profiles__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PatientProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact,
      builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PatientProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PatientProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions, builder: (column) => column);

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PatientProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (PatientProfile, $$PatientProfilesTableReferences),
    PatientProfile,
    PrefetchHooks Function({bool userId})> {
  $$PatientProfilesTableTableManager(
      _$AppDatabase db, $PatientProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String> bloodType = const Value.absent(),
            Value<String> allergies = const Value.absent(),
            Value<String> chronicConditions = const Value.absent(),
            Value<String> emergencyContact = const Value.absent(),
          }) =>
              PatientProfilesCompanion(
            userId: userId,
            bloodType: bloodType,
            allergies: allergies,
            chronicConditions: chronicConditions,
            emergencyContact: emergencyContact,
          ),
          createCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            required String bloodType,
            required String allergies,
            required String chronicConditions,
            required String emergencyContact,
          }) =>
              PatientProfilesCompanion.insert(
            userId: userId,
            bloodType: bloodType,
            allergies: allergies,
            chronicConditions: chronicConditions,
            emergencyContact: emergencyContact,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PatientProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$PatientProfilesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$PatientProfilesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PatientProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (PatientProfile, $$PatientProfilesTableReferences),
    PatientProfile,
    PrefetchHooks Function({bool userId})>;
typedef $$DepartmentsTableCreateCompanionBuilder = DepartmentsCompanion
    Function({
  Value<int> id,
  required String name,
  required String description,
});
typedef $$DepartmentsTableUpdateCompanionBuilder = DepartmentsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
});

final class $$DepartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $DepartmentsTable, Department> {
  $$DepartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StaffProfilesTable, List<StaffProfile>>
      _staffProfilesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.staffProfiles,
              aliasName: 'departments__id__staff_profiles__department_id');

  $$StaffProfilesTableProcessedTableManager get staffProfilesRefs {
    final manager = $$StaffProfilesTableTableManager($_db, $_db.staffProfiles)
        .filter((f) => f.departmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staffProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
      _appointmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.appointments,
              aliasName: 'departments__id__appointments__department_id');

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager($_db, $_db.appointments)
        .filter((f) => f.departmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  Expression<bool> staffProfilesRefs(
      Expression<bool> Function($$StaffProfilesTableFilterComposer f) f) {
    final $$StaffProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staffProfiles,
        getReferencedColumn: (t) => t.departmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffProfilesTableFilterComposer(
              $db: $db,
              $table: $db.staffProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> appointmentsRefs(
      Expression<bool> Function($$AppointmentsTableFilterComposer f) f) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appointments,
        getReferencedColumn: (t) => t.departmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppointmentsTableFilterComposer(
              $db: $db,
              $table: $db.appointments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  Expression<T> staffProfilesRefs<T extends Object>(
      Expression<T> Function($$StaffProfilesTableAnnotationComposer a) f) {
    final $$StaffProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staffProfiles,
        getReferencedColumn: (t) => t.departmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.staffProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> appointmentsRefs<T extends Object>(
      Expression<T> Function($$AppointmentsTableAnnotationComposer a) f) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appointments,
        getReferencedColumn: (t) => t.departmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppointmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.appointments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DepartmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DepartmentsTable,
    Department,
    $$DepartmentsTableFilterComposer,
    $$DepartmentsTableOrderingComposer,
    $$DepartmentsTableAnnotationComposer,
    $$DepartmentsTableCreateCompanionBuilder,
    $$DepartmentsTableUpdateCompanionBuilder,
    (Department, $$DepartmentsTableReferences),
    Department,
    PrefetchHooks Function({bool staffProfilesRefs, bool appointmentsRefs})> {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
          }) =>
              DepartmentsCompanion(
            id: id,
            name: name,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String description,
          }) =>
              DepartmentsCompanion.insert(
            id: id,
            name: name,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DepartmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {staffProfilesRefs = false, appointmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (staffProfilesRefs) db.staffProfiles,
                if (appointmentsRefs) db.appointments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (staffProfilesRefs)
                    await $_getPrefetchedData<Department, $DepartmentsTable,
                            StaffProfile>(
                        currentTable: table,
                        referencedTable: $$DepartmentsTableReferences
                            ._staffProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DepartmentsTableReferences(db, table, p0)
                                .staffProfilesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.departmentId == item.id),
                        typedResults: items),
                  if (appointmentsRefs)
                    await $_getPrefetchedData<Department, $DepartmentsTable,
                            Appointment>(
                        currentTable: table,
                        referencedTable: $$DepartmentsTableReferences
                            ._appointmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DepartmentsTableReferences(db, table, p0)
                                .appointmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.departmentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DepartmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DepartmentsTable,
    Department,
    $$DepartmentsTableFilterComposer,
    $$DepartmentsTableOrderingComposer,
    $$DepartmentsTableAnnotationComposer,
    $$DepartmentsTableCreateCompanionBuilder,
    $$DepartmentsTableUpdateCompanionBuilder,
    (Department, $$DepartmentsTableReferences),
    Department,
    PrefetchHooks Function({bool staffProfilesRefs, bool appointmentsRefs})>;
typedef $$StaffProfilesTableCreateCompanionBuilder = StaffProfilesCompanion
    Function({
  Value<int> userId,
  required int departmentId,
  required String specialty,
  required String licenseNo,
  required String jobTitle,
});
typedef $$StaffProfilesTableUpdateCompanionBuilder = StaffProfilesCompanion
    Function({
  Value<int> userId,
  Value<int> departmentId,
  Value<String> specialty,
  Value<String> licenseNo,
  Value<String> jobTitle,
});

final class $$StaffProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $StaffProfilesTable, StaffProfile> {
  $$StaffProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('staff_profiles__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments
          .createAlias('staff_profiles__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<int>('department_id')!;

    final manager = $$DepartmentsTableTableManager($_db, $_db.departments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StaffProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $StaffProfilesTable> {
  $$StaffProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licenseNo => $composableBuilder(
      column: $table.licenseNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobTitle => $composableBuilder(
      column: $table.jobTitle, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableFilterComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffProfilesTable> {
  $$StaffProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenseNo => $composableBuilder(
      column: $table.licenseNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobTitle => $composableBuilder(
      column: $table.jobTitle, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableOrderingComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffProfilesTable> {
  $$StaffProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<String> get licenseNo =>
      $composableBuilder(column: $table.licenseNo, builder: (column) => column);

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaffProfilesTable,
    StaffProfile,
    $$StaffProfilesTableFilterComposer,
    $$StaffProfilesTableOrderingComposer,
    $$StaffProfilesTableAnnotationComposer,
    $$StaffProfilesTableCreateCompanionBuilder,
    $$StaffProfilesTableUpdateCompanionBuilder,
    (StaffProfile, $$StaffProfilesTableReferences),
    StaffProfile,
    PrefetchHooks Function({bool userId, bool departmentId})> {
  $$StaffProfilesTableTableManager(_$AppDatabase db, $StaffProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<int> departmentId = const Value.absent(),
            Value<String> specialty = const Value.absent(),
            Value<String> licenseNo = const Value.absent(),
            Value<String> jobTitle = const Value.absent(),
          }) =>
              StaffProfilesCompanion(
            userId: userId,
            departmentId: departmentId,
            specialty: specialty,
            licenseNo: licenseNo,
            jobTitle: jobTitle,
          ),
          createCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            required int departmentId,
            required String specialty,
            required String licenseNo,
            required String jobTitle,
          }) =>
              StaffProfilesCompanion.insert(
            userId: userId,
            departmentId: departmentId,
            specialty: specialty,
            licenseNo: licenseNo,
            jobTitle: jobTitle,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StaffProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$StaffProfilesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$StaffProfilesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (departmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.departmentId,
                    referencedTable:
                        $$StaffProfilesTableReferences._departmentIdTable(db),
                    referencedColumn: $$StaffProfilesTableReferences
                        ._departmentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StaffProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaffProfilesTable,
    StaffProfile,
    $$StaffProfilesTableFilterComposer,
    $$StaffProfilesTableOrderingComposer,
    $$StaffProfilesTableAnnotationComposer,
    $$StaffProfilesTableCreateCompanionBuilder,
    $$StaffProfilesTableUpdateCompanionBuilder,
    (StaffProfile, $$StaffProfilesTableReferences),
    StaffProfile,
    PrefetchHooks Function({bool userId, bool departmentId})>;
typedef $$AppointmentsTableCreateCompanionBuilder = AppointmentsCompanion
    Function({
  Value<int> id,
  required int patientId,
  required int staffId,
  required int departmentId,
  required DateTime slotStart,
  required DateTime slotEnd,
  required String visitType,
  Value<AppointmentStatus> status,
  required String reasonText,
  Value<DateTime> bookedAt,
  Value<double?> noShowRisk,
  Value<RiskBand?> riskBand,
  Value<int> remindersSent,
  Value<DateTime?> checkedInAt,
});
typedef $$AppointmentsTableUpdateCompanionBuilder = AppointmentsCompanion
    Function({
  Value<int> id,
  Value<int> patientId,
  Value<int> staffId,
  Value<int> departmentId,
  Value<DateTime> slotStart,
  Value<DateTime> slotEnd,
  Value<String> visitType,
  Value<AppointmentStatus> status,
  Value<String> reasonText,
  Value<DateTime> bookedAt,
  Value<double?> noShowRisk,
  Value<RiskBand?> riskBand,
  Value<int> remindersSent,
  Value<DateTime?> checkedInAt,
});

final class $$AppointmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('appointments__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _staffIdTable(_$AppDatabase db) =>
      db.users.createAlias('appointments__staff_id__users__id');

  $$UsersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments
          .createAlias('appointments__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<int>('department_id')!;

    final manager = $$DepartmentsTableTableManager($_db, $_db.departments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminders,
              aliasName: 'appointments__id__reminders__appointment_id');

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get slotStart => $composableBuilder(
      column: $table.slotStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get slotEnd => $composableBuilder(
      column: $table.slotEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visitType => $composableBuilder(
      column: $table.visitType, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AppointmentStatus, AppointmentStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get reasonText => $composableBuilder(
      column: $table.reasonText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get bookedAt => $composableBuilder(
      column: $table.bookedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get noShowRisk => $composableBuilder(
      column: $table.noShowRisk, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RiskBand?, RiskBand, String> get riskBand =>
      $composableBuilder(
          column: $table.riskBand,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get remindersSent => $composableBuilder(
      column: $table.remindersSent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get staffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableFilterComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.appointmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get slotStart => $composableBuilder(
      column: $table.slotStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get slotEnd => $composableBuilder(
      column: $table.slotEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visitType => $composableBuilder(
      column: $table.visitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonText => $composableBuilder(
      column: $table.reasonText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get bookedAt => $composableBuilder(
      column: $table.bookedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get noShowRisk => $composableBuilder(
      column: $table.noShowRisk, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get riskBand => $composableBuilder(
      column: $table.riskBand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remindersSent => $composableBuilder(
      column: $table.remindersSent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get staffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableOrderingComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get slotStart =>
      $composableBuilder(column: $table.slotStart, builder: (column) => column);

  GeneratedColumn<DateTime> get slotEnd =>
      $composableBuilder(column: $table.slotEnd, builder: (column) => column);

  GeneratedColumn<String> get visitType =>
      $composableBuilder(column: $table.visitType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppointmentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reasonText => $composableBuilder(
      column: $table.reasonText, builder: (column) => column);

  GeneratedColumn<DateTime> get bookedAt =>
      $composableBuilder(column: $table.bookedAt, builder: (column) => column);

  GeneratedColumn<double> get noShowRisk => $composableBuilder(
      column: $table.noShowRisk, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RiskBand?, String> get riskBand =>
      $composableBuilder(column: $table.riskBand, builder: (column) => column);

  GeneratedColumn<int> get remindersSent => $composableBuilder(
      column: $table.remindersSent, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get staffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.departmentId,
        referencedTable: $db.departments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepartmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.departments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.appointmentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AppointmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (Appointment, $$AppointmentsTableReferences),
    Appointment,
    PrefetchHooks Function(
        {bool patientId,
        bool staffId,
        bool departmentId,
        bool remindersRefs})> {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<int> staffId = const Value.absent(),
            Value<int> departmentId = const Value.absent(),
            Value<DateTime> slotStart = const Value.absent(),
            Value<DateTime> slotEnd = const Value.absent(),
            Value<String> visitType = const Value.absent(),
            Value<AppointmentStatus> status = const Value.absent(),
            Value<String> reasonText = const Value.absent(),
            Value<DateTime> bookedAt = const Value.absent(),
            Value<double?> noShowRisk = const Value.absent(),
            Value<RiskBand?> riskBand = const Value.absent(),
            Value<int> remindersSent = const Value.absent(),
            Value<DateTime?> checkedInAt = const Value.absent(),
          }) =>
              AppointmentsCompanion(
            id: id,
            patientId: patientId,
            staffId: staffId,
            departmentId: departmentId,
            slotStart: slotStart,
            slotEnd: slotEnd,
            visitType: visitType,
            status: status,
            reasonText: reasonText,
            bookedAt: bookedAt,
            noShowRisk: noShowRisk,
            riskBand: riskBand,
            remindersSent: remindersSent,
            checkedInAt: checkedInAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            required int staffId,
            required int departmentId,
            required DateTime slotStart,
            required DateTime slotEnd,
            required String visitType,
            Value<AppointmentStatus> status = const Value.absent(),
            required String reasonText,
            Value<DateTime> bookedAt = const Value.absent(),
            Value<double?> noShowRisk = const Value.absent(),
            Value<RiskBand?> riskBand = const Value.absent(),
            Value<int> remindersSent = const Value.absent(),
            Value<DateTime?> checkedInAt = const Value.absent(),
          }) =>
              AppointmentsCompanion.insert(
            id: id,
            patientId: patientId,
            staffId: staffId,
            departmentId: departmentId,
            slotStart: slotStart,
            slotEnd: slotEnd,
            visitType: visitType,
            status: status,
            reasonText: reasonText,
            bookedAt: bookedAt,
            noShowRisk: noShowRisk,
            riskBand: riskBand,
            remindersSent: remindersSent,
            checkedInAt: checkedInAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AppointmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {patientId = false,
              staffId = false,
              departmentId = false,
              remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (remindersRefs) db.reminders],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$AppointmentsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$AppointmentsTableReferences._patientIdTable(db).id,
                  ) as T;
                }
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$AppointmentsTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$AppointmentsTableReferences._staffIdTable(db).id,
                  ) as T;
                }
                if (departmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.departmentId,
                    referencedTable:
                        $$AppointmentsTableReferences._departmentIdTable(db),
                    referencedColumn:
                        $$AppointmentsTableReferences._departmentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (remindersRefs)
                    await $_getPrefetchedData<Appointment, $AppointmentsTable,
                            Reminder>(
                        currentTable: table,
                        referencedTable: $$AppointmentsTableReferences
                            ._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AppointmentsTableReferences(db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.appointmentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AppointmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (Appointment, $$AppointmentsTableReferences),
    Appointment,
    PrefetchHooks Function(
        {bool patientId, bool staffId, bool departmentId, bool remindersRefs})>;
typedef $$ScheduleTemplatesTableCreateCompanionBuilder
    = ScheduleTemplatesCompanion Function({
  Value<int> id,
  required int staffId,
  required int weekday,
  required String startTime,
  required String endTime,
  Value<int> slotMinutes,
});
typedef $$ScheduleTemplatesTableUpdateCompanionBuilder
    = ScheduleTemplatesCompanion Function({
  Value<int> id,
  Value<int> staffId,
  Value<int> weekday,
  Value<String> startTime,
  Value<String> endTime,
  Value<int> slotMinutes,
});

final class $$ScheduleTemplatesTableReferences extends BaseReferences<
    _$AppDatabase, $ScheduleTemplatesTable, ScheduleTemplate> {
  $$ScheduleTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _staffIdTable(_$AppDatabase db) =>
      db.users.createAlias('schedule_templates__staff_id__users__id');

  $$UsersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ScheduleTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleTemplatesTable> {
  $$ScheduleTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotMinutes => $composableBuilder(
      column: $table.slotMinutes, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get staffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduleTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleTemplatesTable> {
  $$ScheduleTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotMinutes => $composableBuilder(
      column: $table.slotMinutes, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get staffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduleTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleTemplatesTable> {
  $$ScheduleTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get slotMinutes => $composableBuilder(
      column: $table.slotMinutes, builder: (column) => column);

  $$UsersTableAnnotationComposer get staffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduleTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduleTemplatesTable,
    ScheduleTemplate,
    $$ScheduleTemplatesTableFilterComposer,
    $$ScheduleTemplatesTableOrderingComposer,
    $$ScheduleTemplatesTableAnnotationComposer,
    $$ScheduleTemplatesTableCreateCompanionBuilder,
    $$ScheduleTemplatesTableUpdateCompanionBuilder,
    (ScheduleTemplate, $$ScheduleTemplatesTableReferences),
    ScheduleTemplate,
    PrefetchHooks Function({bool staffId})> {
  $$ScheduleTemplatesTableTableManager(
      _$AppDatabase db, $ScheduleTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleTemplatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> staffId = const Value.absent(),
            Value<int> weekday = const Value.absent(),
            Value<String> startTime = const Value.absent(),
            Value<String> endTime = const Value.absent(),
            Value<int> slotMinutes = const Value.absent(),
          }) =>
              ScheduleTemplatesCompanion(
            id: id,
            staffId: staffId,
            weekday: weekday,
            startTime: startTime,
            endTime: endTime,
            slotMinutes: slotMinutes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int staffId,
            required int weekday,
            required String startTime,
            required String endTime,
            Value<int> slotMinutes = const Value.absent(),
          }) =>
              ScheduleTemplatesCompanion.insert(
            id: id,
            staffId: staffId,
            weekday: weekday,
            startTime: startTime,
            endTime: endTime,
            slotMinutes: slotMinutes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduleTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$ScheduleTemplatesTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$ScheduleTemplatesTableReferences._staffIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ScheduleTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduleTemplatesTable,
    ScheduleTemplate,
    $$ScheduleTemplatesTableFilterComposer,
    $$ScheduleTemplatesTableOrderingComposer,
    $$ScheduleTemplatesTableAnnotationComposer,
    $$ScheduleTemplatesTableCreateCompanionBuilder,
    $$ScheduleTemplatesTableUpdateCompanionBuilder,
    (ScheduleTemplate, $$ScheduleTemplatesTableReferences),
    ScheduleTemplate,
    PrefetchHooks Function({bool staffId})>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required int appointmentId,
  required DateTime scheduledFor,
  required ReminderChannel channel,
  Value<DateTime?> sentAt,
  required ReminderKind kind,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int> appointmentId,
  Value<DateTime> scheduledFor,
  Value<ReminderChannel> channel,
  Value<DateTime?> sentAt,
  Value<ReminderKind> kind,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppointmentsTable _appointmentIdTable(_$AppDatabase db) =>
      db.appointments
          .createAlias('reminders__appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager get appointmentId {
    final $_column = $_itemColumn<int>('appointment_id')!;

    final manager = $$AppointmentsTableTableManager($_db, $_db.appointments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ReminderChannel, ReminderChannel, String>
      get channel => $composableBuilder(
          column: $table.channel,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ReminderKind, ReminderKind, String> get kind =>
      $composableBuilder(
          column: $table.kind,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.appointmentId,
        referencedTable: $db.appointments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppointmentsTableFilterComposer(
              $db: $db,
              $table: $db.appointments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.appointmentId,
        referencedTable: $db.appointments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppointmentsTableOrderingComposer(
              $db: $db,
              $table: $db.appointments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderChannel, String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.appointmentId,
        referencedTable: $db.appointments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppointmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.appointments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool appointmentId})> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> appointmentId = const Value.absent(),
            Value<DateTime> scheduledFor = const Value.absent(),
            Value<ReminderChannel> channel = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
            Value<ReminderKind> kind = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            appointmentId: appointmentId,
            scheduledFor: scheduledFor,
            channel: channel,
            sentAt: sentAt,
            kind: kind,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int appointmentId,
            required DateTime scheduledFor,
            required ReminderChannel channel,
            Value<DateTime?> sentAt = const Value.absent(),
            required ReminderKind kind,
          }) =>
              RemindersCompanion.insert(
            id: id,
            appointmentId: appointmentId,
            scheduledFor: scheduledFor,
            channel: channel,
            sentAt: sentAt,
            kind: kind,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({appointmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (appointmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.appointmentId,
                    referencedTable:
                        $$RemindersTableReferences._appointmentIdTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._appointmentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool appointmentId})>;
typedef $$MedicalRecordsTableCreateCompanionBuilder = MedicalRecordsCompanion
    Function({
  Value<int> id,
  required int patientId,
  Value<int?> authorStaffId,
  required RecordType recordType,
  required String title,
  required String body,
  required DateTime occurredAt,
  required String sourceFacility,
  Value<String?> attachmentPath,
  Value<String?> extractedText,
  Value<DateTime> createdAt,
});
typedef $$MedicalRecordsTableUpdateCompanionBuilder = MedicalRecordsCompanion
    Function({
  Value<int> id,
  Value<int> patientId,
  Value<int?> authorStaffId,
  Value<RecordType> recordType,
  Value<String> title,
  Value<String> body,
  Value<DateTime> occurredAt,
  Value<String> sourceFacility,
  Value<String?> attachmentPath,
  Value<String?> extractedText,
  Value<DateTime> createdAt,
});

final class $$MedicalRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicalRecordsTable, MedicalRecord> {
  $$MedicalRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('medical_records__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _authorStaffIdTable(_$AppDatabase db) =>
      db.users.createAlias('medical_records__author_staff_id__users__id');

  $$UsersTableProcessedTableManager? get authorStaffId {
    final $_column = $_itemColumn<int>('author_staff_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_authorStaffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LabValuesTable, List<LabValue>>
      _labValuesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.labValues,
              aliasName: 'medical_records__id__lab_values__record_id');

  $$LabValuesTableProcessedTableManager get labValuesRefs {
    final manager = $$LabValuesTableTableManager($_db, $_db.labValues)
        .filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_labValuesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecordType, RecordType, String>
      get recordType => $composableBuilder(
          column: $table.recordType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceFacility => $composableBuilder(
      column: $table.sourceFacility,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extractedText => $composableBuilder(
      column: $table.extractedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get authorStaffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.authorStaffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> labValuesRefs(
      Expression<bool> Function($$LabValuesTableFilterComposer f) f) {
    final $$LabValuesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.labValues,
        getReferencedColumn: (t) => t.recordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LabValuesTableFilterComposer(
              $db: $db,
              $table: $db.labValues,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceFacility => $composableBuilder(
      column: $table.sourceFacility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extractedText => $composableBuilder(
      column: $table.extractedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get authorStaffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.authorStaffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecordType, String> get recordType =>
      $composableBuilder(
          column: $table.recordType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get sourceFacility => $composableBuilder(
      column: $table.sourceFacility, builder: (column) => column);

  GeneratedColumn<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
      column: $table.extractedText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get authorStaffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.authorStaffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> labValuesRefs<T extends Object>(
      Expression<T> Function($$LabValuesTableAnnotationComposer a) f) {
    final $$LabValuesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.labValues,
        getReferencedColumn: (t) => t.recordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LabValuesTableAnnotationComposer(
              $db: $db,
              $table: $db.labValues,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicalRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicalRecordsTable,
    MedicalRecord,
    $$MedicalRecordsTableFilterComposer,
    $$MedicalRecordsTableOrderingComposer,
    $$MedicalRecordsTableAnnotationComposer,
    $$MedicalRecordsTableCreateCompanionBuilder,
    $$MedicalRecordsTableUpdateCompanionBuilder,
    (MedicalRecord, $$MedicalRecordsTableReferences),
    MedicalRecord,
    PrefetchHooks Function(
        {bool patientId, bool authorStaffId, bool labValuesRefs})> {
  $$MedicalRecordsTableTableManager(
      _$AppDatabase db, $MedicalRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<int?> authorStaffId = const Value.absent(),
            Value<RecordType> recordType = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String> sourceFacility = const Value.absent(),
            Value<String?> attachmentPath = const Value.absent(),
            Value<String?> extractedText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              MedicalRecordsCompanion(
            id: id,
            patientId: patientId,
            authorStaffId: authorStaffId,
            recordType: recordType,
            title: title,
            body: body,
            occurredAt: occurredAt,
            sourceFacility: sourceFacility,
            attachmentPath: attachmentPath,
            extractedText: extractedText,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            Value<int?> authorStaffId = const Value.absent(),
            required RecordType recordType,
            required String title,
            required String body,
            required DateTime occurredAt,
            required String sourceFacility,
            Value<String?> attachmentPath = const Value.absent(),
            Value<String?> extractedText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              MedicalRecordsCompanion.insert(
            id: id,
            patientId: patientId,
            authorStaffId: authorStaffId,
            recordType: recordType,
            title: title,
            body: body,
            occurredAt: occurredAt,
            sourceFacility: sourceFacility,
            attachmentPath: attachmentPath,
            extractedText: extractedText,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicalRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {patientId = false,
              authorStaffId = false,
              labValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (labValuesRefs) db.labValues],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$MedicalRecordsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$MedicalRecordsTableReferences._patientIdTable(db).id,
                  ) as T;
                }
                if (authorStaffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.authorStaffId,
                    referencedTable:
                        $$MedicalRecordsTableReferences._authorStaffIdTable(db),
                    referencedColumn: $$MedicalRecordsTableReferences
                        ._authorStaffIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (labValuesRefs)
                    await $_getPrefetchedData<MedicalRecord,
                            $MedicalRecordsTable, LabValue>(
                        currentTable: table,
                        referencedTable: $$MedicalRecordsTableReferences
                            ._labValuesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicalRecordsTableReferences(db, table, p0)
                                .labValuesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicalRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicalRecordsTable,
    MedicalRecord,
    $$MedicalRecordsTableFilterComposer,
    $$MedicalRecordsTableOrderingComposer,
    $$MedicalRecordsTableAnnotationComposer,
    $$MedicalRecordsTableCreateCompanionBuilder,
    $$MedicalRecordsTableUpdateCompanionBuilder,
    (MedicalRecord, $$MedicalRecordsTableReferences),
    MedicalRecord,
    PrefetchHooks Function(
        {bool patientId, bool authorStaffId, bool labValuesRefs})>;
typedef $$LabValuesTableCreateCompanionBuilder = LabValuesCompanion Function({
  Value<int> id,
  required int recordId,
  required String analyte,
  required double value,
  required String unit,
  required double refLow,
  required double refHigh,
  Value<bool> abnormalFlag,
});
typedef $$LabValuesTableUpdateCompanionBuilder = LabValuesCompanion Function({
  Value<int> id,
  Value<int> recordId,
  Value<String> analyte,
  Value<double> value,
  Value<String> unit,
  Value<double> refLow,
  Value<double> refHigh,
  Value<bool> abnormalFlag,
});

final class $$LabValuesTableReferences
    extends BaseReferences<_$AppDatabase, $LabValuesTable, LabValue> {
  $$LabValuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.medicalRecords
          .createAlias('lab_values__record_id__medical_records__id');

  $$MedicalRecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<int>('record_id')!;

    final manager = $$MedicalRecordsTableTableManager($_db, $_db.medicalRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LabValuesTableFilterComposer
    extends Composer<_$AppDatabase, $LabValuesTable> {
  $$LabValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get analyte => $composableBuilder(
      column: $table.analyte, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get refLow => $composableBuilder(
      column: $table.refLow, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get refHigh => $composableBuilder(
      column: $table.refHigh, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get abnormalFlag => $composableBuilder(
      column: $table.abnormalFlag, builder: (column) => ColumnFilters(column));

  $$MedicalRecordsTableFilterComposer get recordId {
    final $$MedicalRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.medicalRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicalRecordsTableFilterComposer(
              $db: $db,
              $table: $db.medicalRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LabValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $LabValuesTable> {
  $$LabValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get analyte => $composableBuilder(
      column: $table.analyte, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get refLow => $composableBuilder(
      column: $table.refLow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get refHigh => $composableBuilder(
      column: $table.refHigh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get abnormalFlag => $composableBuilder(
      column: $table.abnormalFlag,
      builder: (column) => ColumnOrderings(column));

  $$MedicalRecordsTableOrderingComposer get recordId {
    final $$MedicalRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.medicalRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicalRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.medicalRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LabValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabValuesTable> {
  $$LabValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get analyte =>
      $composableBuilder(column: $table.analyte, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get refLow =>
      $composableBuilder(column: $table.refLow, builder: (column) => column);

  GeneratedColumn<double> get refHigh =>
      $composableBuilder(column: $table.refHigh, builder: (column) => column);

  GeneratedColumn<bool> get abnormalFlag => $composableBuilder(
      column: $table.abnormalFlag, builder: (column) => column);

  $$MedicalRecordsTableAnnotationComposer get recordId {
    final $$MedicalRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.medicalRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicalRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.medicalRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LabValuesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LabValuesTable,
    LabValue,
    $$LabValuesTableFilterComposer,
    $$LabValuesTableOrderingComposer,
    $$LabValuesTableAnnotationComposer,
    $$LabValuesTableCreateCompanionBuilder,
    $$LabValuesTableUpdateCompanionBuilder,
    (LabValue, $$LabValuesTableReferences),
    LabValue,
    PrefetchHooks Function({bool recordId})> {
  $$LabValuesTableTableManager(_$AppDatabase db, $LabValuesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recordId = const Value.absent(),
            Value<String> analyte = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> refLow = const Value.absent(),
            Value<double> refHigh = const Value.absent(),
            Value<bool> abnormalFlag = const Value.absent(),
          }) =>
              LabValuesCompanion(
            id: id,
            recordId: recordId,
            analyte: analyte,
            value: value,
            unit: unit,
            refLow: refLow,
            refHigh: refHigh,
            abnormalFlag: abnormalFlag,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recordId,
            required String analyte,
            required double value,
            required String unit,
            required double refLow,
            required double refHigh,
            Value<bool> abnormalFlag = const Value.absent(),
          }) =>
              LabValuesCompanion.insert(
            id: id,
            recordId: recordId,
            analyte: analyte,
            value: value,
            unit: unit,
            refLow: refLow,
            refHigh: refHigh,
            abnormalFlag: abnormalFlag,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LabValuesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordId,
                    referencedTable:
                        $$LabValuesTableReferences._recordIdTable(db),
                    referencedColumn:
                        $$LabValuesTableReferences._recordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LabValuesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LabValuesTable,
    LabValue,
    $$LabValuesTableFilterComposer,
    $$LabValuesTableOrderingComposer,
    $$LabValuesTableAnnotationComposer,
    $$LabValuesTableCreateCompanionBuilder,
    $$LabValuesTableUpdateCompanionBuilder,
    (LabValue, $$LabValuesTableReferences),
    LabValue,
    PrefetchHooks Function({bool recordId})>;
typedef $$VitalsTableCreateCompanionBuilder = VitalsCompanion Function({
  Value<int> id,
  required int patientId,
  required DateTime recordedAt,
  Value<double?> systolic,
  Value<double?> diastolic,
  Value<double?> heartRate,
  Value<double?> tempC,
  Value<double?> weightKg,
  Value<double?> heightCm,
  Value<double?> spo2,
  Value<double?> glucose,
});
typedef $$VitalsTableUpdateCompanionBuilder = VitalsCompanion Function({
  Value<int> id,
  Value<int> patientId,
  Value<DateTime> recordedAt,
  Value<double?> systolic,
  Value<double?> diastolic,
  Value<double?> heartRate,
  Value<double?> tempC,
  Value<double?> weightKg,
  Value<double?> heightCm,
  Value<double?> spo2,
  Value<double?> glucose,
});

final class $$VitalsTableReferences
    extends BaseReferences<_$AppDatabase, $VitalsTable, Vital> {
  $$VitalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('vitals__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$VitalsTableFilterComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get systolic => $composableBuilder(
      column: $table.systolic, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get diastolic => $composableBuilder(
      column: $table.diastolic, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heartRate => $composableBuilder(
      column: $table.heartRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tempC => $composableBuilder(
      column: $table.tempC, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get spo2 => $composableBuilder(
      column: $table.spo2, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get glucose => $composableBuilder(
      column: $table.glucose, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VitalsTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get systolic => $composableBuilder(
      column: $table.systolic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get diastolic => $composableBuilder(
      column: $table.diastolic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heartRate => $composableBuilder(
      column: $table.heartRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tempC => $composableBuilder(
      column: $table.tempC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get spo2 => $composableBuilder(
      column: $table.spo2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get glucose => $composableBuilder(
      column: $table.glucose, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VitalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<double> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<double> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<double> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<double> get tempC =>
      $composableBuilder(column: $table.tempC, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<double> get glucose =>
      $composableBuilder(column: $table.glucose, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VitalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VitalsTable,
    Vital,
    $$VitalsTableFilterComposer,
    $$VitalsTableOrderingComposer,
    $$VitalsTableAnnotationComposer,
    $$VitalsTableCreateCompanionBuilder,
    $$VitalsTableUpdateCompanionBuilder,
    (Vital, $$VitalsTableReferences),
    Vital,
    PrefetchHooks Function({bool patientId})> {
  $$VitalsTableTableManager(_$AppDatabase db, $VitalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<double?> systolic = const Value.absent(),
            Value<double?> diastolic = const Value.absent(),
            Value<double?> heartRate = const Value.absent(),
            Value<double?> tempC = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<double?> spo2 = const Value.absent(),
            Value<double?> glucose = const Value.absent(),
          }) =>
              VitalsCompanion(
            id: id,
            patientId: patientId,
            recordedAt: recordedAt,
            systolic: systolic,
            diastolic: diastolic,
            heartRate: heartRate,
            tempC: tempC,
            weightKg: weightKg,
            heightCm: heightCm,
            spo2: spo2,
            glucose: glucose,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            required DateTime recordedAt,
            Value<double?> systolic = const Value.absent(),
            Value<double?> diastolic = const Value.absent(),
            Value<double?> heartRate = const Value.absent(),
            Value<double?> tempC = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<double?> spo2 = const Value.absent(),
            Value<double?> glucose = const Value.absent(),
          }) =>
              VitalsCompanion.insert(
            id: id,
            patientId: patientId,
            recordedAt: recordedAt,
            systolic: systolic,
            diastolic: diastolic,
            heartRate: heartRate,
            tempC: tempC,
            weightKg: weightKg,
            heightCm: heightCm,
            spo2: spo2,
            glucose: glucose,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VitalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$VitalsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$VitalsTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$VitalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VitalsTable,
    Vital,
    $$VitalsTableFilterComposer,
    $$VitalsTableOrderingComposer,
    $$VitalsTableAnnotationComposer,
    $$VitalsTableCreateCompanionBuilder,
    $$VitalsTableUpdateCompanionBuilder,
    (Vital, $$VitalsTableReferences),
    Vital,
    PrefetchHooks Function({bool patientId})>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  required int patientId,
  Value<int?> prescriberId,
  required String name,
  required String dose,
  required String frequency,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  Value<int> patientId,
  Value<int?> prescriberId,
  Value<String> name,
  Value<String> dose,
  Value<String> frequency,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
});

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('medications__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _prescriberIdTable(_$AppDatabase db) =>
      db.users.createAlias('medications__prescriber_id__users__id');

  $$UsersTableProcessedTableManager? get prescriberId {
    final $_column = $_itemColumn<int>('prescriber_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prescriberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get prescriberId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.prescriberId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get prescriberId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.prescriberId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get prescriberId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.prescriberId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool patientId, bool prescriberId})> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<int?> prescriberId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> dose = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            patientId: patientId,
            prescriberId: prescriberId,
            name: name,
            dose: dose,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            Value<int?> prescriberId = const Value.absent(),
            required String name,
            required String dose,
            required String frequency,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            patientId: patientId,
            prescriberId: prescriberId,
            name: name,
            dose: dose,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false, prescriberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$MedicationsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$MedicationsTableReferences._patientIdTable(db).id,
                  ) as T;
                }
                if (prescriberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.prescriberId,
                    referencedTable:
                        $$MedicationsTableReferences._prescriberIdTable(db),
                    referencedColumn:
                        $$MedicationsTableReferences._prescriberIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool patientId, bool prescriberId})>;
typedef $$AiSummariesTableCreateCompanionBuilder = AiSummariesCompanion
    Function({
  Value<int> id,
  required int patientId,
  Value<DateTime> generatedAt,
  required String modelId,
  required String promptVersion,
  required String summaryMarkdown,
  required String keyEventsJson,
  required String trendsJson,
  required String redFlagsJson,
  required String inputHash,
});
typedef $$AiSummariesTableUpdateCompanionBuilder = AiSummariesCompanion
    Function({
  Value<int> id,
  Value<int> patientId,
  Value<DateTime> generatedAt,
  Value<String> modelId,
  Value<String> promptVersion,
  Value<String> summaryMarkdown,
  Value<String> keyEventsJson,
  Value<String> trendsJson,
  Value<String> redFlagsJson,
  Value<String> inputHash,
});

final class $$AiSummariesTableReferences
    extends BaseReferences<_$AppDatabase, $AiSummariesTable, AiSummary> {
  $$AiSummariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('ai_summaries__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AiSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $AiSummariesTable> {
  $$AiSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get promptVersion => $composableBuilder(
      column: $table.promptVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summaryMarkdown => $composableBuilder(
      column: $table.summaryMarkdown,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyEventsJson => $composableBuilder(
      column: $table.keyEventsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trendsJson => $composableBuilder(
      column: $table.trendsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get redFlagsJson => $composableBuilder(
      column: $table.redFlagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputHash => $composableBuilder(
      column: $table.inputHash, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AiSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $AiSummariesTable> {
  $$AiSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get promptVersion => $composableBuilder(
      column: $table.promptVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summaryMarkdown => $composableBuilder(
      column: $table.summaryMarkdown,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyEventsJson => $composableBuilder(
      column: $table.keyEventsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trendsJson => $composableBuilder(
      column: $table.trendsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get redFlagsJson => $composableBuilder(
      column: $table.redFlagsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputHash => $composableBuilder(
      column: $table.inputHash, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AiSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiSummariesTable> {
  $$AiSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get promptVersion => $composableBuilder(
      column: $table.promptVersion, builder: (column) => column);

  GeneratedColumn<String> get summaryMarkdown => $composableBuilder(
      column: $table.summaryMarkdown, builder: (column) => column);

  GeneratedColumn<String> get keyEventsJson => $composableBuilder(
      column: $table.keyEventsJson, builder: (column) => column);

  GeneratedColumn<String> get trendsJson => $composableBuilder(
      column: $table.trendsJson, builder: (column) => column);

  GeneratedColumn<String> get redFlagsJson => $composableBuilder(
      column: $table.redFlagsJson, builder: (column) => column);

  GeneratedColumn<String> get inputHash =>
      $composableBuilder(column: $table.inputHash, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AiSummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiSummariesTable,
    AiSummary,
    $$AiSummariesTableFilterComposer,
    $$AiSummariesTableOrderingComposer,
    $$AiSummariesTableAnnotationComposer,
    $$AiSummariesTableCreateCompanionBuilder,
    $$AiSummariesTableUpdateCompanionBuilder,
    (AiSummary, $$AiSummariesTableReferences),
    AiSummary,
    PrefetchHooks Function({bool patientId})> {
  $$AiSummariesTableTableManager(_$AppDatabase db, $AiSummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<String> modelId = const Value.absent(),
            Value<String> promptVersion = const Value.absent(),
            Value<String> summaryMarkdown = const Value.absent(),
            Value<String> keyEventsJson = const Value.absent(),
            Value<String> trendsJson = const Value.absent(),
            Value<String> redFlagsJson = const Value.absent(),
            Value<String> inputHash = const Value.absent(),
          }) =>
              AiSummariesCompanion(
            id: id,
            patientId: patientId,
            generatedAt: generatedAt,
            modelId: modelId,
            promptVersion: promptVersion,
            summaryMarkdown: summaryMarkdown,
            keyEventsJson: keyEventsJson,
            trendsJson: trendsJson,
            redFlagsJson: redFlagsJson,
            inputHash: inputHash,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            Value<DateTime> generatedAt = const Value.absent(),
            required String modelId,
            required String promptVersion,
            required String summaryMarkdown,
            required String keyEventsJson,
            required String trendsJson,
            required String redFlagsJson,
            required String inputHash,
          }) =>
              AiSummariesCompanion.insert(
            id: id,
            patientId: patientId,
            generatedAt: generatedAt,
            modelId: modelId,
            promptVersion: promptVersion,
            summaryMarkdown: summaryMarkdown,
            keyEventsJson: keyEventsJson,
            trendsJson: trendsJson,
            redFlagsJson: redFlagsJson,
            inputHash: inputHash,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AiSummariesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$AiSummariesTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$AiSummariesTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AiSummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiSummariesTable,
    AiSummary,
    $$AiSummariesTableFilterComposer,
    $$AiSummariesTableOrderingComposer,
    $$AiSummariesTableAnnotationComposer,
    $$AiSummariesTableCreateCompanionBuilder,
    $$AiSummariesTableUpdateCompanionBuilder,
    (AiSummary, $$AiSummariesTableReferences),
    AiSummary,
    PrefetchHooks Function({bool patientId})>;
typedef $$RiskFlagsTableCreateCompanionBuilder = RiskFlagsCompanion Function({
  Value<int> id,
  required int patientId,
  required String kind,
  required RiskSeverity severity,
  required String rationale,
  Value<DateTime> detectedAt,
  required RiskSource source,
  Value<int?> acknowledgedBy,
  Value<DateTime?> acknowledgedAt,
});
typedef $$RiskFlagsTableUpdateCompanionBuilder = RiskFlagsCompanion Function({
  Value<int> id,
  Value<int> patientId,
  Value<String> kind,
  Value<RiskSeverity> severity,
  Value<String> rationale,
  Value<DateTime> detectedAt,
  Value<RiskSource> source,
  Value<int?> acknowledgedBy,
  Value<DateTime?> acknowledgedAt,
});

final class $$RiskFlagsTableReferences
    extends BaseReferences<_$AppDatabase, $RiskFlagsTable, RiskFlag> {
  $$RiskFlagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('risk_flags__patient_id__users__id');

  $$UsersTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _acknowledgedByTable(_$AppDatabase db) =>
      db.users.createAlias('risk_flags__acknowledged_by__users__id');

  $$UsersTableProcessedTableManager? get acknowledgedBy {
    final $_column = $_itemColumn<int>('acknowledged_by');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_acknowledgedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RiskFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $RiskFlagsTable> {
  $$RiskFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RiskSeverity, RiskSeverity, String>
      get severity => $composableBuilder(
          column: $table.severity,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get rationale => $composableBuilder(
      column: $table.rationale, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RiskSource, RiskSource, String> get source =>
      $composableBuilder(
          column: $table.source,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get acknowledgedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.acknowledgedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RiskFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $RiskFlagsTable> {
  $$RiskFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rationale => $composableBuilder(
      column: $table.rationale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get acknowledgedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.acknowledgedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RiskFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiskFlagsTable> {
  $$RiskFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RiskSeverity, String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get rationale =>
      $composableBuilder(column: $table.rationale, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RiskSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get acknowledgedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.acknowledgedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RiskFlagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RiskFlagsTable,
    RiskFlag,
    $$RiskFlagsTableFilterComposer,
    $$RiskFlagsTableOrderingComposer,
    $$RiskFlagsTableAnnotationComposer,
    $$RiskFlagsTableCreateCompanionBuilder,
    $$RiskFlagsTableUpdateCompanionBuilder,
    (RiskFlag, $$RiskFlagsTableReferences),
    RiskFlag,
    PrefetchHooks Function({bool patientId, bool acknowledgedBy})> {
  $$RiskFlagsTableTableManager(_$AppDatabase db, $RiskFlagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiskFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiskFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiskFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<RiskSeverity> severity = const Value.absent(),
            Value<String> rationale = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
            Value<RiskSource> source = const Value.absent(),
            Value<int?> acknowledgedBy = const Value.absent(),
            Value<DateTime?> acknowledgedAt = const Value.absent(),
          }) =>
              RiskFlagsCompanion(
            id: id,
            patientId: patientId,
            kind: kind,
            severity: severity,
            rationale: rationale,
            detectedAt: detectedAt,
            source: source,
            acknowledgedBy: acknowledgedBy,
            acknowledgedAt: acknowledgedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int patientId,
            required String kind,
            required RiskSeverity severity,
            required String rationale,
            Value<DateTime> detectedAt = const Value.absent(),
            required RiskSource source,
            Value<int?> acknowledgedBy = const Value.absent(),
            Value<DateTime?> acknowledgedAt = const Value.absent(),
          }) =>
              RiskFlagsCompanion.insert(
            id: id,
            patientId: patientId,
            kind: kind,
            severity: severity,
            rationale: rationale,
            detectedAt: detectedAt,
            source: source,
            acknowledgedBy: acknowledgedBy,
            acknowledgedAt: acknowledgedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RiskFlagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false, acknowledgedBy = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$RiskFlagsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$RiskFlagsTableReferences._patientIdTable(db).id,
                  ) as T;
                }
                if (acknowledgedBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.acknowledgedBy,
                    referencedTable:
                        $$RiskFlagsTableReferences._acknowledgedByTable(db),
                    referencedColumn:
                        $$RiskFlagsTableReferences._acknowledgedByTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RiskFlagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RiskFlagsTable,
    RiskFlag,
    $$RiskFlagsTableFilterComposer,
    $$RiskFlagsTableOrderingComposer,
    $$RiskFlagsTableAnnotationComposer,
    $$RiskFlagsTableCreateCompanionBuilder,
    $$RiskFlagsTableUpdateCompanionBuilder,
    (RiskFlag, $$RiskFlagsTableReferences),
    RiskFlag,
    PrefetchHooks Function({bool patientId, bool acknowledgedBy})>;
typedef $$StaffTasksTableCreateCompanionBuilder = StaffTasksCompanion Function({
  Value<int> id,
  required int staffId,
  Value<int?> patientId,
  required String title,
  required TaskKind kind,
  required DateTime dueAt,
  Value<TaskStatus> status,
  Value<double> ruleScore,
  Value<double?> aiPriorityScore,
  Value<String?> aiRationale,
  Value<DateTime> createdAt,
});
typedef $$StaffTasksTableUpdateCompanionBuilder = StaffTasksCompanion Function({
  Value<int> id,
  Value<int> staffId,
  Value<int?> patientId,
  Value<String> title,
  Value<TaskKind> kind,
  Value<DateTime> dueAt,
  Value<TaskStatus> status,
  Value<double> ruleScore,
  Value<double?> aiPriorityScore,
  Value<String?> aiRationale,
  Value<DateTime> createdAt,
});

final class $$StaffTasksTableReferences
    extends BaseReferences<_$AppDatabase, $StaffTasksTable, StaffTask> {
  $$StaffTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _staffIdTable(_$AppDatabase db) =>
      db.users.createAlias('staff_tasks__staff_id__users__id');

  $$UsersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _patientIdTable(_$AppDatabase db) =>
      db.users.createAlias('staff_tasks__patient_id__users__id');

  $$UsersTableProcessedTableManager? get patientId {
    final $_column = $_itemColumn<int>('patient_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StaffTasksTableFilterComposer
    extends Composer<_$AppDatabase, $StaffTasksTable> {
  $$StaffTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TaskKind, TaskKind, String> get kind =>
      $composableBuilder(
          column: $table.kind,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get ruleScore => $composableBuilder(
      column: $table.ruleScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get aiPriorityScore => $composableBuilder(
      column: $table.aiPriorityScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiRationale => $composableBuilder(
      column: $table.aiRationale, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get staffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get patientId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffTasksTable> {
  $$StaffTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ruleScore => $composableBuilder(
      column: $table.ruleScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get aiPriorityScore => $composableBuilder(
      column: $table.aiPriorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiRationale => $composableBuilder(
      column: $table.aiRationale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get staffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get patientId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffTasksTable> {
  $$StaffTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get ruleScore =>
      $composableBuilder(column: $table.ruleScore, builder: (column) => column);

  GeneratedColumn<double> get aiPriorityScore => $composableBuilder(
      column: $table.aiPriorityScore, builder: (column) => column);

  GeneratedColumn<String> get aiRationale => $composableBuilder(
      column: $table.aiRationale, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get staffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get patientId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaffTasksTable,
    StaffTask,
    $$StaffTasksTableFilterComposer,
    $$StaffTasksTableOrderingComposer,
    $$StaffTasksTableAnnotationComposer,
    $$StaffTasksTableCreateCompanionBuilder,
    $$StaffTasksTableUpdateCompanionBuilder,
    (StaffTask, $$StaffTasksTableReferences),
    StaffTask,
    PrefetchHooks Function({bool staffId, bool patientId})> {
  $$StaffTasksTableTableManager(_$AppDatabase db, $StaffTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> staffId = const Value.absent(),
            Value<int?> patientId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<TaskKind> kind = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<TaskStatus> status = const Value.absent(),
            Value<double> ruleScore = const Value.absent(),
            Value<double?> aiPriorityScore = const Value.absent(),
            Value<String?> aiRationale = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StaffTasksCompanion(
            id: id,
            staffId: staffId,
            patientId: patientId,
            title: title,
            kind: kind,
            dueAt: dueAt,
            status: status,
            ruleScore: ruleScore,
            aiPriorityScore: aiPriorityScore,
            aiRationale: aiRationale,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int staffId,
            Value<int?> patientId = const Value.absent(),
            required String title,
            required TaskKind kind,
            required DateTime dueAt,
            Value<TaskStatus> status = const Value.absent(),
            Value<double> ruleScore = const Value.absent(),
            Value<double?> aiPriorityScore = const Value.absent(),
            Value<String?> aiRationale = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StaffTasksCompanion.insert(
            id: id,
            staffId: staffId,
            patientId: patientId,
            title: title,
            kind: kind,
            dueAt: dueAt,
            status: status,
            ruleScore: ruleScore,
            aiPriorityScore: aiPriorityScore,
            aiRationale: aiRationale,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StaffTasksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({staffId = false, patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$StaffTasksTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$StaffTasksTableReferences._staffIdTable(db).id,
                  ) as T;
                }
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$StaffTasksTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$StaffTasksTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StaffTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaffTasksTable,
    StaffTask,
    $$StaffTasksTableFilterComposer,
    $$StaffTasksTableOrderingComposer,
    $$StaffTasksTableAnnotationComposer,
    $$StaffTasksTableCreateCompanionBuilder,
    $$StaffTasksTableUpdateCompanionBuilder,
    (StaffTask, $$StaffTasksTableReferences),
    StaffTask,
    PrefetchHooks Function({bool staffId, bool patientId})>;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<int?> actorUserId,
  required String action,
  required String entityType,
  Value<int?> entityId,
  Value<DateTime> timestamp,
  Value<String?> metadataJson,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<int?> actorUserId,
  Value<String> action,
  Value<String> entityType,
  Value<int?> entityId,
  Value<DateTime> timestamp,
  Value<String?> metadataJson,
});

final class $$AuditLogTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData> {
  $$AuditLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _actorUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('audit_log__actor_user_id__users__id');

  $$UsersTableProcessedTableManager? get actorUserId {
    final $_column = $_itemColumn<int>('actor_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get actorUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actorUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get actorUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actorUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  $$UsersTableAnnotationComposer get actorUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.actorUserId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogTable,
    AuditLogData,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditLogData, $$AuditLogTableReferences),
    AuditLogData,
    PrefetchHooks Function({bool actorUserId})> {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> actorUserId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int?> entityId = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
          }) =>
              AuditLogCompanion(
            id: id,
            actorUserId: actorUserId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            timestamp: timestamp,
            metadataJson: metadataJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> actorUserId = const Value.absent(),
            required String action,
            required String entityType,
            Value<int?> entityId = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
          }) =>
              AuditLogCompanion.insert(
            id: id,
            actorUserId: actorUserId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            timestamp: timestamp,
            metadataJson: metadataJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AuditLogTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({actorUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (actorUserId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.actorUserId,
                    referencedTable:
                        $$AuditLogTableReferences._actorUserIdTable(db),
                    referencedColumn:
                        $$AuditLogTableReferences._actorUserIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AuditLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogTable,
    AuditLogData,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditLogData, $$AuditLogTableReferences),
    AuditLogData,
    PrefetchHooks Function({bool actorUserId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<bool> aiEnabled,
  Value<bool> mockMode,
  Value<String> modelId,
  Value<int> seedVersion,
  Value<DateTime?> lastSeededAt,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<bool> aiEnabled,
  Value<bool> mockMode,
  Value<String> modelId,
  Value<int> seedVersion,
  Value<DateTime?> lastSeededAt,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get aiEnabled => $composableBuilder(
      column: $table.aiEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get mockMode => $composableBuilder(
      column: $table.mockMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seedVersion => $composableBuilder(
      column: $table.seedVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSeededAt => $composableBuilder(
      column: $table.lastSeededAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get aiEnabled => $composableBuilder(
      column: $table.aiEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get mockMode => $composableBuilder(
      column: $table.mockMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seedVersion => $composableBuilder(
      column: $table.seedVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSeededAt => $composableBuilder(
      column: $table.lastSeededAt,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get aiEnabled =>
      $composableBuilder(column: $table.aiEnabled, builder: (column) => column);

  GeneratedColumn<bool> get mockMode =>
      $composableBuilder(column: $table.mockMode, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<int> get seedVersion => $composableBuilder(
      column: $table.seedVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeededAt => $composableBuilder(
      column: $table.lastSeededAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> aiEnabled = const Value.absent(),
            Value<bool> mockMode = const Value.absent(),
            Value<String> modelId = const Value.absent(),
            Value<int> seedVersion = const Value.absent(),
            Value<DateTime?> lastSeededAt = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            aiEnabled: aiEnabled,
            mockMode: mockMode,
            modelId: modelId,
            seedVersion: seedVersion,
            lastSeededAt: lastSeededAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> aiEnabled = const Value.absent(),
            Value<bool> mockMode = const Value.absent(),
            Value<String> modelId = const Value.absent(),
            Value<int> seedVersion = const Value.absent(),
            Value<DateTime?> lastSeededAt = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            aiEnabled: aiEnabled,
            mockMode: mockMode,
            modelId: modelId,
            seedVersion: seedVersion,
            lastSeededAt: lastSeededAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$StaffProfilesTableTableManager get staffProfiles =>
      $$StaffProfilesTableTableManager(_db, _db.staffProfiles);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$ScheduleTemplatesTableTableManager get scheduleTemplates =>
      $$ScheduleTemplatesTableTableManager(_db, _db.scheduleTemplates);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$MedicalRecordsTableTableManager get medicalRecords =>
      $$MedicalRecordsTableTableManager(_db, _db.medicalRecords);
  $$LabValuesTableTableManager get labValues =>
      $$LabValuesTableTableManager(_db, _db.labValues);
  $$VitalsTableTableManager get vitals =>
      $$VitalsTableTableManager(_db, _db.vitals);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$AiSummariesTableTableManager get aiSummaries =>
      $$AiSummariesTableTableManager(_db, _db.aiSummaries);
  $$RiskFlagsTableTableManager get riskFlags =>
      $$RiskFlagsTableTableManager(_db, _db.riskFlags);
  $$StaffTasksTableTableManager get staffTasks =>
      $$StaffTasksTableTableManager(_db, _db.staffTasks);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
