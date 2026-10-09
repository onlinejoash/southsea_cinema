import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return const [
      Movie(
        id: 'everything-everywhere-all-at-once',
        title: 'Everything Everywhere All at Once',
        description: 'An absurdist comedy-drama about an exhausted Chinese-American laundromat owner who must save the multiverse by connecting with alternate versions of her life',
        ticketPrice: 7.50,
        imagePath: 'assets/images/EEAAO_Poster.png'),
      Movie(
        id: 'wicked',
        title: 'Wicked',
        description: 'Elphaba, a young woman ridiculed for her green skin, and Galinda, a popular girl, become friends at Shiz University in the Land of Oz. After an encounter with the Wonderful Wizard of Oz, their friendship reaches a crossroads.',
        ticketPrice: 7.50,
        imagePath: 'assets/images/Wicked_Poster.png')
    ]; // returns list of movie objects
  }
}