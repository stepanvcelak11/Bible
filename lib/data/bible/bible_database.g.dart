// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_database.dart';

// ignore_for_file: type=lint
class Meta extends Table with TableInfo<Meta, MetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Meta(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  Meta createAlias(String alias) {
    return Meta(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MetaData extends DataClass implements Insertable<MetaData> {
  final String key;
  final String value;
  const MetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaData copyWith({String? key, String? value}) =>
      MetaData(key: key ?? this.key, value: value ?? this.value);
  MetaData copyWithCompanion(MetaCompanion data) {
    return MetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaData && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Translations extends Table with TableInfo<Translations, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Translations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'cs\'',
    defaultValue: const CustomExpression('\'cs\''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _licenseMeta = const VerificationMeta(
    'license',
  );
  late final GeneratedColumn<String> license = GeneratedColumn<String>(
    'license',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    abbreviation,
    language,
    year,
    license,
    description,
    sortOrder,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Translation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('license')) {
      context.handle(
        _licenseMeta,
        license.isAcceptableOrUnknown(data['license']!, _licenseMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      license: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  Translations createAlias(String alias) {
    return Translations(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Translation extends DataClass implements Insertable<Translation> {
  final String id;

  /// krátký stabilní kód, např. 'BKR'
  final String name;

  /// 'Bible kralická'
  final String abbreviation;

  /// zobrazovaná zkratka, např. 'BKR'
  final String language;
  final int? year;

  /// rok vydání (nepovinné)
  final String? license;

  /// licence / copyright
  final String? description;
  final int sortOrder;

  /// pořadí ve výběru překladu
  final int verseCount;
  const Translation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.language,
    this.year,
    this.license,
    this.description,
    required this.sortOrder,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || license != null) {
      map['license'] = Variable<String>(license);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      name: Value(name),
      abbreviation: Value(abbreviation),
      language: Value(language),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      license: license == null && nullToAbsent
          ? const Value.absent()
          : Value(license),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      verseCount: Value(verseCount),
    );
  }

  factory Translation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      language: serializer.fromJson<String>(json['language']),
      year: serializer.fromJson<int?>(json['year']),
      license: serializer.fromJson<String?>(json['license']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      verseCount: serializer.fromJson<int>(json['verse_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'language': serializer.toJson<String>(language),
      'year': serializer.toJson<int?>(year),
      'license': serializer.toJson<String?>(license),
      'description': serializer.toJson<String?>(description),
      'sort_order': serializer.toJson<int>(sortOrder),
      'verse_count': serializer.toJson<int>(verseCount),
    };
  }

  Translation copyWith({
    String? id,
    String? name,
    String? abbreviation,
    String? language,
    Value<int?> year = const Value.absent(),
    Value<String?> license = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    int? verseCount,
  }) => Translation(
    id: id ?? this.id,
    name: name ?? this.name,
    abbreviation: abbreviation ?? this.abbreviation,
    language: language ?? this.language,
    year: year.present ? year.value : this.year,
    license: license.present ? license.value : this.license,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    verseCount: verseCount ?? this.verseCount,
  );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      language: data.language.present ? data.language.value : this.language,
      year: data.year.present ? data.year.value : this.year,
      license: data.license.present ? data.license.value : this.license,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('language: $language, ')
          ..write('year: $year, ')
          ..write('license: $license, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    abbreviation,
    language,
    year,
    license,
    description,
    sortOrder,
    verseCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.language == this.language &&
          other.year == this.year &&
          other.license == this.license &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.verseCount == this.verseCount);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<String> language;
  final Value<int?> year;
  final Value<String?> license;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<int> verseCount;
  final Value<int> rowid;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.language = const Value.absent(),
    this.year = const Value.absent(),
    this.license = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranslationsCompanion.insert({
    required String id,
    required String name,
    required String abbreviation,
    this.language = const Value.absent(),
    this.year = const Value.absent(),
    this.license = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       abbreviation = Value(abbreviation);
  static Insertable<Translation> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? language,
    Expression<int>? year,
    Expression<String>? license,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<int>? verseCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (language != null) 'language': language,
      if (year != null) 'year': year,
      if (license != null) 'license': license,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (verseCount != null) 'verse_count': verseCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranslationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? abbreviation,
    Value<String>? language,
    Value<int?>? year,
    Value<String?>? license,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<int>? verseCount,
    Value<int>? rowid,
  }) {
    return TranslationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      language: language ?? this.language,
      year: year ?? this.year,
      license: license ?? this.license,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      verseCount: verseCount ?? this.verseCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (license.present) {
      map['license'] = Variable<String>(license.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('language: $language, ')
          ..write('year: $year, ')
          ..write('license: $license, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('verseCount: $verseCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Books extends Table with TableInfo<Books, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Books(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _osisMeta = const VerificationMeta('osis');
  late final GeneratedColumn<String> osis = GeneratedColumn<String>(
    'osis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _testamentMeta = const VerificationMeta(
    'testament',
  );
  late final GeneratedColumn<String> testament = GeneratedColumn<String>(
    'testament',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (testament IN (\'OT\', \'NT\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    osis,
    name,
    abbreviation,
    testament,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('osis')) {
      context.handle(
        _osisMeta,
        osis.isAcceptableOrUnknown(data['osis']!, _osisMeta),
      );
    } else if (isInserting) {
      context.missing(_osisMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('testament')) {
      context.handle(
        _testamentMeta,
        testament.isAcceptableOrUnknown(data['testament']!, _testamentMeta),
      );
    } else if (isInserting) {
      context.missing(_testamentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      osis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}osis'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      )!,
      testament: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}testament'],
      )!,
    );
  }

  @override
  Books createAlias(String alias) {
    return Books(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String osis;

  /// 'Gen', 'John' … (mezinárodní kód)
  final String name;

  /// český název, 'Genesis', 'Jan'
  final String abbreviation;

  /// česká zkratka (ČEP), 'Gn', 'J'
  final String testament;
  const Book({
    required this.id,
    required this.osis,
    required this.name,
    required this.abbreviation,
    required this.testament,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['osis'] = Variable<String>(osis);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['testament'] = Variable<String>(testament);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      osis: Value(osis),
      name: Value(name),
      abbreviation: Value(abbreviation),
      testament: Value(testament),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      osis: serializer.fromJson<String>(json['osis']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      testament: serializer.fromJson<String>(json['testament']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'osis': serializer.toJson<String>(osis),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'testament': serializer.toJson<String>(testament),
    };
  }

  Book copyWith({
    int? id,
    String? osis,
    String? name,
    String? abbreviation,
    String? testament,
  }) => Book(
    id: id ?? this.id,
    osis: osis ?? this.osis,
    name: name ?? this.name,
    abbreviation: abbreviation ?? this.abbreviation,
    testament: testament ?? this.testament,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      osis: data.osis.present ? data.osis.value : this.osis,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      testament: data.testament.present ? data.testament.value : this.testament,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('osis: $osis, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('testament: $testament')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, osis, name, abbreviation, testament);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.osis == this.osis &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.testament == this.testament);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> osis;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<String> testament;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.osis = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.testament = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String osis,
    required String name,
    required String abbreviation,
    required String testament,
  }) : osis = Value(osis),
       name = Value(name),
       abbreviation = Value(abbreviation),
       testament = Value(testament);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? osis,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? testament,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (osis != null) 'osis': osis,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (testament != null) 'testament': testament,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? osis,
    Value<String>? name,
    Value<String>? abbreviation,
    Value<String>? testament,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      osis: osis ?? this.osis,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      testament: testament ?? this.testament,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (osis.present) {
      map['osis'] = Variable<String>(osis.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (testament.present) {
      map['testament'] = Variable<String>(testament.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('osis: $osis, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('testament: $testament')
          ..write(')'))
        .toString();
  }
}

class Chapters extends Table with TableInfo<Chapters, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Chapters(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _translationIdMeta = const VerificationMeta(
    'translationId',
  );
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
    'translation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES translations(id)',
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id)',
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    bookId,
    chapter,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('translation_id')) {
      context.handle(
        _translationIdMeta,
        translationId.isAcceptableOrUnknown(
          data['translation_id']!,
          _translationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {translationId, bookId, chapter};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  Chapters createAlias(String alias) {
    return Chapters(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(translation_id, book_id, chapter)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verseCount;
  const Chapter({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verseCount: Value(verseCount),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      translationId: serializer.fromJson<String>(json['translation_id']),
      bookId: serializer.fromJson<int>(json['book_id']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verseCount: serializer.fromJson<int>(json['verse_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translation_id': serializer.toJson<String>(translationId),
      'book_id': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse_count': serializer.toJson<int>(verseCount),
    };
  }

  Chapter copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verseCount,
  }) => Chapter(
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verseCount: verseCount ?? this.verseCount,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(translationId, bookId, chapter, verseCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verseCount == this.verseCount);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verseCount;
  const ChaptersCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verseCount = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verseCount,
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verseCount = Value(verseCount);
  static Insertable<Chapter> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verseCount,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verseCount != null) 'verse_count': verseCount,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verseCount,
  }) {
    return ChaptersCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseCount: verseCount ?? this.verseCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }
}

class Verses extends Table with TableInfo<Verses, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Verses(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _translationIdMeta = const VerificationMeta(
    'translationId',
  );
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
    'translation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES translations(id)',
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id)',
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _text$Meta = const VerificationMeta('text\$');
  late final GeneratedColumn<String> text$ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _paragraphMeta = const VerificationMeta(
    'paragraph',
  );
  late final GeneratedColumn<int> paragraph = GeneratedColumn<int>(
    'paragraph',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _poetryMeta = const VerificationMeta('poetry');
  late final GeneratedColumn<int> poetry = GeneratedColumn<int>(
    'poetry',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    translationId,
    bookId,
    chapter,
    verse,
    text$,
    paragraph,
    poetry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('translation_id')) {
      context.handle(
        _translationIdMeta,
        translationId.isAcceptableOrUnknown(
          data['translation_id']!,
          _translationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _text$Meta,
        text$.isAcceptableOrUnknown(data['text']!, _text$Meta),
      );
    } else if (isInserting) {
      context.missing(_text$Meta);
    }
    if (data.containsKey('paragraph')) {
      context.handle(
        _paragraphMeta,
        paragraph.isAcceptableOrUnknown(data['paragraph']!, _paragraphMeta),
      );
    }
    if (data.containsKey('poetry')) {
      context.handle(
        _poetryMeta,
        poetry.isAcceptableOrUnknown(data['poetry']!, _poetryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      text$: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      paragraph: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paragraph'],
      )!,
      poetry: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poetry'],
      )!,
    );
  }

  @override
  Verses createAlias(String alias) {
    return Verses(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String text$;

  /// 1 = verš začíná nový odstavec. Zdroje bez členění mají 1 u každého
  /// verše (čtečka pak zobrazí verš po verši).
  final int paragraph;

  /// 1 = verš je součástí poezie (žalmy, písně) – odsazené řádky.
  final int poetry;
  const Verse({
    required this.id,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text$,
    required this.paragraph,
    required this.poetry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['text'] = Variable<String>(text$);
    map['paragraph'] = Variable<int>(paragraph);
    map['poetry'] = Variable<int>(poetry);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      text$: Value(text$),
      paragraph: Value(paragraph),
      poetry: Value(poetry),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      translationId: serializer.fromJson<String>(json['translation_id']),
      bookId: serializer.fromJson<int>(json['book_id']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      text$: serializer.fromJson<String>(json['text']),
      paragraph: serializer.fromJson<int>(json['paragraph']),
      poetry: serializer.fromJson<int>(json['poetry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'translation_id': serializer.toJson<String>(translationId),
      'book_id': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'text': serializer.toJson<String>(text$),
      'paragraph': serializer.toJson<int>(paragraph),
      'poetry': serializer.toJson<int>(poetry),
    };
  }

  Verse copyWith({
    int? id,
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    String? text$,
    int? paragraph,
    int? poetry,
  }) => Verse(
    id: id ?? this.id,
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    text$: text$ ?? this.text$,
    paragraph: paragraph ?? this.paragraph,
    poetry: poetry ?? this.poetry,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      text$: data.text$.present ? data.text$.value : this.text$,
      paragraph: data.paragraph.present ? data.paragraph.value : this.paragraph,
      poetry: data.poetry.present ? data.poetry.value : this.poetry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('text\$: ${text$}, ')
          ..write('paragraph: $paragraph, ')
          ..write('poetry: $poetry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    translationId,
    bookId,
    chapter,
    verse,
    text$,
    paragraph,
    poetry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.text$ == this.text$ &&
          other.paragraph == this.paragraph &&
          other.poetry == this.poetry);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> text$;
  final Value<int> paragraph;
  final Value<int> poetry;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.text$ = const Value.absent(),
    this.paragraph = const Value.absent(),
    this.poetry = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String text$,
    this.paragraph = const Value.absent(),
    this.poetry = const Value.absent(),
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verse = Value(verse),
       text$ = Value(text$);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? text$,
    Expression<int>? paragraph,
    Expression<int>? poetry,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (text$ != null) 'text': text$,
      if (paragraph != null) 'paragraph': paragraph,
      if (poetry != null) 'poetry': poetry,
    });
  }

  VersesCompanion copyWith({
    Value<int>? id,
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? text$,
    Value<int>? paragraph,
    Value<int>? poetry,
  }) {
    return VersesCompanion(
      id: id ?? this.id,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      text$: text$ ?? this.text$,
      paragraph: paragraph ?? this.paragraph,
      poetry: poetry ?? this.poetry,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (text$.present) {
      map['text'] = Variable<String>(text$.value);
    }
    if (paragraph.present) {
      map['paragraph'] = Variable<int>(paragraph.value);
    }
    if (poetry.present) {
      map['poetry'] = Variable<int>(poetry.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('text\$: ${text$}, ')
          ..write('paragraph: $paragraph, ')
          ..write('poetry: $poetry')
          ..write(')'))
        .toString();
  }
}

class Headings extends Table with TableInfo<Headings, Heading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Headings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _translationIdMeta = const VerificationMeta(
    'translationId',
  );
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
    'translation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES translations(id)',
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id)',
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _text$Meta = const VerificationMeta('text\$');
  late final GeneratedColumn<String> text$ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    bookId,
    chapter,
    verse,
    ord,
    text$,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'headings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Heading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('translation_id')) {
      context.handle(
        _translationIdMeta,
        translationId.isAcceptableOrUnknown(
          data['translation_id']!,
          _translationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _text$Meta,
        text$.isAcceptableOrUnknown(data['text']!, _text$Meta),
      );
    } else if (isInserting) {
      context.missing(_text$Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    translationId,
    bookId,
    chapter,
    verse,
    ord,
  };
  @override
  Heading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Heading(
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
      text$: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
    );
  }

  @override
  Headings createAlias(String alias) {
    return Headings(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(translation_id, book_id, chapter, verse, ord)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Heading extends DataClass implements Insertable<Heading> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final int ord;
  final String text$;
  const Heading({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.ord,
    required this.text$,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['ord'] = Variable<int>(ord);
    map['text'] = Variable<String>(text$);
    return map;
  }

  HeadingsCompanion toCompanion(bool nullToAbsent) {
    return HeadingsCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      ord: Value(ord),
      text$: Value(text$),
    );
  }

  factory Heading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Heading(
      translationId: serializer.fromJson<String>(json['translation_id']),
      bookId: serializer.fromJson<int>(json['book_id']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      ord: serializer.fromJson<int>(json['ord']),
      text$: serializer.fromJson<String>(json['text']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translation_id': serializer.toJson<String>(translationId),
      'book_id': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'ord': serializer.toJson<int>(ord),
      'text': serializer.toJson<String>(text$),
    };
  }

  Heading copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    int? ord,
    String? text$,
  }) => Heading(
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    ord: ord ?? this.ord,
    text$: text$ ?? this.text$,
  );
  Heading copyWithCompanion(HeadingsCompanion data) {
    return Heading(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      ord: data.ord.present ? data.ord.value : this.ord,
      text$: data.text$.present ? data.text$.value : this.text$,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Heading(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('ord: $ord, ')
          ..write('text\$: ${text$}')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(translationId, bookId, chapter, verse, ord, text$);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Heading &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.ord == this.ord &&
          other.text$ == this.text$);
}

class HeadingsCompanion extends UpdateCompanion<Heading> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> ord;
  final Value<String> text$;
  const HeadingsCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.ord = const Value.absent(),
    this.text$ = const Value.absent(),
  });
  HeadingsCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    this.ord = const Value.absent(),
    required String text$,
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verse = Value(verse),
       text$ = Value(text$);
  static Insertable<Heading> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<int>? ord,
    Expression<String>? text$,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (ord != null) 'ord': ord,
      if (text$ != null) 'text': text$,
    });
  }

  HeadingsCompanion copyWith({
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<int>? ord,
    Value<String>? text$,
  }) {
    return HeadingsCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      ord: ord ?? this.ord,
      text$: text$ ?? this.text$,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    if (text$.present) {
      map['text'] = Variable<String>(text$.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeadingsCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('ord: $ord, ')
          ..write('text\$: ${text$}')
          ..write(')'))
        .toString();
  }
}

class Footnotes extends Table with TableInfo<Footnotes, Footnote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Footnotes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _translationIdMeta = const VerificationMeta(
    'translationId',
  );
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
    'translation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES translations(id)',
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES books(id)',
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _text$Meta = const VerificationMeta('text\$');
  late final GeneratedColumn<String> text$ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    bookId,
    chapter,
    verse,
    ord,
    text$,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'footnotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Footnote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('translation_id')) {
      context.handle(
        _translationIdMeta,
        translationId.isAcceptableOrUnknown(
          data['translation_id']!,
          _translationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _text$Meta,
        text$.isAcceptableOrUnknown(data['text']!, _text$Meta),
      );
    } else if (isInserting) {
      context.missing(_text$Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    translationId,
    bookId,
    chapter,
    verse,
    ord,
  };
  @override
  Footnote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Footnote(
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
      text$: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
    );
  }

  @override
  Footnotes createAlias(String alias) {
    return Footnotes(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(translation_id, book_id, chapter, verse, ord)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Footnote extends DataClass implements Insertable<Footnote> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final int ord;
  final String text$;
  const Footnote({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.ord,
    required this.text$,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['ord'] = Variable<int>(ord);
    map['text'] = Variable<String>(text$);
    return map;
  }

  FootnotesCompanion toCompanion(bool nullToAbsent) {
    return FootnotesCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      ord: Value(ord),
      text$: Value(text$),
    );
  }

  factory Footnote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Footnote(
      translationId: serializer.fromJson<String>(json['translation_id']),
      bookId: serializer.fromJson<int>(json['book_id']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      ord: serializer.fromJson<int>(json['ord']),
      text$: serializer.fromJson<String>(json['text']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translation_id': serializer.toJson<String>(translationId),
      'book_id': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'ord': serializer.toJson<int>(ord),
      'text': serializer.toJson<String>(text$),
    };
  }

  Footnote copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    int? ord,
    String? text$,
  }) => Footnote(
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    ord: ord ?? this.ord,
    text$: text$ ?? this.text$,
  );
  Footnote copyWithCompanion(FootnotesCompanion data) {
    return Footnote(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      ord: data.ord.present ? data.ord.value : this.ord,
      text$: data.text$.present ? data.text$.value : this.text$,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Footnote(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('ord: $ord, ')
          ..write('text\$: ${text$}')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(translationId, bookId, chapter, verse, ord, text$);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Footnote &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.ord == this.ord &&
          other.text$ == this.text$);
}

class FootnotesCompanion extends UpdateCompanion<Footnote> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> ord;
  final Value<String> text$;
  const FootnotesCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.ord = const Value.absent(),
    this.text$ = const Value.absent(),
  });
  FootnotesCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    this.ord = const Value.absent(),
    required String text$,
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verse = Value(verse),
       text$ = Value(text$);
  static Insertable<Footnote> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<int>? ord,
    Expression<String>? text$,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (ord != null) 'ord': ord,
      if (text$ != null) 'text': text$,
    });
  }

  FootnotesCompanion copyWith({
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<int>? ord,
    Value<String>? text$,
  }) {
    return FootnotesCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      ord: ord ?? this.ord,
      text$: text$ ?? this.text$,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    if (text$.present) {
      map['text'] = Variable<String>(text$.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FootnotesCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('ord: $ord, ')
          ..write('text\$: ${text$}')
          ..write(')'))
        .toString();
  }
}

class VersesFts extends Table
    with TableInfo<VersesFts, VersesFt>, VirtualTableInfo<VersesFts, VersesFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VersesFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _text$Meta = const VerificationMeta('text\$');
  late final GeneratedColumn<String> text$ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [text$];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<VersesFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('text')) {
      context.handle(
        _text$Meta,
        text$.isAcceptableOrUnknown(data['text']!, _text$Meta),
      );
    } else if (isInserting) {
      context.missing(_text$Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  VersesFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VersesFt(
      text$: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
    );
  }

  @override
  VersesFts createAlias(String alias) {
    return VersesFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(text, content = \'verses\', content_rowid = \'id\', tokenize = \'unicode61 remove_diacritics 2\')';
}

class VersesFt extends DataClass implements Insertable<VersesFt> {
  final String text$;
  const VersesFt({required this.text$});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['text'] = Variable<String>(text$);
    return map;
  }

  VersesFtsCompanion toCompanion(bool nullToAbsent) {
    return VersesFtsCompanion(text$: Value(text$));
  }

  factory VersesFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VersesFt(text$: serializer.fromJson<String>(json['text']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'text': serializer.toJson<String>(text$)};
  }

  VersesFt copyWith({String? text$}) => VersesFt(text$: text$ ?? this.text$);
  VersesFt copyWithCompanion(VersesFtsCompanion data) {
    return VersesFt(text$: data.text$.present ? data.text$.value : this.text$);
  }

  @override
  String toString() {
    return (StringBuffer('VersesFt(')
          ..write('text\$: ${text$}')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => text$.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VersesFt && other.text$ == this.text$);
}

class VersesFtsCompanion extends UpdateCompanion<VersesFt> {
  final Value<String> text$;
  final Value<int> rowid;
  const VersesFtsCompanion({
    this.text$ = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VersesFtsCompanion.insert({
    required String text$,
    this.rowid = const Value.absent(),
  }) : text$ = Value(text$);
  static Insertable<VersesFt> custom({
    Expression<String>? text$,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (text$ != null) 'text': text$,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VersesFtsCompanion copyWith({Value<String>? text$, Value<int>? rowid}) {
    return VersesFtsCompanion(
      text$: text$ ?? this.text$,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (text$.present) {
      map['text'] = Variable<String>(text$.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesFtsCompanion(')
          ..write('text\$: ${text$}, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BibleDatabase extends GeneratedDatabase {
  _$BibleDatabase(QueryExecutor e) : super(e);
  $BibleDatabaseManager get managers => $BibleDatabaseManager(this);
  late final Meta meta = Meta(this);
  late final Translations translations = Translations(this);
  late final Books books = Books(this);
  late final Chapters chapters = Chapters(this);
  late final Verses verses = Verses(this);
  late final Headings headings = Headings(this);
  late final Footnotes footnotes = Footnotes(this);
  late final Index versesByRef = Index(
    'verses_by_ref',
    'CREATE UNIQUE INDEX verses_by_ref ON verses (translation_id, book_id, chapter, verse)',
  );
  late final VersesFts versesFts = VersesFts(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    meta,
    translations,
    books,
    chapters,
    verses,
    headings,
    footnotes,
    versesByRef,
    versesFts,
  ];
}

typedef $MetaCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $MetaUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $MetaFilterComposer extends Composer<_$BibleDatabase, Meta> {
  $MetaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $MetaOrderingComposer extends Composer<_$BibleDatabase, Meta> {
  $MetaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $MetaAnnotationComposer extends Composer<_$BibleDatabase, Meta> {
  $MetaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $MetaTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Meta,
          MetaData,
          $MetaFilterComposer,
          $MetaOrderingComposer,
          $MetaAnnotationComposer,
          $MetaCreateCompanionBuilder,
          $MetaUpdateCompanionBuilder,
          (MetaData, BaseReferences<_$BibleDatabase, Meta, MetaData>),
          MetaData,
          PrefetchHooks Function()
        > {
  $MetaTableManager(_$BibleDatabase db, Meta table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MetaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MetaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MetaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Meta, MetaData>(table),
                  BaseReferences<_$BibleDatabase, Meta, MetaData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $MetaProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Meta,
      MetaData,
      $MetaFilterComposer,
      $MetaOrderingComposer,
      $MetaAnnotationComposer,
      $MetaCreateCompanionBuilder,
      $MetaUpdateCompanionBuilder,
      (MetaData, BaseReferences<_$BibleDatabase, Meta, MetaData>),
      MetaData,
      PrefetchHooks Function()
    >;
typedef $TranslationsCreateCompanionBuilder = TranslationsCompanion Function({
  required String id,
  required String name,
  required String abbreviation,
  Value<String> language,
  Value<int?> year,
  Value<String?> license,
  Value<String?> description,
  Value<int> sortOrder,
  Value<int> verseCount,
  Value<int> rowid,
});
typedef $TranslationsUpdateCompanionBuilder = TranslationsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> abbreviation,
  Value<String> language,
  Value<int?> year,
  Value<String?> license,
  Value<String?> description,
  Value<int> sortOrder,
  Value<int> verseCount,
  Value<int> rowid,
});

final class $TranslationsReferences
    extends BaseReferences<_$BibleDatabase, Translations, Translation> {
  $TranslationsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Chapters, List<Chapter>> _chaptersRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: 'translations__id__chapters__translation_id',
  );

  $ChaptersProcessedTableManager get chaptersRefs {
    final manager = $ChaptersTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Verses, List<Verse>> _versesRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.verses,
    aliasName: 'translations__id__verses__translation_id',
  );

  $VersesProcessedTableManager get versesRefs {
    final manager = $VersesTableManager(
      $_db,
      $_db.verses,
    ).filter((f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_versesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Headings, List<Heading>> _headingsRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.headings,
    aliasName: 'translations__id__headings__translation_id',
  );

  $HeadingsProcessedTableManager get headingsRefs {
    final manager = $HeadingsTableManager(
      $_db,
      $_db.headings,
    ).filter((f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_headingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Footnotes, List<Footnote>> _footnotesRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.footnotes,
    aliasName: 'translations__id__footnotes__translation_id',
  );

  $FootnotesProcessedTableManager get footnotesRefs {
    final manager = $FootnotesTableManager(
      $_db,
      $_db.footnotes,
    ).filter((f) => f.translationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_footnotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $TranslationsFilterComposer
    extends Composer<_$BibleDatabase, Translations> {
  $TranslationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($ChaptersFilterComposer f) f,
  ) {
    final $ChaptersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChaptersFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> versesRefs(
    Expression<bool> Function($VersesFilterComposer f) f,
  ) {
    final $VersesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesFilterComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> headingsRefs(
    Expression<bool> Function($HeadingsFilterComposer f) f,
  ) {
    final $HeadingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.headings,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HeadingsFilterComposer(
            $db: $db,
            $table: $db.headings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> footnotesRefs(
    Expression<bool> Function($FootnotesFilterComposer f) f,
  ) {
    final $FootnotesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.footnotes,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FootnotesFilterComposer(
            $db: $db,
            $table: $db.footnotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TranslationsOrderingComposer
    extends Composer<_$BibleDatabase, Translations> {
  $TranslationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TranslationsAnnotationComposer
    extends Composer<_$BibleDatabase, Translations> {
  $TranslationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get license =>
      $composableBuilder(column: $table.license, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($ChaptersAnnotationComposer a) f,
  ) {
    final $ChaptersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChaptersAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> versesRefs<T extends Object>(
    Expression<T> Function($VersesAnnotationComposer a) f,
  ) {
    final $VersesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesAnnotationComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> headingsRefs<T extends Object>(
    Expression<T> Function($HeadingsAnnotationComposer a) f,
  ) {
    final $HeadingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.headings,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HeadingsAnnotationComposer(
            $db: $db,
            $table: $db.headings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> footnotesRefs<T extends Object>(
    Expression<T> Function($FootnotesAnnotationComposer a) f,
  ) {
    final $FootnotesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.footnotes,
      getReferencedColumn: (t) => t.translationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FootnotesAnnotationComposer(
            $db: $db,
            $table: $db.footnotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TranslationsTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Translations,
          Translation,
          $TranslationsFilterComposer,
          $TranslationsOrderingComposer,
          $TranslationsAnnotationComposer,
          $TranslationsCreateCompanionBuilder,
          $TranslationsUpdateCompanionBuilder,
          (Translation, $TranslationsReferences),
          Translation,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool versesRefs,
            bool headingsRefs,
            bool footnotesRefs,
          })
        > {
  $TranslationsTableManager(_$BibleDatabase db, Translations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TranslationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TranslationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TranslationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> abbreviation = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> license = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TranslationsCompanion(
                id: id,
                name: name,
                abbreviation: abbreviation,
                language: language,
                year: year,
                license: license,
                description: description,
                sortOrder: sortOrder,
                verseCount: verseCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String abbreviation,
                Value<String> language = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> license = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TranslationsCompanion.insert(
                id: id,
                name: name,
                abbreviation: abbreviation,
                language: language,
                year: year,
                license: license,
                description: description,
                sortOrder: sortOrder,
                verseCount: verseCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Translations, Translation>(table),
                  $TranslationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                versesRefs = false,
                headingsRefs = false,
                footnotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (versesRefs) db.verses,
                    if (headingsRefs) db.headings,
                    if (footnotesRefs) db.footnotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedDataByColumns<
                          Translation,
                          Translations,
                          Chapter,
                          Chapters
                        >(
                          currentTable: table,
                          referencedTable: $TranslationsReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TranslationsReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'translation_id',
                          typedResults: items,
                        ),
                      if (versesRefs)
                        await $_getPrefetchedDataByColumns<
                          Translation,
                          Translations,
                          Verse,
                          Verses
                        >(
                          currentTable: table,
                          referencedTable: $TranslationsReferences
                              ._versesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TranslationsReferences(db, table, p0).versesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'translation_id',
                          typedResults: items,
                        ),
                      if (headingsRefs)
                        await $_getPrefetchedDataByColumns<
                          Translation,
                          Translations,
                          Heading,
                          Headings
                        >(
                          currentTable: table,
                          referencedTable: $TranslationsReferences
                              ._headingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TranslationsReferences(
                                db,
                                table,
                                p0,
                              ).headingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'translation_id',
                          typedResults: items,
                        ),
                      if (footnotesRefs)
                        await $_getPrefetchedDataByColumns<
                          Translation,
                          Translations,
                          Footnote,
                          Footnotes
                        >(
                          currentTable: table,
                          referencedTable: $TranslationsReferences
                              ._footnotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TranslationsReferences(
                                db,
                                table,
                                p0,
                              ).footnotesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'translation_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $TranslationsProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Translations,
      Translation,
      $TranslationsFilterComposer,
      $TranslationsOrderingComposer,
      $TranslationsAnnotationComposer,
      $TranslationsCreateCompanionBuilder,
      $TranslationsUpdateCompanionBuilder,
      (Translation, $TranslationsReferences),
      Translation,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool versesRefs,
        bool headingsRefs,
        bool footnotesRefs,
      })
    >;
typedef $BooksCreateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  required String osis,
  required String name,
  required String abbreviation,
  required String testament,
});
typedef $BooksUpdateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  Value<String> osis,
  Value<String> name,
  Value<String> abbreviation,
  Value<String> testament,
});

final class $BooksReferences
    extends BaseReferences<_$BibleDatabase, Books, Book> {
  $BooksReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Chapters, List<Chapter>> _chaptersRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: 'books__id__chapters__book_id',
  );

  $ChaptersProcessedTableManager get chaptersRefs {
    final manager = $ChaptersTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Verses, List<Verse>> _versesRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.verses,
    aliasName: 'books__id__verses__book_id',
  );

  $VersesProcessedTableManager get versesRefs {
    final manager = $VersesTableManager(
      $_db,
      $_db.verses,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_versesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Headings, List<Heading>> _headingsRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.headings,
    aliasName: 'books__id__headings__book_id',
  );

  $HeadingsProcessedTableManager get headingsRefs {
    final manager = $HeadingsTableManager(
      $_db,
      $_db.headings,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_headingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Footnotes, List<Footnote>> _footnotesRefsTable(
    _$BibleDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.footnotes,
    aliasName: 'books__id__footnotes__book_id',
  );

  $FootnotesProcessedTableManager get footnotesRefs {
    final manager = $FootnotesTableManager(
      $_db,
      $_db.footnotes,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_footnotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $BooksFilterComposer extends Composer<_$BibleDatabase, Books> {
  $BooksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get osis => $composableBuilder(
    column: $table.osis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($ChaptersFilterComposer f) f,
  ) {
    final $ChaptersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChaptersFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> versesRefs(
    Expression<bool> Function($VersesFilterComposer f) f,
  ) {
    final $VersesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesFilterComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> headingsRefs(
    Expression<bool> Function($HeadingsFilterComposer f) f,
  ) {
    final $HeadingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.headings,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HeadingsFilterComposer(
            $db: $db,
            $table: $db.headings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> footnotesRefs(
    Expression<bool> Function($FootnotesFilterComposer f) f,
  ) {
    final $FootnotesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.footnotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FootnotesFilterComposer(
            $db: $db,
            $table: $db.footnotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $BooksOrderingComposer extends Composer<_$BibleDatabase, Books> {
  $BooksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get osis => $composableBuilder(
    column: $table.osis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnOrderings(column),
  );
}

class $BooksAnnotationComposer extends Composer<_$BibleDatabase, Books> {
  $BooksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get osis =>
      $composableBuilder(column: $table.osis, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testament =>
      $composableBuilder(column: $table.testament, builder: (column) => column);

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($ChaptersAnnotationComposer a) f,
  ) {
    final $ChaptersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChaptersAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> versesRefs<T extends Object>(
    Expression<T> Function($VersesAnnotationComposer a) f,
  ) {
    final $VersesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesAnnotationComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> headingsRefs<T extends Object>(
    Expression<T> Function($HeadingsAnnotationComposer a) f,
  ) {
    final $HeadingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.headings,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HeadingsAnnotationComposer(
            $db: $db,
            $table: $db.headings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> footnotesRefs<T extends Object>(
    Expression<T> Function($FootnotesAnnotationComposer a) f,
  ) {
    final $FootnotesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.footnotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FootnotesAnnotationComposer(
            $db: $db,
            $table: $db.footnotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $BooksTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Books,
          Book,
          $BooksFilterComposer,
          $BooksOrderingComposer,
          $BooksAnnotationComposer,
          $BooksCreateCompanionBuilder,
          $BooksUpdateCompanionBuilder,
          (Book, $BooksReferences),
          Book,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool versesRefs,
            bool headingsRefs,
            bool footnotesRefs,
          })
        > {
  $BooksTableManager(_$BibleDatabase db, Books table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BooksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BooksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BooksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> osis = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> abbreviation = const Value.absent(),
                Value<String> testament = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                osis: osis,
                name: name,
                abbreviation: abbreviation,
                testament: testament,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String osis,
                required String name,
                required String abbreviation,
                required String testament,
              }) => BooksCompanion.insert(
                id: id,
                osis: osis,
                name: name,
                abbreviation: abbreviation,
                testament: testament,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Books, Book>(table),
                  $BooksReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                versesRefs = false,
                headingsRefs = false,
                footnotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (versesRefs) db.verses,
                    if (headingsRefs) db.headings,
                    if (footnotesRefs) db.footnotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          Books,
                          Chapter,
                          Chapters
                        >(
                          currentTable: table,
                          referencedTable: $BooksReferences._chaptersRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $BooksReferences(db, table, p0).chaptersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                      if (versesRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          Books,
                          Verse,
                          Verses
                        >(
                          currentTable: table,
                          referencedTable: $BooksReferences._versesRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $BooksReferences(db, table, p0).versesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                      if (headingsRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          Books,
                          Heading,
                          Headings
                        >(
                          currentTable: table,
                          referencedTable: $BooksReferences._headingsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $BooksReferences(db, table, p0).headingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                      if (footnotesRefs)
                        await $_getPrefetchedDataByColumns<
                          Book,
                          Books,
                          Footnote,
                          Footnotes
                        >(
                          currentTable: table,
                          referencedTable: $BooksReferences._footnotesRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $BooksReferences(db, table, p0).footnotesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'book_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $BooksProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Books,
      Book,
      $BooksFilterComposer,
      $BooksOrderingComposer,
      $BooksAnnotationComposer,
      $BooksCreateCompanionBuilder,
      $BooksUpdateCompanionBuilder,
      (Book, $BooksReferences),
      Book,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool versesRefs,
        bool headingsRefs,
        bool footnotesRefs,
      })
    >;
typedef $ChaptersCreateCompanionBuilder = ChaptersCompanion Function({
  required String translationId,
  required int bookId,
  required int chapter,
  required int verseCount,
});
typedef $ChaptersUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verseCount,
});

final class $ChaptersReferences
    extends BaseReferences<_$BibleDatabase, Chapters, Chapter> {
  $ChaptersReferences(super.$_db, super.$_table, super.$_typedResult);

  static Translations _translationIdTable(_$BibleDatabase db) =>
      db.translations.createAlias('chapters__translation_id__translations__id');

  $TranslationsProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $TranslationsTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Books _bookIdTable(_$BibleDatabase db) =>
      db.books.createAlias('chapters__book_id__books__id');

  $BooksProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $BooksTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $ChaptersFilterComposer extends Composer<_$BibleDatabase, Chapters> {
  $ChaptersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );

  $TranslationsFilterComposer get translationId {
    final $TranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksFilterComposer get bookId {
    final $BooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ChaptersOrderingComposer extends Composer<_$BibleDatabase, Chapters> {
  $ChaptersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );

  $TranslationsOrderingComposer get translationId {
    final $TranslationsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsOrderingComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksOrderingComposer get bookId {
    final $BooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ChaptersAnnotationComposer extends Composer<_$BibleDatabase, Chapters> {
  $ChaptersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );

  $TranslationsAnnotationComposer get translationId {
    final $TranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksAnnotationComposer get bookId {
    final $BooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ChaptersTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Chapters,
          Chapter,
          $ChaptersFilterComposer,
          $ChaptersOrderingComposer,
          $ChaptersAnnotationComposer,
          $ChaptersCreateCompanionBuilder,
          $ChaptersUpdateCompanionBuilder,
          (Chapter, $ChaptersReferences),
          Chapter,
          PrefetchHooks Function({bool translationId, bool bookId})
        > {
  $ChaptersTableManager(_$BibleDatabase db, Chapters table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ChaptersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ChaptersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ChaptersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
              }) => ChaptersCompanion(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseCount: verseCount,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int bookId,
                required int chapter,
                required int verseCount,
              }) => ChaptersCompanion.insert(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseCount: verseCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Chapters, Chapter>(table),
                  $ChaptersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({translationId = false, bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (translationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.translationId,
                        referencedTable: $ChaptersReferences
                            ._translationIdTable(db),
                        referencedColumn: $ChaptersReferences
                            ._translationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $ChaptersReferences._bookIdTable(db),
                        referencedColumn: $ChaptersReferences
                            ._bookIdTable(db)
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
        ),
      );
}

typedef $ChaptersProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Chapters,
      Chapter,
      $ChaptersFilterComposer,
      $ChaptersOrderingComposer,
      $ChaptersAnnotationComposer,
      $ChaptersCreateCompanionBuilder,
      $ChaptersUpdateCompanionBuilder,
      (Chapter, $ChaptersReferences),
      Chapter,
      PrefetchHooks Function({bool translationId, bool bookId})
    >;
typedef $VersesCreateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  required String text$,
  Value<int> paragraph,
  Value<int> poetry,
});
typedef $VersesUpdateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<String> text$,
  Value<int> paragraph,
  Value<int> poetry,
});

final class $VersesReferences
    extends BaseReferences<_$BibleDatabase, Verses, Verse> {
  $VersesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Translations _translationIdTable(_$BibleDatabase db) =>
      db.translations.createAlias('verses__translation_id__translations__id');

  $TranslationsProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $TranslationsTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Books _bookIdTable(_$BibleDatabase db) =>
      db.books.createAlias('verses__book_id__books__id');

  $BooksProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $BooksTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $VersesFilterComposer extends Composer<_$BibleDatabase, Verses> {
  $VersesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paragraph => $composableBuilder(
    column: $table.paragraph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get poetry => $composableBuilder(
    column: $table.poetry,
    builder: (column) => ColumnFilters(column),
  );

  $TranslationsFilterComposer get translationId {
    final $TranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksFilterComposer get bookId {
    final $BooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $VersesOrderingComposer extends Composer<_$BibleDatabase, Verses> {
  $VersesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paragraph => $composableBuilder(
    column: $table.paragraph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get poetry => $composableBuilder(
    column: $table.poetry,
    builder: (column) => ColumnOrderings(column),
  );

  $TranslationsOrderingComposer get translationId {
    final $TranslationsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsOrderingComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksOrderingComposer get bookId {
    final $BooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $VersesAnnotationComposer extends Composer<_$BibleDatabase, Verses> {
  $VersesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get text$ =>
      $composableBuilder(column: $table.text$, builder: (column) => column);

  GeneratedColumn<int> get paragraph =>
      $composableBuilder(column: $table.paragraph, builder: (column) => column);

  GeneratedColumn<int> get poetry =>
      $composableBuilder(column: $table.poetry, builder: (column) => column);

  $TranslationsAnnotationComposer get translationId {
    final $TranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksAnnotationComposer get bookId {
    final $BooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $VersesTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Verses,
          Verse,
          $VersesFilterComposer,
          $VersesOrderingComposer,
          $VersesAnnotationComposer,
          $VersesCreateCompanionBuilder,
          $VersesUpdateCompanionBuilder,
          (Verse, $VersesReferences),
          Verse,
          PrefetchHooks Function({bool translationId, bool bookId})
        > {
  $VersesTableManager(_$BibleDatabase db, Verses table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VersesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VersesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VersesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<String> text$ = const Value.absent(),
                Value<int> paragraph = const Value.absent(),
                Value<int> poetry = const Value.absent(),
              }) => VersesCompanion(
                id: id,
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                text$: text$,
                paragraph: paragraph,
                poetry: poetry,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String translationId,
                required int bookId,
                required int chapter,
                required int verse,
                required String text$,
                Value<int> paragraph = const Value.absent(),
                Value<int> poetry = const Value.absent(),
              }) => VersesCompanion.insert(
                id: id,
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                text$: text$,
                paragraph: paragraph,
                poetry: poetry,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Verses, Verse>(table),
                  $VersesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({translationId = false, bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (translationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.translationId,
                        referencedTable: $VersesReferences._translationIdTable(
                          db,
                        ),
                        referencedColumn: $VersesReferences
                            ._translationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $VersesReferences._bookIdTable(db),
                        referencedColumn: $VersesReferences._bookIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $VersesProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Verses,
      Verse,
      $VersesFilterComposer,
      $VersesOrderingComposer,
      $VersesAnnotationComposer,
      $VersesCreateCompanionBuilder,
      $VersesUpdateCompanionBuilder,
      (Verse, $VersesReferences),
      Verse,
      PrefetchHooks Function({bool translationId, bool bookId})
    >;
typedef $HeadingsCreateCompanionBuilder = HeadingsCompanion Function({
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  Value<int> ord,
  required String text$,
});
typedef $HeadingsUpdateCompanionBuilder = HeadingsCompanion Function({
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<int> ord,
  Value<String> text$,
});

final class $HeadingsReferences
    extends BaseReferences<_$BibleDatabase, Headings, Heading> {
  $HeadingsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Translations _translationIdTable(_$BibleDatabase db) =>
      db.translations.createAlias('headings__translation_id__translations__id');

  $TranslationsProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $TranslationsTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Books _bookIdTable(_$BibleDatabase db) =>
      db.books.createAlias('headings__book_id__books__id');

  $BooksProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $BooksTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $HeadingsFilterComposer extends Composer<_$BibleDatabase, Headings> {
  $HeadingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnFilters(column),
  );

  $TranslationsFilterComposer get translationId {
    final $TranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksFilterComposer get bookId {
    final $BooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HeadingsOrderingComposer extends Composer<_$BibleDatabase, Headings> {
  $HeadingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnOrderings(column),
  );

  $TranslationsOrderingComposer get translationId {
    final $TranslationsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsOrderingComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksOrderingComposer get bookId {
    final $BooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HeadingsAnnotationComposer extends Composer<_$BibleDatabase, Headings> {
  $HeadingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  GeneratedColumn<String> get text$ =>
      $composableBuilder(column: $table.text$, builder: (column) => column);

  $TranslationsAnnotationComposer get translationId {
    final $TranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksAnnotationComposer get bookId {
    final $BooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HeadingsTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Headings,
          Heading,
          $HeadingsFilterComposer,
          $HeadingsOrderingComposer,
          $HeadingsAnnotationComposer,
          $HeadingsCreateCompanionBuilder,
          $HeadingsUpdateCompanionBuilder,
          (Heading, $HeadingsReferences),
          Heading,
          PrefetchHooks Function({bool translationId, bool bookId})
        > {
  $HeadingsTableManager(_$BibleDatabase db, Headings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $HeadingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $HeadingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HeadingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<int> ord = const Value.absent(),
                Value<String> text$ = const Value.absent(),
              }) => HeadingsCompanion(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                ord: ord,
                text$: text$,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int bookId,
                required int chapter,
                required int verse,
                Value<int> ord = const Value.absent(),
                required String text$,
              }) => HeadingsCompanion.insert(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                ord: ord,
                text$: text$,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Headings, Heading>(table),
                  $HeadingsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({translationId = false, bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (translationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.translationId,
                        referencedTable: $HeadingsReferences
                            ._translationIdTable(db),
                        referencedColumn: $HeadingsReferences
                            ._translationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $HeadingsReferences._bookIdTable(db),
                        referencedColumn: $HeadingsReferences
                            ._bookIdTable(db)
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
        ),
      );
}

typedef $HeadingsProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Headings,
      Heading,
      $HeadingsFilterComposer,
      $HeadingsOrderingComposer,
      $HeadingsAnnotationComposer,
      $HeadingsCreateCompanionBuilder,
      $HeadingsUpdateCompanionBuilder,
      (Heading, $HeadingsReferences),
      Heading,
      PrefetchHooks Function({bool translationId, bool bookId})
    >;
typedef $FootnotesCreateCompanionBuilder = FootnotesCompanion Function({
  required String translationId,
  required int bookId,
  required int chapter,
  required int verse,
  Value<int> ord,
  required String text$,
});
typedef $FootnotesUpdateCompanionBuilder = FootnotesCompanion Function({
  Value<String> translationId,
  Value<int> bookId,
  Value<int> chapter,
  Value<int> verse,
  Value<int> ord,
  Value<String> text$,
});

final class $FootnotesReferences
    extends BaseReferences<_$BibleDatabase, Footnotes, Footnote> {
  $FootnotesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Translations _translationIdTable(_$BibleDatabase db) => db.translations
      .createAlias('footnotes__translation_id__translations__id');

  $TranslationsProcessedTableManager get translationId {
    final $_column = $_itemColumn<String>('translation_id')!;

    final manager = $TranslationsTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_translationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Books _bookIdTable(_$BibleDatabase db) =>
      db.books.createAlias('footnotes__book_id__books__id');

  $BooksProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $BooksTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $FootnotesFilterComposer extends Composer<_$BibleDatabase, Footnotes> {
  $FootnotesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnFilters(column),
  );

  $TranslationsFilterComposer get translationId {
    final $TranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksFilterComposer get bookId {
    final $BooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FootnotesOrderingComposer extends Composer<_$BibleDatabase, Footnotes> {
  $FootnotesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnOrderings(column),
  );

  $TranslationsOrderingComposer get translationId {
    final $TranslationsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsOrderingComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksOrderingComposer get bookId {
    final $BooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FootnotesAnnotationComposer
    extends Composer<_$BibleDatabase, Footnotes> {
  $FootnotesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  GeneratedColumn<String> get text$ =>
      $composableBuilder(column: $table.text$, builder: (column) => column);

  $TranslationsAnnotationComposer get translationId {
    final $TranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.translationId,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TranslationsAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $BooksAnnotationComposer get bookId {
    final $BooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BooksAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FootnotesTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          Footnotes,
          Footnote,
          $FootnotesFilterComposer,
          $FootnotesOrderingComposer,
          $FootnotesAnnotationComposer,
          $FootnotesCreateCompanionBuilder,
          $FootnotesUpdateCompanionBuilder,
          (Footnote, $FootnotesReferences),
          Footnote,
          PrefetchHooks Function({bool translationId, bool bookId})
        > {
  $FootnotesTableManager(_$BibleDatabase db, Footnotes table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FootnotesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FootnotesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FootnotesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<int> ord = const Value.absent(),
                Value<String> text$ = const Value.absent(),
              }) => FootnotesCompanion(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                ord: ord,
                text$: text$,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int bookId,
                required int chapter,
                required int verse,
                Value<int> ord = const Value.absent(),
                required String text$,
              }) => FootnotesCompanion.insert(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                ord: ord,
                text$: text$,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Footnotes, Footnote>(table),
                  $FootnotesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({translationId = false, bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (translationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.translationId,
                        referencedTable: $FootnotesReferences
                            ._translationIdTable(db),
                        referencedColumn: $FootnotesReferences
                            ._translationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $FootnotesReferences._bookIdTable(db),
                        referencedColumn: $FootnotesReferences
                            ._bookIdTable(db)
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
        ),
      );
}

typedef $FootnotesProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      Footnotes,
      Footnote,
      $FootnotesFilterComposer,
      $FootnotesOrderingComposer,
      $FootnotesAnnotationComposer,
      $FootnotesCreateCompanionBuilder,
      $FootnotesUpdateCompanionBuilder,
      (Footnote, $FootnotesReferences),
      Footnote,
      PrefetchHooks Function({bool translationId, bool bookId})
    >;
typedef $VersesFtsCreateCompanionBuilder = VersesFtsCompanion Function({
  required String text$,
  Value<int> rowid,
});
typedef $VersesFtsUpdateCompanionBuilder = VersesFtsCompanion Function({
  Value<String> text$,
  Value<int> rowid,
});

class $VersesFtsFilterComposer extends Composer<_$BibleDatabase, VersesFts> {
  $VersesFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnFilters(column),
  );
}

class $VersesFtsOrderingComposer extends Composer<_$BibleDatabase, VersesFts> {
  $VersesFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnOrderings(column),
  );
}

class $VersesFtsAnnotationComposer
    extends Composer<_$BibleDatabase, VersesFts> {
  $VersesFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get text$ =>
      $composableBuilder(column: $table.text$, builder: (column) => column);
}

class $VersesFtsTableManager
    extends
        RootTableManager<
          _$BibleDatabase,
          VersesFts,
          VersesFt,
          $VersesFtsFilterComposer,
          $VersesFtsOrderingComposer,
          $VersesFtsAnnotationComposer,
          $VersesFtsCreateCompanionBuilder,
          $VersesFtsUpdateCompanionBuilder,
          (VersesFt, BaseReferences<_$BibleDatabase, VersesFts, VersesFt>),
          VersesFt,
          PrefetchHooks Function()
        > {
  $VersesFtsTableManager(_$BibleDatabase db, VersesFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VersesFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VersesFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VersesFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> text$ = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => VersesFtsCompanion(text$: text$, rowid: rowid),
          createCompanionCallback: ({
            required String text$,
            Value<int> rowid = const Value.absent(),
          }) => VersesFtsCompanion.insert(text$: text$, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<VersesFts, VersesFt>(table),
                  BaseReferences<_$BibleDatabase, VersesFts, VersesFt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $VersesFtsProcessedTableManager =
    ProcessedTableManager<
      _$BibleDatabase,
      VersesFts,
      VersesFt,
      $VersesFtsFilterComposer,
      $VersesFtsOrderingComposer,
      $VersesFtsAnnotationComposer,
      $VersesFtsCreateCompanionBuilder,
      $VersesFtsUpdateCompanionBuilder,
      (VersesFt, BaseReferences<_$BibleDatabase, VersesFts, VersesFt>),
      VersesFt,
      PrefetchHooks Function()
    >;

class $BibleDatabaseManager {
  final _$BibleDatabase _db;
  $BibleDatabaseManager(this._db);
  $MetaTableManager get meta => $MetaTableManager(_db, _db.meta);
  $TranslationsTableManager get translations =>
      $TranslationsTableManager(_db, _db.translations);
  $BooksTableManager get books => $BooksTableManager(_db, _db.books);
  $ChaptersTableManager get chapters =>
      $ChaptersTableManager(_db, _db.chapters);
  $VersesTableManager get verses => $VersesTableManager(_db, _db.verses);
  $HeadingsTableManager get headings =>
      $HeadingsTableManager(_db, _db.headings);
  $FootnotesTableManager get footnotes =>
      $FootnotesTableManager(_db, _db.footnotes);
  $VersesFtsTableManager get versesFts =>
      $VersesFtsTableManager(_db, _db.versesFts);
}
