import 'package:flutter/material.dart';
import 'package:pks9/pages/home_page.dart';
import 'package:pks9/pages/favorites_page.dart';
import 'package:pks9/pages/profile_page.dart';
import 'package:pks9/pages/cart_page.dart';
import 'model/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Car> _favoriteCars = [];
  List<CartItem> _cartItems = [];

  void _toggleFavorite(Car car) {
    setState(() {
      if (_favoriteCars.contains(car)) {
        _favoriteCars.remove(car);
      } else {
        _favoriteCars.add(car);
      }
    });
  }

  void _addToCart(Car car) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.car.id == car.id);
      if (index != -1) {
        _cartItems[index].quantity += 1;
      } else {
        _cartItems.add(CartItem(car: car, quantity: 1));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${car.title} добавлен в корзину")),
    );
  }

  void _removeFromCart(Car car) {
    setState(() {
      _cartItems.removeWhere((item) => item.car.id == car.id);
    });
  }

  void _updateCartItemQuantity(Car car, int quantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.car.id == car.id);
      if (index != -1) {
        _cartItems[index].quantity = quantity;
        if (_cartItems[index].quantity <= 0) {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onEdit(Car car) {
    print('Редактирование машины: ${car.title}');
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HomePage(
        onFavoriteToggle: _toggleFavorite,
        favoriteCars: _favoriteCars,
        onAddToCart: _addToCart,
        onEdit: _onEdit,
      ),
      FavoritesPage(
        favoriteCars: _favoriteCars,
        onFavoriteToggle: _toggleFavorite,
        onAddToCart: _addToCart,
        onEdit: _onEdit,
      ),
      CartPage(
        cartItems: _cartItems,
        onRemove: _removeFromCart,
        onUpdateQuantity: _updateCartItemQuantity,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.grey[200],
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
