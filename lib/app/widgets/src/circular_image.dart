import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularImage extends StatelessWidget {
  final String displayName;
  final String imageUrl;
  final BorderRadius borderRadius;

  const CircularImage({
    Key key,
    @required this.imageUrl,
    @required this.displayName,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(50),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        errorWidget: (_, __, ___) => _ColoredLetter(
          letter: displayName.trim()[0],
        ),
        placeholder: (_, __) => _ColoredLetter(letter: displayName.trim()[0]),
      ),
    );
  }
}

class _ColoredLetter extends StatelessWidget {
  final String letter;

  const _ColoredLetter({
    Key key,
    this.letter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.pink.shade300,
      child: Text(
        letter ?? 'G',
        style: GoogleFonts.raleway(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
