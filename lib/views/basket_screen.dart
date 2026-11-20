import 'package:flutter/material.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/constants.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];

    for (final CartItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }

    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');

    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(
    CartRepository cart,
    List<CartItem> items,
  ) async {
    final String summary = _buildSummary(items);
    final double total = cart.getTotalDue();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();

      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );

      await database.insertBooking(booking);
      cart.clear();

      if (!mounted) {
        return;
      }

      setState(() {
        _confirmationMessage = 'Booking $bookingNumber saved';
      });

      _loadBookings();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _confirmationMessage = 'Could not save your booking: $error';
      });
    }
  }

  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final List<Widget> children = [];

    children.add(
      const Text(
        'Your basket',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );

    children.add(const SizedBox(height: 16));

    for (int index = 0; index < items.length; index++) {
      final CartItem item = items[index];
      children.add(_buildLineItem(cart, item, index));
    }

    children.add(const SizedBox(height: 24));

    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${cart.getSubtotal().toStringAsFixed(2)}',
      ),
    );

    children.add(
      _buildTotalRow(
        'Total to pay',
        '£${cart.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );

    children.add(const SizedBox(height: 24));

    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Checkout',
          onPressed: () {
            _checkout(cart, items);
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  String _confirmationMessage = '';
  List<Booking> _bookings = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();

      if (!mounted) {
        return;
      }

      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Could not load bookings: $error';
        _loading = false;
      });
    }
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('£${booking.total.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Text(booking.summary),
            const SizedBox(height: 4),
            Text(
              booking.date,
              style: const TextStyle(
                fontSize: 12,
                color: cinemaFontMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;

    if (items.isEmpty) {
      content = _buildEmptyState();
    } else {
      content = _buildBasketList(cart, items);
    }

    final Widget bookingsBody;

    if (_loading) {
      bookingsBody = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_errorMessage.isNotEmpty) {
      bookingsBody = Center(
        child: Text(_errorMessage),
      );
    } else if (_bookings.isEmpty) {
      bookingsBody = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      final List<Widget> bookingCards = [];

      for (final Booking booking in _bookings) {
        bookingCards.add(_buildBookingCard(booking));
      }

      bookingsBody = Column(
        children: bookingCards,
      );
    }

    final List<Widget> children = [];

    children.add(content);

    if (_confirmationMessage.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(
        Text(
          _confirmationMessage,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    children.add(const SizedBox(height: 24));

    children.add(
      const Text(
        'Past bookings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    children.add(const SizedBox(height: 12));
    children.add(bookingsBody);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Basket'),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLineItem(CartRepository cart, CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.movie.title}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text('£${item.lineTotal.toStringAsFixed(2)}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                cart.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;

    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
