import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class FileItem extends StatelessWidget {
  final String fileName;
  final String? authorName;
  final String fileCreated;
  final bool isAlreadyDownloaded;
  final void Function()? onOpen;
  final void Function()? onDownload;

  const FileItem({
    required this.fileName,
    this.authorName,
    required this.fileCreated,
    required this.isAlreadyDownloaded,
    this.onOpen,
    this.onDownload,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.fileZipper, size: Dimens.SPACE_18),
              SizedBox(width: Dimens.SPACE_12),
              Expanded(
                child: Text(
                  fileName,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16, color: ColorsItem.urlColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: Dimens.SPACE_12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${S.of(context).room_detail_file_uploader_label}:",
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                        color: ColorsItem.greyB8BBBF),
                  ),
                  SizedBox(height: Dimens.SPACE_4),
                  Text(
                    "$authorName",
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12, color: ColorsItem.urlColor),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: Dimens.SPACE_6),
          Row(
            children: [
              Expanded(
                child: Text(
                  fileCreated,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12, color: ColorsItem.greyB8BBBF),
                ),
              ),
              isAlreadyDownloaded
                  ? InkWell(
                      child: Text(
                        S.of(context).room_detail_open_file_label.toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            color: ColorsItem.green219653,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                      onTap: onOpen,
                    )
                  : InkWell(
                      child: Text(
                        S.of(context).room_detail_download_label.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          color: ColorsItem.orangeFB9600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      onTap: onDownload,
                    ),
            ],
          ),
          Divider(color: ColorsItem.grey666B73, height: Dimens.SPACE_30)
        ],
      ),
    );
  }
}
