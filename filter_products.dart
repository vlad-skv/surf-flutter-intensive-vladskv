class Product {
  int _id;
  String _category;
  String _name;
  int _price;
  int _count;

  int get id => _id;
  String get category => _category;
  String get name => _name;
  int get price => _price;
  int get count => _count;

  Product(this._id, this._category, this._name, this._price, this._count);

  @override
  String toString() {
    return "$id\t$category\t$name\t$price рублей\t$count шт";
  }
}

abstract class Filter {
  bool apply(Product product);
}

class FilterByCategory implements Filter {
  String _category;

  FilterByCategory(this._category);

  @override
  bool apply(Product product) {
    return product.category == _category;
  }
}

class FilterByPriceLessOrEqual implements Filter {
  int _price;

  FilterByPriceLessOrEqual(this._price);

  @override
  bool apply(Product product) {
    return product.price <= _price;
  }
}

class FilterByCountLess implements Filter {
  int _count;

  FilterByCountLess(this._count);

  @override
  bool apply(Product product) {
    return product.count < _count;
  }
}

List<Product> applyFilter(List<Product> products, Filter filter) {
  return products.where(filter.apply).toList();
}

List<Product> parseProducts(String text) {
  var result = <Product>[];
  text.split('\n').forEach((line) {
    final parts = line.split(',').map((s) => s.trim()).toList();
    if (parts.length == 5) {
      // parse parts
      final id = int.parse(parts[0]);
      final category = parts[1];
      final name = parts[2];
      final price = int.parse(parts[3]);
      final count = int.parse(parts[4]);
      // add new object
      result.add(Product(id, category, name, price, count));
    }
  });
  return result;
}

void printProducts(String title, List<Product> products) {
  print(title);
  products.forEach(print);
}

void main() {
  final articles = '''
  1,хлеб,Бородинский,500,5
  2,хлеб,Белый,200,15
  3,молоко,Полосатый кот,50,53
  4,молоко,Коровка,50,53
  5,вода,Апельсин,25,100
  6,вода,Бородинский,500,5
  ''';
  final products = parseProducts(articles);
  final byCategory = applyFilter(products, FilterByCategory("молоко"));
  final byPrice = applyFilter(products, FilterByPriceLessOrEqual(500));
  final byCount = applyFilter(products, FilterByCountLess(10));
  printProducts("По категории \"молоко\"", byCategory);
  printProducts("По цене <= 500", byPrice);
  printProducts("По кол-ву < 10", byCount);
}