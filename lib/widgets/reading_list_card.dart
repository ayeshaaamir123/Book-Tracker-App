import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/widgets/book_rating.dart';
import 'package:book_tracker/widgets/two_sided_rounded_button.dart';
import 'package:flutter/material.dart';

class ReadingListCard extends StatelessWidget {
  const ReadingListCard(
      {Key? key,
      this.image,
      this.title,
      this.author,
      this.rating = 4.5,
      this.buttonText,
      this.book,
      this.isBookRead,
      this.pressDetails,
      this.pressRead})
      : super(key: key);
  final String? image;
  final String? title;
  final String? author;
  final double? rating;
  final String? buttonText;
  final Book? book;
  final bool? isBookRead;
  final Function? pressDetails;
  final Function? pressRead;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 202,
      // height: 200,
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(29),
      //     boxShadow: const [
      //       BoxShadow(
      //           offset: Offset(0, 20), blurRadius: 20, color: Colors.black12)
      //     ]),
      // margin: const EdgeInsets.only(left: 24, bottom: 0),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 20),
                          blurRadius: 20,
                          color: Colors.black26)
                    ]),
                margin: const EdgeInsets.only(left: 24, bottom: 0),
              )),
          Positioned(
            top: 8,
            left: 32,
            child: Container(
              width: 90,
              height: 100,
              child: Image.network(
                image.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 5,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline)),
                  BookRating(score: (rating as double)),
                ],
              )),
          Positioned(
              top: 115,
              child: Container(
                height: 85,
                width: 202,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 4),
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: kBlackColor,
                                  overflow: TextOverflow.ellipsis),
                              children: [
                                TextSpan(
                                    text: '${title.toString()}\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis)),
                                TextSpan(
                                    text: author.toString(),
                                    style: TextStyle(color: kLightBlackColor))
                              ])),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            width: 100,
                            alignment: Alignment.center,
                            child: Text('Details'),
                          ),
                        ),
                        Expanded(
                            child: TwoSidedRoundedButton(
                                text: buttonText,
                                press: pressRead,
                                color: kLightPurple))
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
