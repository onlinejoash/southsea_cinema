import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

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
      ),
      drawer: const NavDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Everything Everywhere All at Once (2022) (15)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
            const SizedBox(height:20),
            const Text('An absurdist comedy-drama about an exhausted Chinese-American laundromat owner who must save the multiverse by connecting with alternate versions of her life'),
            const SizedBox(height:25),
            Row(
              children: [
                const Text('2 Hours and 19 Minutes'),
                const SizedBox(width:10),
                const Text('Comedy/Drama'),
              ],),
            const SizedBox(height:20),
            const Text('Tickets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
            const SizedBox(height:10),
            Row(
              children: [
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
               dropdownMenuEntries: [
                DropdownMenuEntry(value: 0, label: '0'),
                DropdownMenuEntry(value: 1, label: '1'),
                DropdownMenuEntry(value: 2, label: '2'),
                DropdownMenuEntry(value: 3, label: '3'),
                DropdownMenuEntry(value: 4, label: '4'),
                DropdownMenuEntry(value: 5, label: '5')
               ],
               inputDecorationTheme: const InputDecorationThemeData(
                filled: true,
                fillColor:  cinemaFontWhite,
               ),
               textStyle: const TextStyle(
                color: Colors.black,
               ),
            ),
            const SizedBox(width:10),
            const Text('Adult (£7.50)'),
          ],),
          const SizedBox(height:20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cinemaBrand
            ),
            onPressed: () {
              setState(() {
                _orderAdded = true;
              });
            },
            child: const Text('ADD TO ORDER',
            style: TextStyle(color: Colors.white),),
          ),
          if (_orderAdded) ...[ //spread operator
              const SizedBox(height:12),
                Text('Confirmed! You have selected $_ticketQuantity tickets.'),
          ],
          ],
        )
      ),
    );
  }
}
