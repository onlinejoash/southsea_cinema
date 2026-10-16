import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({
    super.key,
    required this.movie,
  });

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _ticketQuantity = 0;
  bool _orderAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const NavDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text(
              '${widget.movie.title} (${widget.movie.ageRating})',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              widget.movie.imagePath,
              width: 100,
              height: 140,
              fit: BoxFit.cover,
            ),
            const Text('Southsea Cinema Room'),
            Text(widget.movie.screeningTime),
            Text(widget.movie.synopsis),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tickets (${widget.movie.formattedPrice} each)',
                  ),
                ),
                DropdownMenu<int>(
                  initialSelection: _ticketQuantity,
                  onSelected: (int? value) {
                    if (value != null) {
                      setState(() {
                        _ticketQuantity = value;
                        _orderAdded = false;
                      });
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 0, label: '0'),
                    DropdownMenuEntry(value: 1, label: '1'),
                    DropdownMenuEntry(value: 2, label: '2'),
                    DropdownMenuEntry(value: 3, label: '3'),
                    DropdownMenuEntry(value: 4, label: '4'),
                    DropdownMenuEntry(value: 5, label: '5'),
                  ],
                  inputDecorationTheme: const InputDecorationThemeData(
                    filled: true,
                    fillColor: cinemaFontWhite,
                  ),
                  textStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cinemaBrand,
              ),
              onPressed: () {
                if (_ticketQuantity > 0) {
                  setState(() {
                    _orderAdded = true;
                  });
                }
              },
              child: const Text(
                'ADD TO ORDER',
                style: TextStyle(
                  color: cinemaFontWhite,
                ),
              ),
            ),
            if (_orderAdded)
              Text(
                'Confirmed! You have selected $_ticketQuantity tickets.',
              ),
          ],
        ),
      ),
    );
  }
}
