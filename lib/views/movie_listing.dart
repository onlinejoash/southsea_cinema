import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
            style: TextStyle(fontSize: 24),),
            const SizedBox(height:20),
            const Text('An absurdist comedy-drama about an exhausted Chinese-American laundromat owner who must save the multiverse by connecting with alternate versions of her life'),
            const SizedBox(height:25),
            Row(
              children: [
                const Text('2 Hours and 19 Minutes'),
                const SizedBox(width:10),
                const Text('Comedy/Drama'),
              ],)
          ],
        )
      ),
    );
  }
}
