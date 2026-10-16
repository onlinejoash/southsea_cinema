import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

// build function
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaBackground,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      color: cinemaBrandDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(width: 5),
                Text('(${movie.ageRating})',
                    style:
                        const TextStyle(color: cinemaFontMuted, fontSize: 9)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  movie.imagePath,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    movie.synopsis,
                    style: TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text("BOOK TICKETS"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(movie.screeningTime),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cinemaBrand,
                    foregroundColor: cinemaFontWhite,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MovieListing(
                            movie: movie,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('BOOK NOW'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
