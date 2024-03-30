import 'package:awesome_dialog/awesome_dialog.dart';

Future customDialog(context, String title, String desc) {
  return AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          showCloseIcon: true,
          title: title,
          desc: desc,
          autoHide: const Duration(milliseconds: 500),
          // onDismissCallback: (type) => Navigator.pop(context),
          // autoDismiss: false,

          // btnCancelOnPress: () {},
          btnOkOnPress: () {
            // Navigator.pop(context);
            // setState(() {});
          })
      .show();
}
