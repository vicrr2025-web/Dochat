import 'package:flutter/cupertino.dart';

import 'package:dochat_app/l10n/app_localizations.dart';

class ImagePickerSheet extends StatelessWidget {
  const ImagePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, 'camera'),
          child: Text(l10n.takePhoto),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, 'album'),
          child: Text(l10n.chooseFromAlbum),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(l10n.cancel),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
