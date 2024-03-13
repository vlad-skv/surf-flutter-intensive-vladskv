enum Countries { brazil, russia, turkish, spain, japan }

class Territory {
  final int areaInHectare;
  final List<String> crops;
  final List<AgriculturalMachinery> machineries;

  Territory(
    this.areaInHectare,
    this.crops,
    this.machineries,
  );
}

class AgriculturalMachinery {
  final String id;
  final DateTime releaseDate;

  AgriculturalMachinery(
    this.id,
    this.releaseDate,
  );

  /// Переопределяем оператор "==", чтобы сравнивать объекты по значению.
  @override
  bool operator ==(Object? other) {
    if (other is! AgriculturalMachinery) return false;
    if (other.id == id && other.releaseDate == releaseDate) return true;

    return false;
  }

  @override
  int get hashCode => id.hashCode ^ releaseDate.hashCode;
}

final mapBefore2010 = <Countries, List<Territory>>{
  Countries.brazil: [
    Territory(
      34,
      ['Кукуруза'],
      [
        AgriculturalMachinery(
          'Трактор Степан',
          DateTime(2001),
        ),
        AgriculturalMachinery(
          'Культиватор Сережа',
          DateTime(2007),
        ),
      ],
    ),
  ],
  Countries.russia: [
    Territory(
      14,
      ['Картофель'],
      [
        AgriculturalMachinery(
          'Трактор Гена',
          DateTime(1993),
        ),
        AgriculturalMachinery(
          'Гранулятор Антон',
          DateTime(2009),
        ),
      ],
    ),
    Territory(
      19,
      ['Лук'],
      [
        AgriculturalMachinery(
          'Трактор Гена',
          DateTime(1993),
        ),
        AgriculturalMachinery(
          'Дробилка Маша',
          DateTime(1990),
        ),
      ],
    ),
  ],
  Countries.turkish: [
    Territory(
      43,
      ['Хмель'],
      [
        AgriculturalMachinery(
          'Комбаин Василий',
          DateTime(1998),
        ),
        AgriculturalMachinery(
          'Сепаратор Марк',
          DateTime(2005),
        ),
      ],
    ),
  ],
};

final mapAfter2010 = {
  Countries.turkish: [
    Territory(
      22,
      ['Чай'],
      [
        AgriculturalMachinery(
          'Каток Кирилл',
          DateTime(2018),
        ),
        AgriculturalMachinery(
          'Комбаин Василий',
          DateTime(1998),
        ),
      ],
    ),
  ],
  Countries.japan: [
    Territory(
      3,
      ['Рис'],
      [
        AgriculturalMachinery(
          'Гидравлический молот Лена',
          DateTime(2014),
        ),
      ],
    ),
  ],
  Countries.spain: [
    Territory(
      29,
      ['Арбузы'],
      [
        AgriculturalMachinery(
          'Мини-погрузчик Максим',
          DateTime(2011),
        ),
      ],
    ),
    Territory(
      11,
      ['Табак'],
      [
        AgriculturalMachinery(
          'Окучник Саша',
          DateTime(2010),
        ),
      ],
    ),
  ],
};

void main() {
  // The same mechanery can be in both lists, so add them to map by their id
  var machineryMap = <String,AgriculturalMachinery>{};
  void dataToMap(Map<Countries, List<Territory>> data) {
    data.forEach((country, terrotories) {
      terrotories.forEach((territory) {
        territory.machineries.forEach((machinery) {
          machineryMap[machinery.id] = machinery;
        });
      });
    });
  };
  dataToMap(mapBefore2010);
  dataToMap(mapAfter2010);
  // Find mean age as total age div number of macheneries  
  Duration meanAge(Iterable<AgriculturalMachinery> machineries) {
    final now = DateTime.now();  
    var totalAge = Duration();
    var count = 0; // will not use macheneries.length below as it will scan the sequence again afaik
    machineries.forEach((machinery) {
      final age = now.difference(machinery.releaseDate);
      totalAge += age;
      count++;
    });
    return count > 0 ? totalAge ~/ count : Duration.zero; // if no items, we'll return 0
  }
  // Mean age for all machineries
  final meanAgeForAll = meanAge(machineryMap.values);
  // Mean age of 50% of the oldest machineries
  final oldest = machineryMap.values.toList()
    ..sort((a, b) => a.releaseDate.compareTo(b.releaseDate))
    ..length ~/= 2;
  final meanAgeForOldest = meanAge(oldest);
  // Print the results
  String formatAge(Duration age) => (age.inDays / 365).toStringAsFixed(1);
  print('Mean age of all machineries is about ${formatAge(meanAgeForAll)} years');
  print('Mean age of oldest 50% of machineries is about ${formatAge(meanAgeForOldest)} years');
}