import 'package:flutter/material.dart';

// Main App
void main() => runApp(new App());

// App Name
String appName = "Yet Another Tip Calculator";

// Root widget of the application
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: appName,
        theme: new ThemeData(
            primarySwatch: Colors.grey, textSelectionColor: Colors.black),
        home: new AppContainer(title: appName));
  }
}

// App Container
class AppContainer extends StatelessWidget {
  AppContainer({Key key, this.title}) : super(key: key);

  // App title
  final String title;

  // Text Editing Controllers
  final TextEditingController billAmountFieldController =
      new TextEditingController();
  final TextEditingController tipPercentageFieldController =
      new TextEditingController();
  final TextEditingController totalAmountFieldController =
      new TextEditingController();
  final TextEditingController tipAmountFieldController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 'App Bar' for the application
        appBar: new AppBar(
          title: new Text(title),
          elevation: 1.0,
        ),
        backgroundColor: Colors.grey[300],
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new InputFieldWidget(
                  billAmountFieldController: billAmountFieldController,
                  tipPercentageFieldController: tipPercentageFieldController,
                  totalAmountFieldController: totalAmountFieldController,
                  tipAmountFieldController: tipAmountFieldController),
            ),
            new Flexible(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ResetWidget(
                      billAmountFieldController: billAmountFieldController,
                      tipPercentageFieldController:
                          tipPercentageFieldController,
                      totalAmountFieldController: totalAmountFieldController,
                      tipAmountFieldController: tipAmountFieldController)
                ],
              ),
            ),
          ],
        ));
  }
}

// Widget that holds all the input fields
class InputFieldWidget extends StatefulWidget {
  InputFieldWidget(
      {Key key,
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController})
      : super(key: key);

  // Text Editing Controllers
  final TextEditingController billAmountFieldController;
  final TextEditingController tipPercentageFieldController;
  final TextEditingController totalAmountFieldController;
  final TextEditingController tipAmountFieldController;

  @override
  _InputFieldWidgetState createState() => new _InputFieldWidgetState(
      billAmountFieldController,
      tipPercentageFieldController,
      totalAmountFieldController,
      tipAmountFieldController);
}

// Holds the content & state of the input fields
class _InputFieldWidgetState extends State<InputFieldWidget> {
  _InputFieldWidgetState(
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController);

  // Value (State) placeholders
  double billAmount = 0.0;
  double totalAmount = 0.0;
  double tipAmount = 0.0;
  double tipPercentage = 15.0;

  // Input fields
  TextField billAmountField;
  TextField tipPercentageField;
  TextField totalAmountTextField;
  TextField tipAmountTextField;

  // Text Editing Controllers
  TextEditingController billAmountFieldController;
  TextEditingController tipPercentageFieldController;
  TextEditingController totalAmountFieldController;
  TextEditingController tipAmountFieldController;

