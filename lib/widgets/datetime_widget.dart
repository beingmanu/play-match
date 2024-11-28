import 'package:flutter/material.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatefulWidget {
  final DateTime dateTime;
  final ValueChanged<DateTime> onChangedDate;
  final DateTime firstdate;
  final DateTime lastdate;
  const DateWidget({
    super.key,
    required this.dateTime,
    required this.onChangedDate,
    required this.firstdate,
    required this.lastdate,
  });

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    setDate();
  }

  @override
  void didUpdateWidget(covariant DateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDate();
  }

  void setDate() => setState(() {
        controller.text = widget.dateTime == null
            ? ''
            : DateFormat.yMd().format(widget.dateTime);
      });
  @override
  Widget build(BuildContext context) => FocusBuilder(
        onChangeVisibility: (isVisible) {
          if (isVisible) {
            selectDate(context);
            //s
          } else {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        focusNode: focusNode,
        builder: (hasFocus) => TextFormField(
          controller: controller,
          // validator: (value) => value?.isEmpty ? 'Is Required' : null,
          // ignore: prefer_const_constructors
          decoration: InputDecoration(
            prefixText: ' ',
            hintText: 'Date',
            prefixIcon: const Icon(Icons.calendar_today_rounded),
            border: InputBorder.none,
          ),
        ),
        key: null,
      );

  Future selectDate(BuildContext context) async {
    final dattime = await showDatePicker(
      context: context,
      initialDate: widget.dateTime,
      firstDate: widget.firstdate,
      lastDate: widget.lastdate,
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: theme.colorCompanion,
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                dialogBackgroundColor: theme.colorBackground,
                colorScheme: ColorScheme.light(primary: theme.colorCompanion)
                    .copyWith(secondary: theme.colorCompanion)),
            child: child!);
      },
    );
    if (dattime == null) return;

    widget.onChangedDate(dattime);
  }
}

class DateTimeWidget extends StatefulWidget {
  final DateTime dateTime;
  final ValueChanged<DateTime> onChangedDate;
  final DateTime firstdate;
  final DateTime lastdate;
  const DateTimeWidget({
    super.key,
    required this.dateTime,
    required this.onChangedDate,
    required this.firstdate,
    required this.lastdate,
  });

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final dateFocusNode = FocusNode();
  final timeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setDateAndTime();
  }

  @override
  void didUpdateWidget(covariant DateTimeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDateAndTime();
  }

  void setDateAndTime() => setState(() {
        dateController.text = widget.dateTime == null
            ? ''
            : DateFormat.yMd().format(widget.dateTime);
        timeController.text = widget.dateTime == null
            ? ''
            : DateFormat.Hm().format(widget.dateTime);
      });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: FocusBuilder(
              onChangeVisibility: (isVisible) {
                if (isVisible) {
                  selectDate(context);
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              focusNode: dateFocusNode,
              builder: (hasFocus) => TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  hintText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FocusBuilder(
              onChangeVisibility: (isVisible) {
                if (isVisible) {
                  selectTime(context);
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              focusNode: timeFocusNode,
              builder: (hasFocus) => TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Time',
                  prefixIcon: Icon(Icons.schedule_rounded),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      );

  Future selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.dateTime,
      firstDate: widget.firstdate,
      lastDate: widget.lastdate,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
            primaryColor: theme.colorCompanion,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogBackgroundColor: theme.colorBackground,
            colorScheme: ColorScheme.light(primary: theme.colorCompanion)
                .copyWith(secondary: theme.colorCompanion)),
        child: child!,
      ),
    );
    if (date == null) return;

    final newDateTime = DateTime(date.year, date.month, date.day,
        widget.dateTime.hour, widget.dateTime.minute);
    widget.onChangedDate(newDateTime);
  }

  Future selectTime(BuildContext context) async {
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.dateTime),
        builder: (context, child) => Theme(
              data: ThemeData.light().copyWith(
                  primaryColor: theme.colorCompanion,
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  dialogBackgroundColor: theme.colorBackground,
                  colorScheme: ColorScheme.light(primary: theme.colorCompanion)
                      .copyWith(secondary: theme.colorCompanion)),
              child: child!,
            ));
    if (time == null) return;

    final newDateTime = DateTime(widget.dateTime.year, widget.dateTime.month,
        widget.dateTime.day, time.hour, time.minute);
    widget.onChangedDate(newDateTime);
  }
}

class FocusBuilder extends StatefulWidget {
  final FocusNode focusNode;
  final Widget Function(bool hasFocus) builder;
  final ValueChanged<bool> onChangeVisibility;

  const FocusBuilder({
    required this.focusNode,
    required this.builder,
    required this.onChangeVisibility,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FocusBuilderState createState() => _FocusBuilderState();
}

class _FocusBuilderState extends State<FocusBuilder> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChangeVisibility(true),
        child: Focus(
          focusNode: widget.focusNode,
          onFocusChange: widget.onChangeVisibility,
          child: widget.builder(widget.focusNode.hasFocus),
        ),
      );
}
