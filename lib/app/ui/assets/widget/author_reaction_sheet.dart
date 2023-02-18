import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';

class AuthorReactionSheet extends StatefulWidget {
  final Map<String, List<Reaction>> reactionMapList;
  final List<ObjectReactions> listAllReactions;
  final String reactionId;
  final List<User> userList;
  const AuthorReactionSheet({
    Key? key,
    required this.reactionMapList,
    required this.listAllReactions,
    required this.reactionId,
    required this.userList,
  }) : super(key: key);

  @override
  _AuthorReactionSheetState createState() => _AuthorReactionSheetState();
}

class _AuthorReactionSheetState extends State<AuthorReactionSheet> {
  String reactionId = "";
  List<User> authorsReaction = [];

  void onTapReaction() {
    List<ObjectReactions> listReaction = [];
    List<User> listAuthor = [];

    listReaction.addAll(widget.listAllReactions.where((object) {
      return object.reaction.id == reactionId;
    }));

    listReaction.forEach((reaction) {
      listAuthor.add(widget.userList
          .firstWhere((user) => user.id == reaction.author!.id, orElse: () => User(reaction.author!.id)));
    });
    setState(() {
      authorsReaction = listAuthor;
    });
  }

  @override
  void initState() {
    super.initState();
    reactionId = widget.reactionId;
    onTapReaction();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.3,
      initialChildSize: 0.35,
      builder: (_, controller) => Container(
        child: ListView(
          controller: controller,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorsItem.black1F2329,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.SPACE_35),
                    topRight: Radius.circular(Dimens.SPACE_35),
                  )),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.SPACE_8,
                    horizontal: Dimens.SPACE_24,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: Dimens.SPACE_35,
                          child: Divider(
                            height: Dimens.SPACE_4,
                            color: ColorsItem.grey666B73,
                            thickness: Dimens.SPACE_3,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimens.SPACE_8,
                      ),
                      Container(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(widget.reactionMapList.length, (index) {
                              String key = widget.reactionMapList.keys.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    reactionId = widget.reactionMapList[key]!.first.id;
                                  });
                                  onTapReaction();
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        widget.reactionMapList[key]!.first.emoticon!,
                                        height: Dimens.SPACE_18,
                                        width: Dimens.SPACE_18,
                                      ),
                                      SizedBox(width: Dimens.SPACE_4),
                                      Text(
                                        (widget.reactionMapList[key]?.length.toString() ?? "1"),
                                        style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_14,
                                          color: ColorsItem.whiteE0E0E0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_5,
                                    vertical: Dimens.SPACE_4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: reactionId == widget.reactionMapList[key]!.first.id
                                        ? ColorsItem.black32373D
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(Dimens.SPACE_8),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimens.SPACE_8,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Divider(
              color: ColorsItem.grey666B73,
              height: Dimens.SPACE_2,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: ColorsItem.black1F2329,
              ),
              padding: EdgeInsets.symmetric(
                vertical: Dimens.SPACE_20,
                horizontal: Dimens.SPACE_20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(authorsReaction.length, (index) {
                    var author = authorsReaction[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: Dimens.SPACE_8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: Dimens.SPACE_8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2.0, color: Colors.white),
                            ),
                            child: CircleAvatar(
                              radius: Dimens.SPACE_18,
                              backgroundImage: CachedNetworkImageProvider(
                                author.avatar ?? "https://ui-avatars.com/api/?background=random&size=256&name=",
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Text(
                            author.fullName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: ColorsItem.whiteEDEDED,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