  // Method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    tipPercentageFieldController.text = "15";

    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shrinkWrap: true,
      childAspectRatio: 2.0,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 40.0,
      crossAxisCount: 2,
      children: <Widget>[
        billAmountField = new TextField(
            controller: billAmountFieldController,
            autocorrect: false,
            maxLines: 1,
            decoration: new InputDecoration(labelText: "Billed Amount"),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              try {
                if (double.parse(value) > 0.0) {
                  billAmount = double.parse(value);
                } else {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Invalid Billed Amount."),
                      ));

                  // Reset billed amount back to 0
                  billAmount = 0.0;

                  // Reset calculated fields
                  tipAmountFieldController.clear();
                  totalAmountFieldController.clear();
                }

                if (billAmount > 0.0) {
                  if (tipPercentage >= 0.0 && tipPercentage <= 100.0) {
                    if (tipPercentage == 0.0) {
                      tipAmount = 0.0;
                    } else {
                      tipAmount = billAmount * (tipPercentage / 100.0);
                    }
                    totalAmount = tipAmount + billAmount;

                    tipAmountFieldController.text = tipAmount.toString();
                    totalAmountFieldController.text = totalAmount.toString();
                  }
                }
              } catch (exception) {
                billAmount = 0.0;
                tipAmount = 0.0;
                totalAmount = 0.0;

                billAmountFieldController.clear();
                tipAmountFieldController.clear();
                totalAmountFieldController.clear();

                if (tipPercentage >= 0.0 && tipPercentage <= 100.0) {
                  tipPercentage = 15.0;
                  tipAmountFieldController.text = tipPercentage.toString();
                }

                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                          "Invalid Bill Amount. " + exception.toString()),
                    ));
              }
            }),
        tipPercentageField = new TextField(
            controller: tipPercentageFieldController,
            autocorrect: false,
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: "Tip (\%)",
              hintText: "15",
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              try {
                if (double.parse(value) >= 0.0 &&
                    double.parse(value) <= 100.0) {
                  tipPercentage = double.parse(value);
                  if (billAmount > 0.0) {
                    if (tipPercentage == 0.0) {
                      tipAmount = 0.0;
                    } else {
                      tipAmount = billAmount * (tipPercentage / 100.0);
                    }

                    tipAmountFieldController.text = tipAmount.toString();
                    totalAmountFieldController.text =
                        (tipAmount + billAmount).toString();
                  }
                } else {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text(
                            "Invalid Tip Percentage. Resetting to default."),
                      ));

                  tipAmount = 0.0;
                  tipAmountFieldController.clear();

                  totalAmount = 0.0;
                  totalAmountFieldController.clear();

                  tipPercentage = 15.0;
                  tipPercentageFieldController.text = tipPercentage.toString();
                }
              } catch (exception) {
                tipAmount = 0.0;
                tipAmountFieldController.clear();

                totalAmount = 0.0;
                totalAmountFieldController.clear();

                tipPercentage = 15.0;
                tipPercentageFieldController.text = tipPercentage.toString();

                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                          "Invalid Tip Percentage. " + exception.toString()),
                    ));
              }
            }),
        totalAmountTextField = new TextField(
            controller: totalAmountFieldController,
            autocorrect: false,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              labelText: "Total Amount",
            ),
            onChanged: (String value) {
              try {
                if (double.parse(value) >= 0.0) {
                  totalAmount = double.parse(value);

                  if (billAmount > 0.0) {
                    tipPercentageFieldController.text =
                        (((totalAmount - billAmount) / billAmount) * 100)
                            .toString();
                    tipAmountFieldController.text =
                        (totalAmount - billAmount).toString();
                  } else {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("Bill Amount < 0.0"),
                        ));
                  }
                } else {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Invalid Total Amount."),
                      ));
                }
              } catch (exception) {
                tipAmount = 0.0;
                totalAmount = 0.0;

                tipAmountFieldController.clear();
                totalAmountFieldController.clear();

                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                          "Invalid Total Amount. " + exception.toString()),
                    ));
              }
            }),
        tipAmountTextField = new TextField(
          controller: tipAmountFieldController,
          autocorrect: false,
          maxLines: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
            labelText: "Tip Amount",
          ),
          onChanged: (String value) {
            try {
              if (double.parse(value) >= 0.0 &&
                  (billAmount > 0.0 || totalAmount > 0.0)) {
                tipAmount = double.parse(value);
                if (billAmount > 0.0) {
                  totalAmount = billAmount + tipAmount;
                }
              }
            } catch (exception) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                    content:
                        new Text("Invalid Tip Total. " + exception.toString()),
                  ));
            }
          },
        ),
      ],
    );
  }
}

// Widget that holds the Reset button
class ResetWidget extends StatelessWidget {
  ResetWidget(
      {Key key,
      this.billAmountFieldController,
      this.tipPercentageFieldController,
      this.totalAmountFieldController,
      this.tipAmountFieldController})
      : super(key: key);

  // Text Editing Controllers
  final TextEditingController billAmountFieldController;
  final TextEditingController tipPercentageFieldController;
  final TextEditingController totalAmountFieldController;
  final TextEditingController tipAmountFieldController;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MaterialButton(
          color: Colors.grey,
          height: 60.0,
          minWidth: 400.0,
          child: new Text("R E S E T",
              textAlign: TextAlign.center,
              style: new TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            billAmountFieldController.clear();
            tipAmountFieldController.clear();
            totalAmountFieldController.clear();
            tipPercentageFieldController.text = "15";
          }),
    );
  }
}
