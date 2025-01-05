import 'package:flutter/material.dart';
import 'package:tubes/style/color_style.dart';

class DetailNameDescription extends StatefulWidget {
  final String foodName;
  final String description;
  final int cookingTime;
  final String rating;

  const DetailNameDescription({
    Key? key,
    required this.foodName,
    required this.description,
    required this.cookingTime,
    required this.rating,
  }) : super(key: key);

  @override
  _DetailNameDescriptionState createState() => _DetailNameDescriptionState();
}

class _DetailNameDescriptionState extends State<DetailNameDescription> {
  bool isExpanded = false;

  String toPascalCaseWithSpaces(String text) {
    List<String> words = text.split(' '); // Split the string into words

    // Capitalize the first letter of each word and leave spaces
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() +
          words[i].substring(1).toLowerCase();
    }

    // Join the words back together with a space in between each word
    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Name
          Text(
            toPascalCaseWithSpaces(widget.foodName),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          // Description with "View More" feature
          LayoutBuilder(
            builder: (context, constraints) {
              final textSpan = TextSpan(
                text: widget.description,
                style: Theme.of(context).textTheme.bodySmall,
              );
              final textPainter = TextPainter(
                text: textSpan,
                maxLines: isExpanded
                    ? null
                    : 3, // Toggle maxLines between 3 and unlimited
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              final isTextOverflowing = textPainter.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Make sure the text is aligned left and right
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Align left and right
                    children: [
                      Expanded(
                        child: Text(
                          widget.description,
                          maxLines: isExpanded
                              ? null
                              : 3, // Max 3 lines if not expanded
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          textAlign: TextAlign.justify, // Justify the text
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  // Only show "View More" if the text is overflowing
                  if (isTextOverflowing)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded; // Toggle expanded state
                        });
                      },
                      child: Text(
                        isExpanded ? "View Less" : "View More",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Decorative Container Box with Row for rating and cooking time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorStyle.button5,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating with icon
                Row(
                  children: [
                    Icon(Icons.star,
                        color: const Color.fromARGB(255, 255, 210, 7),
                        size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ],
                ),

                // Cooking Time with icon
                Row(
                  children: [
                    Icon(Icons.access_time, color: ColorStyle.accent),
                    const SizedBox(width: 4),
                    Text(
                      widget.cookingTime > 0
                          ? "${widget.cookingTime} mins"
                          : "N/A",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
